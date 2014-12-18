Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751406AbaLRRUV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:20:21 -0500
Received: from mail-ob0-f180.google.com ([209.85.214.180]:41699 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaLRRUT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:20:19 -0500
Date: Thu, 18 Dec 2014 17:20:12 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, a.zummo@towertech.it, rtc-linux@googlegroups.com,
        wim@iguana.be, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, arnd@arndb.de,
        David Paris <david.paris@st.com>
Subject: Re: [PATCH 6/8] watchdog: st_wdt: Add new driver for ST's LPC
 Watchdog
Message-ID: <20141218172012.GC4525@x1>
References: <1418834727-1602-1-git-send-email-lee.jones@linaro.org>
 <1418834727-1602-7-git-send-email-lee.jones@linaro.org>
 <20141217180251.GA29914@roeck-us.net>
 <20141218082652.GP13885@x1>
 <20141218160014.GA16015@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141218160014.GA16015@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Dec 2014, Guenter Roeck wrote:

> On Thu, Dec 18, 2014 at 08:26:52AM +0000, Lee Jones wrote:
> > On Wed, 17 Dec 2014, Guenter Roeck wrote:
> > > On Wed, Dec 17, 2014 at 04:45:25PM +0000, Lee Jones wrote:
> > > > Signed-off-by: David Paris <david.paris@st.com>
> > > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > 
> > > Hi Lee and David,
> > > 
> > > I still have a couple of comments below. Sorry I didn't catch those earlier.
> > > 
> > > Thanks,
> > > Guenter
> > > 
> > > > ---
> > > >  drivers/watchdog/Kconfig  |  13 ++
> > > >  drivers/watchdog/Makefile |   1 +
> > > >  drivers/watchdog/st_wdt.c | 323 ++++++++++++++++++++++++++++++++++++++++++++++
> > > >  3 files changed, 337 insertions(+)
> > > >  create mode 100644 drivers/watchdog/st_wdt.c
> > 
> > Chopping all the crud.
> > 
> > [...]
> > 
> > > > +static struct of_device_id st_wdog_match[] = {
> > > > +	{
> > > > +		.compatible = "st,stih407-lpc",
> > > > +		.data = (void *)&stih407_syscfg,
> > > 
> > > Nitpick: typecast to and from void * is not necessary.
> > 
> > Actually that's not true, but it is superfluous in this case.
> > 
> Point taken. Would you agree to a more detailed "typecasting a pointer
> to and from void * is not necessary" ?

Sure, why not? ;)

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
