Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751176AbaEAGBb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:01:31 -0400
Received: from gn237.zone.eu ([217.146.67.237]:45417 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750741AbaEAGB3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:01:29 -0400
X-Greylist: delayed 386 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 May 2014 02:01:28 EDT
From: "Priit Laes" <plaes@plaes.org>
Message-ID: <1398924019.8330.11.camel@chi.lan>
Subject: Re: [linux-sunxi] [PATCH v5 0/3] ARM: sunxi: Add support for
 consumer infrared devices
To: linux-sunxi@googlegroups.com
Cc: david@hardeman.nu, devicetree@vger.kernel.org, galak@codeaurora.org,
        grant.likely@linaro.org, ijc+devicetree@hellion.org.uk,
        james.hogan@imgtec.com, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, m.chehab@samsung.com, mark.rutland@arm.com,
        maxime.ripard@free-electrons.com, pawel.moll@arm.com,
        rdunlap@infradead.org, robh+dt@kernel.org, sean@mess.org,
        srinivas.kandagatla@st.com, wingrime@linux-sunxi.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, Alexander Bersenev <bay@hackerdom.ru>
Date: Thu, 01 May 2014 09:00:19 +0300
In-Reply-To: <1398871010-30681-1-git-send-email-bay@hackerdom.ru>
References: <1398871010-30681-1-git-send-email-bay@hackerdom.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.12.1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ühel kenal päeval, K, 30.04.2014 kell 21:16, kirjutas Alexander
Bersenev:
> This patch introduces Consumer IR(CIR) support for sunxi boards.
> 
> This is based on Alexsey Shestacov's work based on the original driver 
> supplied by Allwinner.
> 
> Signed-off-by: Alexander Bersenev <bay@hackerdom.ru>
> Signed-off-by: Alexsey Shestacov <wingrime@linux-sunxi.org>

> ---
> Changes since version 1: 
>  - Fix timer memory leaks 
>  - Fix race condition when driver unloads while interrupt handler is active
>  - Support Cubieboard 2(need testing)
> 
> Changes since version 2:
> - More reliable keydown events
> - Documentation fixes
> - Rename registers accurding to A20 user manual
> - Remove some includes, order includes alphabetically
> - Use BIT macro
> - Typo fixes
> 
> Changes since version 3:
> - Split the patch on smaller parts
> - More documentation fixes
> - Add clock-names in DT
> - Use devm_clk_get function to get the clocks
> - Removed gpios property from ir's DT
> - Changed compatible from allwinner,sunxi-ir to allwinner,sun7i-a20-ir in DT
> - Use spin_lock_irq instead spin_lock_irqsave in interrupt handler
> - Add myself in the copyright ;)
> - Coding style and indentation fixes
> 
> Changes since version 4:
> - Try to fix indentation errors by sending patches with git send-mail

git am still complains due to mixed tabs-spaces used for indentation
> Alexander Bersenev (3):
>   ARM: sunxi: Add documentation for sunxi consumer infrared devices
Applying: ARM: sunxi: Add documentation for sunxi consumer infrared devices
/usr/src/linux/.git/rebase-apply/patch:28: space before tab in indent.
       	compatible = "allwinner,sun7i-a20-ir";
/usr/src/linux/.git/rebase-apply/patch:29: space before tab in indent.
       	clocks = <&apb0_gates 6>, <&ir0_clk>;
/usr/src/linux/.git/rebase-apply/patch:30: space before tab in indent.
       	clock-names = "apb0_ir0", "ir0";
/usr/src/linux/.git/rebase-apply/patch:31: space before tab in indent.
       	interrupts = <0 5 1>;
/usr/src/linux/.git/rebase-apply/patch:32: space before tab in indent.
       	reg = <0x01C21800 0x40>;
>   ARM: sunxi: Add driver for sunxi IR controller
OK
>   ARM: sunxi: Add IR controller support in DT on A20
Applying: ARM: sunxi: Add IR controller support in DT on A20
/usr/src/linux/.git/rebase-apply/patch:70: space before tab in indent.
       		ir0: ir@01c21800 {
/usr/src/linux/.git/rebase-apply/patch:71: space before tab in indent.
	     		compatible = "allwinner,sun7i-a20-ir";
/usr/src/linux/.git/rebase-apply/patch:79: space before tab in indent.
       		ir1: ir@01c21c00 {
/usr/src/linux/.git/rebase-apply/patch:80: space before tab in indent.
	     		compatible = "allwinner,sun7i-a20-ir";

