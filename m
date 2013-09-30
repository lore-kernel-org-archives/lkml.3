Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab3I3O4m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 10:56:42 -0400
Received: from mga02.intel.com ([134.134.136.20]:9192 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941Ab3I3O4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 10:56:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1008,1371106800"; 
   d="scan'208";a="411868987"
From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Yijing Wang <wangyijing@huawei.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>, infinipath <infinipath@intel.com>,
        Roland Dreier <roland@kernel.org>,
        Roland Dreier <roland@purestorage.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
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
Thread-Index: AQHOrV5pylnREKNYskOHTMKyILBtpZnVcU0sgAkOGjA=
Date: Mon, 30 Sep 2013 14:56:37 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC211AE5BF@FMSMSX107.amr.corp.intel.com>
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
 <1378732388-4508-5-git-send-email-wangyijing@huawei.com>
 <32E1700B9017364D9B60AED9960492BC2119F081@FMSMSX107.amr.corp.intel.com>
 <20130924203806.GA9302@google.com>
In-Reply-To: <20130924203806.GA9302@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Is something like the following what you had in mind?  If so, I can
> just queue it up.  Otherwise, I'll wait for Yijing to post a v2 patch.
> 
> 
> IB/qib: Use pcie_set_mps() and pcie_get_mps() to simplify code
> 
> From: Yijing Wang <wangyijing@huawei.com>
> 
> Refactor qib_tune_pcie_caps().  Use pcie_get_mps(), pcie_set_mps(),
> pcie_get_readrq(), and pcie_set_readrq() to simplify the code.  The PCI
> core caches the "PCIe Max Payload Size Supported" in pci_dev->pcie_mpss,
> so use that instead of pcie_capability_read_word().  Remove the unused
> val2fld() and fld2val().
> 
> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>

This works!

Go ahead and queue it up.

Mike
