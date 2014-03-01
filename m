Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752848AbaCANje (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 08:39:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:57169 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512AbaCANjc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 08:39:32 -0500
Message-ID: <5311E2EB.70301@ti.com>
Date: Sat, 1 Mar 2014 19:08:51 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 5/5] phy: mvebu-sata: prepare new Dove DT Kconfig variable
References: <1393536486-3827-3-git-send-email-sebastian.hesselbarth@gmail.com> <1393662801-17950-5-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1393662801-17950-5-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 01 March 2014 02:03 PM, Sebastian Hesselbarth wrote:
> DT-enabled Dove will move over from ARCH_DOVE in mach-dove to MACH_DOVE in
> mach-mvebu. As non-DT ARCH_DOVE will stay to rot for a while, add a new
> DT-only MACH_DOVE Kconfig.
>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Kishon,
>
> Mark Brown requested to take the corresponding ASoC patch through
> his tree. Therefore, I have split the former patch into individual subsystem
> patches. This patch also received an update, to not break bisectability
> we add DT-enabled MACH_DOVE and maintain ARCH_DOVE, which is non-DT only
> after conversion. ARCH_DOVE will be removed, when legacy mach-dove will
> be removed.

Cool.. Should this patch be going through PHY tree?

Cheers
Kishon
>
> Cc: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>   drivers/phy/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index c7a551c2d5f1..e81daff7b5a3 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -24,7 +24,7 @@ config PHY_EXYNOS_MIPI_VIDEO
>
>   config PHY_MVEBU_SATA
>   	def_bool y
> -	depends on ARCH_KIRKWOOD || ARCH_DOVE
> +	depends on ARCH_KIRKWOOD || ARCH_DOVE || MACH_DOVE
>   	depends on OF
>   	select GENERIC_PHY
>
>

