Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaFDUEJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 16:04:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:34802 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751139AbaFDUEI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 16:04:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.98,974,1392192000"; 
   d="scan'208";a="549844423"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Julia Lawall <julia.lawall@lip6.fr>
CC: infinipath <infinipath@intel.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Roland Dreier <roland@kernel.org>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 9/10] IB/qib: use safer test on the result of
 find_first_zero_bit
Thread-Topic: [PATCH 9/10] IB/qib: use safer test on the result of
 find_first_zero_bit
Thread-Index: AQHPf9TDn7DxOifL6kaxD3HfCQ7N0JthSAGwgACBaoD//5b24A==
Date: Wed, 4 Jun 2014 20:03:58 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC21BE939B@fmsmsx120.amr.corp.intel.com>
References: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr>
 <1401872880-23685-10-git-send-email-Julia.Lawall@lip6.fr>
 <32E1700B9017364D9B60AED9960492BC21BE92E6@fmsmsx120.amr.corp.intel.com>
 <alpine.DEB.2.02.1406042118420.1977@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1406042118420.1977@localhost6.localdomain6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.107]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> No, it's not necessary.  It turns out that the result cannot be greater than the
> requested maximum value.
> 
> Julia

Ok. 

No stable then.

Mike
