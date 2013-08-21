Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561Ab3HUR3i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 13:29:38 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40041 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab3HUR3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 13:29:36 -0400
Message-ID: <5214F8FD.3070003@wwwdotorg.org>
Date: Wed, 21 Aug 2013 11:29:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: tegra: add Palmas pincontrol to Dalmore device
 tree
References: <1377088461-9499-1-git-send-email-ldewangan@nvidia.com> <1377088461-9499-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1377088461-9499-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/21/2013 06:34 AM, Laxman Dewangan wrote:
> Add Palmas pincontrol to Dalmore device tree and make following
> configuration as default:
> - Disable DVFS1 and DVFS2.
> - Set GPIO6 to gpio mode.

> diff --git a/arch/arm/boot/dts/tegra114-dalmore.dts b/arch/arm/boot/dts/tegra114-dalmore.dts

> +			palmas_pinctrl {
> +				compatible = "ti,tps65913-pinctrl";

A node name of "pinmux" would be more appropriate here, since the node
name should represent device type rather than device identity.

Aside from that, the series looks fine, but at this point will have to
wait for 3.13 I think, unless this series has a side-effect of fixing
some bug/regression. Can you please repost once 3.12-rc1 is out?
