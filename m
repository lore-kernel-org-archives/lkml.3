Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993Ab3IIO4K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:56:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:52438 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753081Ab3IIO4H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:56:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,866,1371106800"; 
   d="scan'208";a="292605314"
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
Subject: RE: [PATCH 4/6] IB/qib: Use pcie_set_mps() and pcie_get_mps() to
 simplify code
Thread-Topic: [PATCH 4/6] IB/qib: Use pcie_set_mps() and pcie_get_mps() to
 simplify code
Thread-Index: AQHOrV5pylnREKNYskOHTMKyILBtpZm9fdBg
Date: Mon, 9 Sep 2013 14:55:46 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC2119F081@FMSMSX107.amr.corp.intel.com>
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
 <1378732388-4508-5-git-send-email-wangyijing@huawei.com>
In-Reply-To: <1378732388-4508-5-git-send-email-wangyijing@huawei.com>
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

> Subject: [PATCH 4/6] IB/qib: Use pcie_set_mps() and pcie_get_mps() to simplify
> code
> 
> Refactor qib_tune_pcie_caps() function, use pcie_set_mps() and
> pcie_get_mps() to simply code. Because pci core caches the "PCI-E Max
> Payload Size Supported" in pci_dev->pcie_mpss, so use that instead of
> pcie_capability_read_word(). Remove the unused val2fld() and fld2val().
> 

I tested this patch as is and saw no issues.

The only thing I would suggest is that the new use of pcie_get_readrq/pcie_set_readrq() be reflected in the comments with an appropriate adjustment in the subject.

Mike

 
