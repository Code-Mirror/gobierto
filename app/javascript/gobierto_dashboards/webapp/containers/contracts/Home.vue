<template>
  <main>
    <div class="pure-g gutters m_b_4">
      <Aside
        :contracts-data="contractsData"
        :data-download-endpoint="dataDownloadEndpoint"
      />

      <div class="pure-u-1 pure-u-lg-3-4">
        <Nav
          :active-tab="activeTabIndex"
          @active-tab="setActiveTab"
        />
        <main class="dashboards-home-main">
          <Summary v-show="isSummary" />
          <ContractsIndex v-show="isContractsIndex" />
          <ContractsShow v-if="isContractsShow" />
          <AssigneesShow v-if="isAssigneesShow" />
        </main>
      </div>
    </div>
  </main>
</template>

<script>
import Nav from "./Nav.vue";
import Aside from "./Aside.vue";
import Summary from "./Summary.vue";
import ContractsIndex from "./ContractsIndex.vue";
import ContractsShow from "./ContractsShow.vue";
import AssigneesShow from "./AssigneesShow.vue";

import { EventBus } from "../../mixins/event_bus";
import { store } from "../../mixins/store";

export default {
  name: 'Home',
  components: {
    Aside,
    Nav,
    Summary,
    ContractsIndex,
    ContractsShow,
    AssigneesShow,
  },
  props: {
    dataDownloadEndpoint: {
      type: String,
      default: null
    }
  },
  data() {
    return {
      activeTabIndex: store.state.currentTab || 0,
      contractsData: this.$root.$data.contractsData,
    }
  },
  computed: {
    isSummary() { return this.$route.name === 'summary' },
    isContractsIndex() { return this.$route.name === 'contracts_index' },
    isContractsShow() { return this.$route.name === 'contracts_show' },
    isAssigneesShow() { return this.$route.name === 'assignees_show' },
  },
  created(){
    EventBus.$on('refresh-summary-data', () => {
      this.contractsData = this.$root.$data.contractsData;
    });
    EventBus.$on("update-filters", () => this.updateFilters());
    EventBus.$on("update-tab", () => this.updateTab());
  },
  methods: {
    setActiveTab(tabIndex) {
      this.activeTabIndex = tabIndex;
      store.addCurrentTab(tabIndex);

      if (this.isSummaryPage(tabIndex)) {
        EventBus.$emit("moved-to-summary");
      }
    },
    isSummaryPage(tabIndex){
      return tabIndex === 0
    },
    updateFilters() {
      const { name } = this.$route
      const components = ['contracts_show', 'assignees_show']
      if (components.includes(name)) {
        this.updateTab()
      }
    },
    updateTab() {
      // eslint-disable-next-line no-unused-vars
      this.$router.replace('/dashboards/contratos/adjudicaciones').catch(err => {})
      this.activeTabIndex = 1
    }
  }
}
</script>
