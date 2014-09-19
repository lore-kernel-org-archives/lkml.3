Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbaISMvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 08:51:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:21664 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754306AbaISMvI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 08:51:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,554,1406617200"; 
   d="scan'208";a="575682859"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
CC: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "roland@kernel.org" <roland@kernel.org>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] qib_keys: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Thread-Topic: [PATCH] qib_keys: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Thread-Index: AQHPuuCZcZ6LW7ziI0m3JJ4Xv0yQlpwImmZA
Date: Fri, 19 Sep 2014 12:51:06 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC21C4AF8B@fmsmsx120.amr.corp.intel.com>
References: <20140818123214.GA8174@ada>
In-Reply-To: <20140818123214.GA8174@ada>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: [PATCH] qib_keys: Replace rcu_assign_pointer() with
> RCU_INIT_POINTER()
> 

I would prefer the summary be:
IB/qib: qib_remove_lkey()  Replace rcu_assign_pointer() with
> RCU_INIT_POINTER()

Otherwise the patch looks ok and has been tested.
