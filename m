Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933832AbaGVWa7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:30:59 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:43799 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932501AbaGVWa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:30:57 -0400
Date: Tue, 22 Jul 2014 15:30:53 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, Matt Porter <mporter@linaro.org>,
        devicetree@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Gregory Fong <gregory.0xf0@gmail.com>, Olof Johansson <olof@lixom.net>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH v8 00/11] ARM: brcmstb: Add Broadcom STB SoC support
Message-ID: <20140722223053.GH28323@ld-irv-0074>
References: <1405976886-27807-1-git-send-email-computersforpeace@gmail.com>
 <5044348.IEPQPrahyu@wuerfel>
 <20140722213350.GX2593@beef>
 <6456081.JRV4vu9CHq@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6456081.JRV4vu9CHq@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 23, 2014 at 12:24:23AM +0200, Arnd Bergmann wrote:
> On Tuesday 22 July 2014 17:33:50 Matt Porter wrote:
> > > > For the reset of mach-bcm stuff, I'll just send an arm-soc pull request
> > > > soon enough, unless Matt/Arnd/Olof object.
> > > 
> > > I'll wait for Matt to comment before pulling it, otherwise that sounds
> > > fine.
> > 
> > I'm fine with it, but we were asked to have one request for bcm5301x to
> > make life easy for the arm-soc team.

That's all news to me; thanks for the explanation.

> > If we want each platform to do pull
> > requests directly with arm-soc we should advise Hauke to do the same as
> > well with bcm5301x. I think the chances of Kconfig/Makefile conflicts are
> > relatively low as there's a dwindling amount of code of interest in new
> > platform mach directories like ours.
> > 
> > I would like to see a consistent path for all BCM platform maintainers.
> 
> Ok. Brian, please send the pull request or patches to Matt then.

Sure thing. I'll drop the 'select POWER_RESET_BRCMSTB' and also drop our
git tree from MAINTAINERS. I'll send v9 of the reboot driver separately,
targeted at Sebastian (or else to also defer to Matt's tree).

Thanks,
Brian
