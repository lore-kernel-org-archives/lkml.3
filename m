Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934404Ab3BTRyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 12:54:47 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:46497 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933919Ab3BTRyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 12:54:45 -0500
Message-ID: <51250DDE.7010408@wwwdotorg.org>
Date: Wed, 20 Feb 2013 10:54:38 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>
CC: Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] memory: tegra_ahb_enable_smmu() depends on TEGRA_IOMMU_SMMU
References: <1360175666-8377-1-git-send-email-hdoyu@nvidia.com><5112A642.1020800@wwwdotorg.org><20130206.211635.744922728615926717.hdoyu@nvidia.com> <20130211.193034.1346903263789032239.hdoyu@nvidia.com>
In-Reply-To: <20130211.193034.1346903263789032239.hdoyu@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/11/2013 10:30 AM, Hiroshi Doyu wrote:
> Hiroshi Doyu <hdoyu@nvidia.com> wrote @ Wed, 06 Feb 2013 21:16:35 +0200 (EET):
> 
>> Hi Russell,
>>
>> Stephen Warren <swarren@wwwdotorg.org> wrote @ Wed, 6 Feb 2013 19:51:46 +0100:
>>
>>> On 02/06/2013 11:34 AM, Hiroshi Doyu wrote:
>>>> New SoC, Tegra114 also uses SMMU. Change tegra_ahb_enable_smmu()'s
>>>> dependency from ARCH_TEGRA_3x_SOC to TEGRA_IOMMU_SMMU. No need to edit
>>>> whenever a new Tegra SoC comes.
>>>>
>>>> The following combination caused build error, which this patch fixes.
>>>>
>>>> CONFIG_ARCH_TEGRA_2x_SOC=y
>>>> \# CONFIG_ARCH_TEGRA_3x_SOC is not set
>>>> CONFIG_ARCH_TEGRA_114_SOC=y
>>>>
>>>> drivers/iommu/tegra-smmu.c:485: undefined reference to 'tegra_ahb_enable_smmu'
>>>
>>> Tested-by: Stephen Warren <swarren@nvidia.com>
>>>
>>> Russell, I assume Hiroshi should upload this to your patch tracker? It's
>>> needed for 3.9.
>>
>> FYI: Submitted as:
>> http://www.arm.linux.org.uk/developer/patches/viewpatch.php?id=7640/1
> 
> Russell,
> 
> Is the above ok for you?
> Please let me know if still I need to do something.

Russell, will this patch make it into your tree for 3.9? Do you think it
should go through some other tree? Thanks.
