Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957AbaEHP7m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 11:59:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58269 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754850AbaEHP7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 11:59:37 -0400
Message-ID: <536BA9E8.2030306@suse.de>
Date: Thu, 08 May 2014 17:59:36 +0200
From: =?ISO-8859-15?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>, linux-samsung-soc@vger.kernel.org
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgene.kim@samsung.com, arunkk.samsung@gmail.com
Subject: Re: [PATCH 1/2] ARM: dts: Enable USB 3503 hub on exynos5250-snow
References: <1399293056-17143-1-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1399293056-17143-1-git-send-email-gautam.vivek@samsung.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Am 05.05.2014 14:30, schrieb Vivek Gautam:
> The exynos5250-snow has a SMSC USB3503 connected in
> hardware only mode like a PHY. Enable support for it,
> and add necessary 'reset-gpio' for it.
> 
> This is in correspondance to similar patch by Mark Brown
> 7c1b0ec ARM: dts: Enable USB hub on Arndale
> 
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
> 
> Based on 'for-next' branch of kgene's linux-samsung tree.
> 
>  arch/arm/boot/dts/exynos5250-pinctrl.dtsi |    7 +++++++
>  arch/arm/boot/dts/exynos5250-snow.dts     |   14 ++++++++++++++
>  2 files changed, 21 insertions(+)

The same snippet as for snow also fixed my USB issues on spring.
Should it go into exynos5250-cros-common.dtsi instead?

Regards,
Andreas

-- 
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer; HRB 16746 AG Nürnberg
