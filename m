Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab3EVOuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 10:50:05 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:53461 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754565Ab3EVOuC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 10:50:02 -0400
Date: Wed, 22 May 2013 15:49:57 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com
Subject: [PATCH v2] ARM: ux500: Apply other compatible name to the u8540 DTS
 file
Message-ID: <20130522144957.GA18714@gmail.com>
References: <1369233402-19225-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369233402-19225-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARM: ux500: Apply other compatible name to the u8540 DTS file
    
Devices in board DTS files are usually searchable by multiple
compatible strings. In this case the 8540 based SoC should be
obtainable via the chipset [DB8540 & AB8540] name 'u8540' or
the board name 'ccu8540'. It's already possible to obtain the
Device Tree via its chipset name, this patch makes it possible
to get it by its board name too.
    
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/arch/arm/boot/dts/ccu8540.dts b/arch/arm/boot/dts/ccu8540.dts
index 18daa01..af4487f 100644
--- a/arch/arm/boot/dts/ccu8540.dts
+++ b/arch/arm/boot/dts/ccu8540.dts
@@ -14,7 +14,7 @@
 
 / {
 	model = "ST-Ericsson U8540 platform with Device Tree";
-	compatible = "st-ericsson,u8540";
+	compatible = "st-ericsson,ccu8540", "st-ericsson,u8540";
 
 	memory {
 		reg = <0x00000000 0x20000000>;
