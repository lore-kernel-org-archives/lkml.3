Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755850AbaIIBsv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 21:48:51 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17176 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674AbaIIBst (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 21:48:49 -0400
Message-ID: <540E5C6C.5060802@oracle.com>
Date: Tue, 09 Sep 2014 09:48:28 +0800
From: ethan zhao <ethan.zhao@oracle.com>
Organization: Oracle Corporation
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, gleb@kernel.org,
        pbonzini@redhat.com, kvm@vger.kernel.org, konrad.wilk@oracle.com,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, alex.williamson@redhat.com,
        alexander.h.duyck@intel.com, ethan.kernel@gmail.com
Subject: Re: [PATCH v3 0/4 resend] Introduce device assignment flag operation
 helper function
References: <1407476167-18935-1-git-send-email-ethan.zhao@oracle.com> <20140905171522.GA8080@google.com> <20140908170801.GP8080@google.com>
In-Reply-To: <20140908170801.GP8080@google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn,
    Thanks, will fix the building issue for new version and resend.

Ethan

On 2014/9/9 1:08, Bjorn Helgaas wrote:
> On Fri, Sep 05, 2014 at 11:15:22AM -0600, Bjorn Helgaas wrote:
>> On Fri, Aug 08, 2014 at 01:36:03PM +0800, Ethan Zhao wrote:
>>> This patch set introduces three PCI device flag operation helper functions
>>> when set pci device PF/VF to assigned or deassigned status also check it.
>>> and patch 2,3,4 apply these helper functions to KVM,XEN and PCI.
>>>
>>> v2: simplify unnecessory ternary operation in function pci_is_dev_assigned().
>>> v3: amend helper function naming.
>>>
>>> Appreciate suggestion from
>>> alex.williamson@redhat.com,
>>> david.vrabel@citrix.com,
>>> alexander.h.duyck@intel.com
>>>
>>> Resend for v3.16 building.
>>>
>>> Thanks,
>>> Ethan
>>> ---
>>> Ethan Zhao (4):
>>>    PCI: introduce helper functions for device flag operation
>>>    KVM: use pci device flag operation helper functions
>>>    xen-pciback: use pci device flag operation helper function
>>>    PCI: use device flag operation helper function in iov.c
>>>
>>>   drivers/pci/iov.c                  |    2 +-
>>>   drivers/xen/xen-pciback/pci_stub.c |    4 ++--
>>>   include/linux/pci.h                |   13 +++++++++++++
>>>   virt/kvm/assigned-dev.c            |    2 +-
>>>   virt/kvm/iommu.c                   |    4 ++--
>>>   5 files changed, 19 insertions(+), 6 deletions(-)
>>>
>> Applied to pci/virtualization for v3.18, thanks!
> I dropped these because of build errors from the kbuild-test robot.  Fix
> and resend if you still want them.
>
> Bjorn

