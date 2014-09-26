Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226AbaIZPBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 11:01:04 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:57169 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755644AbaIZPBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 11:01:00 -0400
MIME-Version: 1.0
X-Originating-IP: [2a01:e35:2434:4600:aca4:bf5e:39c6:55e8]
In-Reply-To: <20140926094827.GE28786@8bytes.org>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
 <1411483586-29304-3-git-send-email-a.motakis@virtualopensystems.com> <20140926094827.GE28786@8bytes.org>
From: Antonios Motakis <a.motakis@virtualopensystems.com>
Date: Fri, 26 Sep 2014 17:00:39 +0200
Message-ID: <CAG8rG2xJm+WQicO8+uR5Pqh4HO0kTambeGoYUAjA7qYYHNJT8w@mail.gmail.com>
Subject: Re: [PATCHv7 02/26] iommu: add capability IOMMU_CAP_NOEXEC
To: Joerg Roedel <joro@8bytes.org>
Cc: Alex Williamson <alex.williamson@redhat.com>,
        kvm-arm <kvmarm@lists.cs.columbia.edu>,
        Linux IOMMU <iommu@lists.linux-foundation.org>,
        VirtualOpenSystems Technical Team <tech@virtualopensystems.com>,
        KVM devel mailing list <kvm@vger.kernel.org>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Will Deacon <will.deacon@arm.com>,
        Kim Phillips <kim.phillips@freescale.com>,
        Eric Auger <eric.auger@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>, Joerg Roedel <jroedel@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <shuah.kh@samsung.com>, Thierry Reding <treding@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        "Upinder Malhi (umalhi)" <umalhi@cisco.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 26, 2014 at 11:48 AM, Joerg Roedel <joro@8bytes.org> wrote:
> On Tue, Sep 23, 2014 at 04:46:01PM +0200, Antonios Motakis wrote:
>> Some IOMMUs accept an IOMMU_NOEXEC protection flag in addition to
>> IOMMU_READ and IOMMU_WRITE. Expose this as an IOMMU capability.
>>
>> Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
>> ---
>>  include/linux/iommu.h | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/include/linux/iommu.h b/include/linux/iommu.h
>> index e1a644c..0433553 100644
>> --- a/include/linux/iommu.h
>> +++ b/include/linux/iommu.h
>> @@ -59,6 +59,7 @@ struct iommu_domain {
>>
>>  #define IOMMU_CAP_CACHE_COHERENCY    0x1
>>  #define IOMMU_CAP_INTR_REMAP         0x2     /* isolates device intrs */
>> +#define IOMMU_CAP_NOEXEC             0x3     /* IOMMU_NOEXEC flag */
>
> This changed recently to an enum, please rebase to latest iommu/next
> branch.
>
>
> With that change:
>
>         Acked-by: Joerg Roedel <jroedel@suse.de>
>
> for patches 1 and 2.
>

Ack


-- 
Antonios Motakis
Virtual Open Systems
