Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216Ab3GXMji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:39:38 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:44781 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab3GXMjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:39:36 -0400
Date: Wed, 24 Jul 2013 13:39:31 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tomasz Figa <tomasz.figa@gmail.com>
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org
Subject: [PATCH v2 07/22] ARM: Exynos4210: Remove '0x's from Exynos4110 DTSI
 file
Message-ID: <20130724123931.GL26801@laptop>
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374490361-25769-7-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

... for the sake of consistency and assumed convention.
    
Cc: Kukjin Kim <kgene.kim@samsung.com>
Cc: linux-samsung-soc@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/arch/arm/boot/dts/exynos4210.dtsi b/arch/arm/boot/dts/exynos4210.dtsi
index b7f358a..53e2527 100644
--- a/arch/arm/boot/dts/exynos4210.dtsi
+++ b/arch/arm/boot/dts/exynos4210.dtsi
@@ -72,7 +72,7 @@
                };
        };
 
-       clock: clock-controller@0x10030000 {
+       clock: clock-controller@10030000 {
                compatible = "samsung,exynos4210-clock";
                reg = <0x10030000 0x20000>;
                #clock-cells = <1>;
