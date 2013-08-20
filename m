Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751586Ab3HTJal (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:30:41 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52685 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab3HTJaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:30:39 -0400
Date: Tue, 20 Aug 2013 11:30:34 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 09/33] ARM: ux500: Supply the I2C clocks lookup to the
 DBX500 DT
Message-ID: <20130820093034.GL31036@pengutronix.de>
Mail-Followup-To: Linus Walleij <linus.walleij@linaro.org>,
	Lee Jones <lee.jones@linaro.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Linus WALLEIJ <linus.walleij@stericsson.com>,
	Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
References: <1370521041-32318-1-git-send-email-lee.jones@linaro.org>
 <1370521041-32318-10-git-send-email-lee.jones@linaro.org>
 <CACRpkdbE86HgPr+7LZD9BFU_OsDFFFWTaFHW_i2fNXivKZ-3Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbE86HgPr+7LZD9BFU_OsDFFFWTaFHW_i2fNXivKZ-3Dw@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:27:58 up 20 days, 18:32, 44 users,  load average: 0.05, 0.06,
 0.06
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 11:11:19AM +0200, Linus Walleij wrote:
> On Thu, Jun 6, 2013 at 2:16 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > +++ b/arch/arm/boot/dts/dbx5x0.dtsi
> > @@ -572,6 +572,8 @@
> >                         v-i2c-supply = <&db8500_vape_reg>;
> >
> >                         clock-frequency = <400000>;
> > +                       clocks = <&prcc_kclk 3 3>, <&prcc_pclk 3 3>;
> > +                       clock-names = "nmk-i2c.0", "apb_pclk";

Why do most clocks in this series have the instance number in the clock
names? This looks very wrong to me.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
