Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaBSXLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 18:11:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:47654 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751227AbaBSXLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 18:11:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,508,1389772800"; 
   d="scan'208";a="458466635"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Roland Dreier <roland@kernel.org>, "Hefty, Sean" <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: RE: [PATCH 2/2] qib: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Thread-Topic: [PATCH 2/2] qib: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Thread-Index: AQHPLLswkRHifewfXkqpJRVXCq5IU5q9Nd/Q
Date: Wed, 19 Feb 2014 23:11:39 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211F62DC@FMSMSX107.amr.corp.intel.com>
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
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers using these two
> interfaces need to be updated to use the new pci_enable_msi_range() and
> pci_enable_msix_range() interfaces.
> 
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>

This worked fine!

Roland, can you fix up the subject to change qib to IB/qib when you merge it?

Acked-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
