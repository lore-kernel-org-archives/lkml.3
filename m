Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab3HVGAi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 02:00:38 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:18804 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753380Ab3HVGAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 02:00:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 21 Aug 2013 23:00:36 -0700
Message-ID: <5215ACD7.9060400@nvidia.com>
Date: Thu, 22 Aug 2013 11:46:55 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: tegra: add Palmas pincontrol to Dalmore device
 tree
References: <1377088461-9499-1-git-send-email-ldewangan@nvidia.com> <1377088461-9499-2-git-send-email-ldewangan@nvidia.com> <5214F8FD.3070003@wwwdotorg.org>
In-Reply-To: <5214F8FD.3070003@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 21 August 2013 10:59 PM, Stephen Warren wrote:
> On 08/21/2013 06:34 AM, Laxman Dewangan wrote:
>> Add Palmas pincontrol to Dalmore device tree and make following
>> configuration as default:
>> - Disable DVFS1 and DVFS2.
>> - Set GPIO6 to gpio mode.
>> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts
>> +			palmas_pinctrl {
>> +				compatible = "ti,tps65913-pinctrl";
> A node name of "pinmux" would be more appropriate here, since the node
> name should represent device type rather than device identity.
>
> Aside from that, the series looks fine, but at this point will have to
> wait for 3.13 I think, unless this series has a side-effect of fixing
> some bug/regression. Can you please repost once 3.12-rc1 is out?

Sure, I will correct the node name and post the patch later.

