Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932114AbaISMpA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 08:45:00 -0400
Received: from mga09.intel.com ([134.134.136.24]:44677 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756204AbaISMo6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 08:44:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,554,1406617200"; 
   d="scan'208";a="605366185"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
CC: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "roland@kernel.org" <roland@kernel.org>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] qib_qp: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Thread-Topic: [PATCH] qib_qp: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Thread-Index: AQHPuuHxJzHxIgdnCkS0tie0rTPZ8JwImCpw
Date: Fri, 19 Sep 2014 12:44:56 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC21C4AF6C@fmsmsx120.amr.corp.intel.com>
References: <20140818124246.GA18423@ada>
In-Reply-To: <20140818124246.GA18423@ada>
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

> Subject: [PATCH] qib_qp: Replace rcu_assign_pointer() with
> RCU_INIT_POINTER()
> 

I would prefer the summary line be:
IB/qib: remove_qp() use RCU_INIT_POINTER() instead of rcu_assign_pointer()

Otherwise I agree with the patch and I have tested it with large numbers of QPs.

Mike
