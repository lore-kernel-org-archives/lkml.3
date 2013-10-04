Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab3JDUuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 16:50:04 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:52150 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab3JDUuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 16:50:00 -0400
MIME-Version: 1.0
In-Reply-To: <32E1700B9017364D9B60AED9960492BC211AE5BF@FMSMSX107.amr.corp.intel.com>
References: <1378732388-4508-1-git-send-email-wangyijing@huawei.com>
 <1378732388-4508-5-git-send-email-wangyijing@huawei.com> <32E1700B9017364D9B60AED9960492BC2119F081@FMSMSX107.amr.corp.intel.com>
 <20130924203806.GA9302@google.com> <32E1700B9017364D9B60AED9960492BC211AE5BF@FMSMSX107.amr.corp.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 4 Oct 2013 14:49:39 -0600
Message-ID: <CAErSpo41332ti7m=BTSWik_DrGzpqNOc0zwDde_iYmr696gZUQ@mail.gmail.com>
Subject: Re: [PATCH 4/6] IB/qib: Use pcie_set_mps() and pcie_get_mps() to
 simplify code
To: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Chris Metcalf <cmetcalf@tilera.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 8:56 AM, Marciniszyn, Mike
<mike.marciniszyn@intel.com> wrote:
>>
>> Is something like the following what you had in mind?  If so, I can
>> just queue it up.  Otherwise, I'll wait for Yijing to post a v2 patch.
>>
>>
>> IB/qib: Use pcie_set_mps() and pcie_get_mps() to simplify code
>>
>> From: Yijing Wang <wangyijing@huawei.com>
>>
>> Refactor qib_tune_pcie_caps().  Use pcie_get_mps(), pcie_set_mps(),
>> pcie_get_readrq(), and pcie_set_readrq() to simplify the code.  The PCI
>> core caches the "PCIe Max Payload Size Supported" in pci_dev->pcie_mpss,
>> so use that instead of pcie_capability_read_word().  Remove the unused
>> val2fld() and fld2val().
>>
>> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
>> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
>
> This works!
>
> Go ahead and queue it up.

Applied to my pci/yijing-mps-v1 branch with your ack:

http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/commit/?h=pci/yijing-mps-v1&id=0ce0e62f1f7893f983a8f61bc8f5306e80d520b1

Let me know if that's not what you had in mind.  Thanks!

Bjorn
