Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3GSENP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 00:13:15 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:51803 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750910Ab3GSENN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 00:13:13 -0400
Message-ID: <51E8BCD0.8050101@ozlabs.ru>
Date: Fri, 19 Jul 2013 14:13:04 +1000
From: Alexey Kardashevskiy <aik@ozlabs.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Graf <agraf@suse.de>
CC: Alexey Kardashevskiy <aik@ozlabs.ru>, linuxppc-dev@lists.ozlabs.org,
        David Gibson <david@gibson.dropbear.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm-ppc@vger.kernel.org
Subject: Re: [PATCH 00/10 v6] KVM: PPC: IOMMU in-kernel handling
References: <1373936045-22653-1-git-send-email-aik@ozlabs.ru>
In-Reply-To: <1373936045-22653-1-git-send-email-aik@ozlabs.ru>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2013 10:53 AM, Alexey Kardashevskiy wrote:
> The changes are:
> 1. rebased on v3.11-rc1 so the capability numbers changed again
> 2. fixed multiple comments from maintainers
> 3. "KVM: PPC: Add support for IOMMU in-kernel handling" is split into
> 2 patches, the new one is "powerpc/iommu: rework to support realmode".
> 4. IOMMU_API is now always enabled for KVM_BOOK3S_64.
> 
> MOre details in the individual patch comments.
> 
> Depends on "hashtable: add hash_for_each_possible_rcu_notrace()",
> posted a while ago.
> 
> 
> Alexey Kardashevskiy (10):
>   KVM: PPC: reserve a capability number for multitce support
>   KVM: PPC: reserve a capability and ioctl numbers for realmode VFIO



Alex, could you please pull these 2 patches or tell what is wrong with
them? Having them sooner in the kernel would let me ask for a headers
update for QEMU and then I would try pushing miltiple TCE and VFIO support
in QEMU. Thanks.




-- 
Alexey
