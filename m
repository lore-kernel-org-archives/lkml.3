Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758064Ab3FCNyP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 09:54:15 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54733 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab3FCNyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 09:54:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        ulf.hansson@linaro.org
Subject: Re: [PATCH 08/21] ARM: ux500: Supply the I2C clocks lookup to the DBX500 DT
Date: Mon, 03 Jun 2013 15:54:07 +0200
Message-ID: <2199337.TqRF93pcHr@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.10.0-rc3-next-20130527+; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1370266965-7901-9-git-send-email-lee.jones@linaro.org>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org> <1370266965-7901-9-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:epQacR8IbHqj4mxewg0Hw7vea0AEwFgpnDU1cRG/vn/
 QuQ/W+E4DWNz1lmOqFXCcdx1LLM9qM4s8kAGEUPyo7u/TOnzSH
 H1jy5n7AfXWudEy20S4UUgOtL5FvG2Jp/gB8g2bJJn0B1L+ARh
 jLH7Muy6CY1a7cA/GMyfU7RDDqJOoBiwUC69r8yXEat5RpoShs
 9V+ygmafOyYYrgDi0Dah/03FoqodDSpYrHnvo/0crJ+hUqDXaA
 7BUF8DLJOTfcf0wWJiXpRHUZ5UfQusKj2Jsi/jyggy55V/s0iI
 CjvmuiSiIEXSUJ5UlCA5yfr2C9dn2IkMEjQYh1R23Ila4i4Boz
 Fu76rynP6B91+Jcdh9K0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 June 2013 14:42:32 Lee Jones wrote:
> @@ -559,6 +559,8 @@
>                         v-i2c-supply = <&db8500_vape_reg>;
>  
>                         clock-frequency = <400000>;
> +                       clocks = <&clk 100>, <&clk 67>;
> +                       clock-names = "nmk-i2c.0", "apb_pclk";
>                 };
>  
>                 i2c@80122000 {
> @@ -572,6 +574,9 @@
>                         v-i2c-supply = <&db8500_vape_reg>;
>  
>                         clock-frequency = <400000>;
> +
> +                       clocks = <&clk 85>, <&clk 42>;
> +                       clock-names = "nmk-i2c.1", "apb_pclk";
>                 };

Same comment actually as for the uart patch, also SDI and MSP
have the same problem.

	Arnd
