Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaKLK4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 05:56:37 -0500
Received: from mail-pd0-f172.google.com ([209.85.192.172]:44245 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbaKLK4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 05:56:35 -0500
Date: Wed, 12 Nov 2014 18:56:22 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Robin Gong <b38343@freescale.com>
Cc: kernel@pengutronix.de, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, linux@arm.linux.org.uk, sre@kernel.org,
        dbaryshkov@gmail.com, dwmw2@infradead.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        smoch@web.de
Subject: Re: [PATCH v4 0/3] add power off driver for i.mx6
Message-ID: <20141112105620.GM2704@dragon>
References: <1415780439-29728-1-git-send-email-b38343@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415780439-29728-1-git-send-email-b38343@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 04:20:36PM +0800, Robin Gong wrote:
> Resend the patchset  with the latest MAINTAINERS
> Add simple power off driver for i.mx6, including:
> - add basic imx-snvs-poweroff driver in drivers/power/reset
> - add device node in all dts files of i.mx6.
> - enable in config file
> 
> Change from v3:
> - disable poweroff driver in soc level dts and enable it in board level dts
> - replace 'EIO' with 'ENODEV' while of_iomap fail.
> Change from v2:
> - remove useless included head files
> - split device binding doc from dts patch
> - add description for the case that PMIC_ON_REQ not used as external power
>   control
> 
> Robin Gong (3):
>   ARM: dts: imx6: add pm_power_off support for i.mx6 chips
>   power: reset: imx-snvs-poweroff: add power off driver for i.mx6
>   ARM: configs: imx_v6_v7_defconfig: add power off driver

I'm fine with the series.  But before I take the patches, I need an ACK
from DT folks on the bindings.

Shawn
