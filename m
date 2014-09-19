Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756621AbaISMxw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 08:53:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:30514 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750924AbaISMxv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 08:53:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,554,1406617200"; 
   d="scan'208";a="478679292"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Andreea-Cristina Bernat <bernat.ada@gmail.com>
CC: "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        "roland@kernel.org" <roland@kernel.org>,
        "hal.rosenstock@gmail.com" <hal.rosenstock@gmail.com>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] qib: qib_qp: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Thread-Topic: [PATCH] qib: qib_qp: Replace rcu_assign_pointer() with
 RCU_INIT_POINTER()
Thread-Index: AQHPwTrMQC/0HK00oUadTysbcFvFdJwIjoJw
Date: Fri, 19 Sep 2014 12:53:48 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC21C4AFA4@fmsmsx120.amr.corp.intel.com>
References: <20140826143322.GA2498@ada>
In-Reply-To: <20140826143322.GA2498@ada>
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

> Subject: [PATCH] qib: qib_qp: Replace rcu_assign_pointer() with
> RCU_INIT_POINTER()
>

Why not consolidate this with http://marc.info/?l=linux-rdma&m=140836578119485&w=2 so there is just one patch?

Mike
