Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab3IIOv0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:51:26 -0400
Received: from mga14.intel.com ([143.182.124.37]:35738 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab3IIOvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:51:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,866,1371106800"; 
   d="scan'208";a="292603881"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Yijing Wang <wangyijing@huawei.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>, infinipath <infinipath@intel.com>,
        Roland Dreier <roland@kernel.org>,
        Roland Dreier <roland@purestorage.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Einon <mark.einon@gmail.com>,
        "Hefty, Sean" <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>
Subject: RE: [PATCH 3/6] IB/qib: Use pci_is_root_bus() to check whether it
 is a root bus
Thread-Topic: [PATCH 3/6] IB/qib: Use pci_is_root_bus() to check whether it
 is a root bus
Thread-Index: AQHOrV56l16arHMcB0O4sUx/wMt3QZm9fSAw
Date: Mon, 9 Sep 2013 14:51:17 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2119F067@FMSMSX107.amr.corp.intel.com>
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
 <1378732388-4508-4-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1378732388-4508-4-git-send-email-wangyijing@huawei.com>
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

> Subject: [PATCH 3/6] IB/qib: Use pci_is_root_bus() to check whether it is a root
> bus
> 

Thanks for the patch!

Acked-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
