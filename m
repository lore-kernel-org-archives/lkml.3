Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756365AbaBRQwh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 11:52:37 -0500
Received: from mga01.intel.com ([192.55.52.88]:18806 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756218AbaBRQwe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 11:52:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,502,1389772800"; 
   d="scan'208";a="477132716"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: infinipath <infinipath@intel.com>, Roland Dreier <roland@kernel.org>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [PATCH 2/2] qib: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Thread-Topic: [PATCH 2/2] qib: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Thread-Index: AQHPLLswkRHifewfXkqpJRVXCq5IU5q7Ob8Q
Date: Tue, 18 Feb 2014 16:52:14 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211F5860@FMSMSX107.amr.corp.intel.com>
References: <cover.1392733151.git.agordeev@redhat.com>
 <f0eabd77b96e0d679ce6c2e2e544c73063c508ee.1392733151.git.agordeev@redhat.com>
In-Reply-To: <f0eabd77b96e0d679ce6c2e2e544c73063c508ee.1392733151.git.agordeev@redhat.com>
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

> Subject: [PATCH 2/2] qib: Use pci_enable_msix_range() instead of
> pci_enable_msix()
> 
We are testing this now.

I suggest a subject/summary adding the IB/:
IB/qib: Use pci_enable_msix_range() instead of pci_enable_msix()

