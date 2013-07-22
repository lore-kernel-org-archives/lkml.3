Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3GVNjA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 09:39:00 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:53991 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab3GVNi6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 09:38:58 -0400
Date: Mon, 22 Jul 2013 14:38:52 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Christian Daudt <csd@broadcom.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 05/22] ARM: dts: bcm281xx: Remove '0x's from BCM11351 BRT
 DTS file
Message-ID: <20130722133852.GA26801@laptop>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-5-git-send-email-lee.jones@linaro.org>
 <51ED2D90.4020209@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <51ED2D90.4020209@broadcom.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jul 2013, Christian Daudt wrote:

> On 13-07-22 03:52 AM, Lee Jones wrote:
> >Cc: Christian Daudt <csd@broadcom.com>
> >Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >---
> >  arch/arm/boot/dts/bcm11351-brt.dts | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> >diff --git a/arch/arm/boot/dts/bcm11351-brt.dts b/arch/arm/boot/dts/bcm11351-brt.dts
> >index 67ec524..fdace5d 100644
> >--- a/arch/arm/boot/dts/bcm11351-brt.dts
> >+++ b/arch/arm/boot/dts/bcm11351-brt.dts
> >@@ -27,18 +27,18 @@
> >  		status = "okay";
> >  	};
> >-	sdio0: sdio@0x3f180000 {
> >+	sdio0: sdio@3f180000 {
> >  		max-frequency = <48000000>;
> >  		status = "okay";
> >  	};
> >-	sdio1: sdio@0x3f190000 {
> >+	sdio1: sdio@3f190000 {
> >  		non-removable;
> >  		max-frequency = <48000000>;
> >  		status = "okay";
> >  	};
> >-	sdio3: sdio@0x3f1b0000 {
> >+	sdio3: sdio@3f1b0000 {
> >  		max-frequency = <48000000>;
> >  		status = "okay";
> >  	};
> Hi Lee,
>  Is this convention documented ? Someone called my attention to the
> fact that this dts files was inconsistent in its use of 0x in names,
> but I was not aware of a coding guideline for this.

The best two places I can think of are:

Documentation/devicetree/usage-model.txt
and
http://www.devicetree.org/Device_Tree_Usage

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
