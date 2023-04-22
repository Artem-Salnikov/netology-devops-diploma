
// this file has the baseline default parameters
{
  components: {
    myapp_service: {
      nodeport: 30080,
    },
    myapp_deployment: {
      rep: 'artemsalnikov',
      tag: 'myapp-nginx:latest',
    },
    }
    }