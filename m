Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaLRQAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 11:00:47 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:43841 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaLRQAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 11:00:45 -0500
Date: Thu, 18 Dec 2014 08:00:14 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@stlinux.com, a.zummo@towertech.it, rtc-linux@googlegroups.com,
        wim@iguana.be, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, arnd@arndb.de,
        David Paris <david.paris@st.com>
Subject: Re: [PATCH 6/8] watchdog: st_wdt: Add new driver for ST's LPC
 Watchdog
Message-ID: <20141218160014.GA16015@roeck-us.net>
References: <1418834727-1602-1-git-send-email-lee.jones@linaro.org>
 <1418834727-1602-7-git-send-email-lee.jones@linaro.org>
 <20141217180251.GA29914@roeck-us.net>
 <20141218082652.GP13885@x1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141218082652.GP13885@x1>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020201.5492FA46.062E,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 3
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 18, 2014 at 08:26:52AM +0000, Lee Jones wrote:
> On Wed, 17 Dec 2014, Guenter Roeck wrote:
> > On Wed, Dec 17, 2014 at 04:45:25PM +0000, Lee Jones wrote:
> > > Signed-off-by: David Paris <david.paris@st.com>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > 
> > Hi Lee and David,
> > 
> > I still have a couple of comments below. Sorry I didn't catch those earlier.
> > 
> > Thanks,
> > Guenter
> > 
> > > ---
> > >  drivers/watchdog/Kconfig  |  13 ++
> > >  drivers/watchdog/Makefile |   1 +
> > >  drivers/watchdog/st_wdt.c | 323 ++++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 337 insertions(+)
> > >  create mode 100644 drivers/watchdog/st_wdt.c
> 
> Chopping all the crud.
> 
> [...]
> 
> > > +static struct of_device_id st_wdog_match[] = {
> > > +	{
> > > +		.compatible = "st,stih407-lpc",
> > > +		.data = (void *)&stih407_syscfg,
> > 
> > Nitpick: typecast to and from void * is not necessary.
> 
> Actually that's not true, but it is superfluous in this case.
> 
Point taken. Would you agree to a more detailed "typecasting a pointer
to and from void * is not necessary" ?

Guenter
