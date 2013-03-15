Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab3COSnC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 14:43:02 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58465 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab3COSnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 14:43:00 -0400
Message-ID: <51436BB1.8060005@wwwdotorg.org>
Date: Fri, 15 Mar 2013 12:42:57 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 5/5] ARM: tegra: add spi nodes to Tegra114 DT
References: <1363204194-19487-1-git-send-email-ldewangan@nvidia.com> <1363204194-19487-6-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1363204194-19487-6-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2013 01:49 PM, Laxman Dewangan wrote:
> NVIDIA's Tegra114 has 6 spi controllers. These controllers are
> redesign on T114 with different register interface.

> diff --git a/arch/arm/boot/dts/tegra114.dtsi b/arch/arm/boot/dts/tegra114.dtsi

> +		reg = <0x7000d400 0x200>;
...
> +		reg = <0x7000d600 0x200>;
...
> +		reg = <0x7000d480 0x200>;
...
> +		reg = <0x7000da00 0x200>;
...
> +		reg = <0x7000dc00 0x200>;
...
> +		reg = <0x7000de00 0x200>;

I assume that third entry should be 0x7000d800 not 0x7000d480; the TRM
certainly thinks so. I fixed this up when I applied this patch.

I've applied the series to Tegra's for-3.10/dt branch. I made a few
node/property ordering changes for consistency, and some capitalization
fixes in the commit subjects/descriptions.
