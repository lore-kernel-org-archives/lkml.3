Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab3FCO2D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 10:28:03 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:36556 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758040Ab3FCO2A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 10:28:00 -0400
Date: Mon, 3 Jun 2013 15:27:55 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com,
        ulf.hansson@linaro.org
Subject: Re: [PATCH 08/21] ARM: ux500: Supply the I2C clocks lookup to the
 DBX500 DT
Message-ID: <20130603142755.GH3370@gmail.com>
References: <1370266965-7901-1-git-send-email-lee.jones@linaro.org>
 <1370266965-7901-9-git-send-email-lee.jones@linaro.org>
 <2199337.TqRF93pcHr@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2199337.TqRF93pcHr@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 03 Jun 2013, Arnd Bergmann wrote:

> On Monday 03 June 2013 14:42:32 Lee Jones wrote:
> > @@ -559,6 +559,8 @@
> >                         v-i2c-supply = <&db8500_vape_reg>;
> >  
> >                         clock-frequency = <400000>;
> > +                       clocks = <&clk 100>, <&clk 67>;
> > +                       clock-names = "nmk-i2c.0", "apb_pclk";
> >                 };
> >  
> >                 i2c@80122000 {
> > @@ -572,6 +574,9 @@
> >                         v-i2c-supply = <&db8500_vape_reg>;
> >  
> >                         clock-frequency = <400000>;
> > +
> > +                       clocks = <&clk 85>, <&clk 42>;
> > +                       clock-names = "nmk-i2c.1", "apb_pclk";
> >                 };
> 
> Same comment actually as for the uart patch, also SDI and MSP
> have the same problem.

I was only using the names in the same manor as the API does, to fetch
the 'clocks =' index. Do you mean that I should be using 'uartclk',
'i2cclk', 'sdmmcclk' and 'msp1clk' instead?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
