Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaKJKuT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 05:50:19 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:64420 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752543AbaKJKuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 05:50:14 -0500
Message-ID: <1415616611.4862.38.camel@x220>
Subject: Re: [PATCH v9 4/8] ARM: dts: Enable Broadcom Cygnus SoC
From: Paul Bolle <pebolle@tiscali.nl>
To: Scott Branden <sbranden@broadcom.com>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        Mike Turquette <mturquette@linaro.org>, Alex Elder <elder@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Antti Palosaari <crope@iki.fi>, JD Zheng <jdzheng@broadcom.com>,
        Ray Jui <rjui@broadcom.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Date: Mon, 10 Nov 2014 11:50:11 +0100
In-Reply-To: <1414538111-11668-5-git-send-email-sbranden@broadcom.com>
References: <Scott Branden <sbranden@broadcom.com>
	 <1414538111-11668-1-git-send-email-sbranden@broadcom.com>
	 <1414538111-11668-5-git-send-email-sbranden@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2014 10:50:12.0443 (UTC) FILETIME=[1A78E2B0:01CFFCD4]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-28 at 16:15 -0700, Scott Branden wrote:
> DT files to enable cygnus consisting on reference designs
> and cygnus core configuration.
> 
> Reviewed-by: Ray Jui <rjui@broadcom.com>
> Reviewed-by: Arun Parameswaran <aparames@broadcom.com>
> Tested-by: Jonathan Richardson <jonathar@broadcom.com>
> Reviewed-by: JD (Jiandong) Zheng <jdzheng@broadcom.com>
> Signed-off-by: Scott Branden <sbranden@broadcom.com>

This landed in today's linux-next (ie, next-21041110) as commit
8872fc22c267 ("ARM: dts: Enable Broadcom Cygnus SoC").

>  arch/arm/boot/dts/Makefile              |    4 ++
>  arch/arm/boot/dts/bcm-cygnus-clock.dtsi |   73 ++++++++++++++++++++++
>  arch/arm/boot/dts/bcm-cygnus.dtsi       |  100 +++++++++++++++++++++++++++++++
>  arch/arm/boot/dts/bcm911360_entphn.dts  |   32 ++++++++++
>  arch/arm/boot/dts/bcm911360k.dts        |   32 ++++++++++
>  arch/arm/boot/dts/bcm958300k.dts        |   32 ++++++++++
>  6 files changed, 273 insertions(+)
>  create mode 100644 arch/arm/boot/dts/bcm-cygnus-clock.dtsi
>  create mode 100644 arch/arm/boot/dts/bcm-cygnus.dtsi
>  create mode 100644 arch/arm/boot/dts/bcm911360_entphn.dts
>  create mode 100644 arch/arm/boot/dts/bcm911360k.dts
>  create mode 100644 arch/arm/boot/dts/bcm958300k.dts
> 
> diff --git a/arch/arm/boot/dts/Makefile b/arch/arm/boot/dts/Makefile
> index 38c89ca..4b3a590 100644
> --- a/arch/arm/boot/dts/Makefile
> +++ b/arch/arm/boot/dts/Makefile
> @@ -54,6 +54,10 @@ dtb-$(CONFIG_ARCH_AT91)	+= at91-sama5d4ek.dtb
>  dtb-$(CONFIG_ARCH_ATLAS6) += atlas6-evb.dtb
>  dtb-$(CONFIG_ARCH_AXXIA) += axm5516-amarillo.dtb
>  dtb-$(CONFIG_ARCH_BCM2835) += bcm2835-rpi-b.dtb
> +dtb-$(CONFIG_ARCH_BCM_CYGNUS) += \
> +	bcm911360_entphn.dtb \
> +	bcm911360k.dtb \
> +	bcm958300k.dtb
>  dtb-$(CONFIG_ARCH_BCM_5301X) += bcm4708-netgear-r6250.dtb
>  dtb-$(CONFIG_ARCH_BCM_63XX) += bcm963138dvt.dtb
>  dtb-$(CONFIG_ARCH_BCM_MOBILE) += bcm28155-ap.dtb \

Without patch 1/8 ("ARM: cygnus: Initial support for Broadcom Cygnus
SoC") CONFIG_ARCH_BCM_CYGNUS will not be set. I guess patch 1/8 will be
added to linux-next one of these days. Is that correct?


Paul Bolle

