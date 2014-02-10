Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751973AbaBJEcf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 23:32:35 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:59107 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751678AbaBJEce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 23:32:34 -0500
MIME-Version: 1.0
In-Reply-To: <1391976496.25855.19.camel@x220>
References: <1391971686-9517-1-git-send-email-richard@nod.at>
	<1391971686-9517-5-git-send-email-richard@nod.at>
	<1391976496.25855.19.camel@x220>
Date: Mon, 10 Feb 2014 10:02:33 +0530
Message-ID: <CAK9yfHzP0ekboc-yi6FHvR3_rRiqcLC18pE2UynpxGYO0mUOsw@mail.gmail.com>
Subject: Re: [PATCH 04/28] Remove EXYNOS_DEV_SYSMMU
From: Sachin Kamat <sachin.kamat@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Richard Weinberger <richard@nod.at>, Joerg Roedel <joro@8bytes.org>,
        "open list:IOMMU DRIVERS" <iommu@lists.linux-foundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+cc linux-samsung-soc list

On 10 February 2014 01:38, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Sun, 2014-02-09 at 19:47 +0100, Richard Weinberger wrote:
>> The symbol is an orphan, get rid of it.
>>
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>  drivers/iommu/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/iommu/Kconfig b/drivers/iommu/Kconfig
>> index 79bbc21..20d062d 100644
>> --- a/drivers/iommu/Kconfig
>> +++ b/drivers/iommu/Kconfig
>> @@ -178,7 +178,7 @@ config TEGRA_IOMMU_SMMU
>>
>>  config EXYNOS_IOMMU
>>       bool "Exynos IOMMU Support"
>> -     depends on ARCH_EXYNOS && EXYNOS_DEV_SYSMMU
>> +     depends on ARCH_EXYNOS
>>       select IOMMU_API
>>       help
>>         Support for the IOMMU(System MMU) of Samsung Exynos application
>
> I noted this one about a year ago (see
> https://lkml.org/lkml/2013/3/5/401 ). By now I wonder whether
> EXYNOS_IOMMU (and everything depending on it) shouldn't be removed. That
> code has been unbuildable for at least a year now  (I have not checked
> how much code is involved).


Please refer to some on-going discussion about it at [1].

[1] http://thread.gmane.org/gmane.linux.kernel.samsung-soc/26842

-- 
With warm regards,
Sachin
