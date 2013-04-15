Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab3DOSks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 14:40:48 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:42974 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755930Ab3DOSkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 14:40:47 -0400
Date: Mon, 15 Apr 2013 20:40:45 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>
Subject: Re: [GIT PULL REQUEST] watchdog - v3.9-rc6 Fixes
Message-ID: <20130415184045.GI14155@spo001.leaseweb.com>
References: <20130414071702.GH14155@spo001.leaseweb.com> <20130414122040.GA16009@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130414122040.GA16009@roeck-us.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

> > Please pull from 'master' branch of
> > 	git://www.linux-watchdog.org/linux-watchdog.git
> > 
> > It will fix compile errors for teh at91rm9200_wdt driver.
> > 
> > This will update the following files:
> > 
> >  Kconfig |    2 +-
> >  1 files changed, 1 insertion(+), 1 deletion(-)
> > 
> > with these Changes:
> > 
> > commit 09549cd01726a7ff8b102a93e46b059531583ab6
> > Author: Nicolas Ferre <nicolas.ferre@atmel.com>
> > Date:   Wed Apr 10 14:36:22 2013 +0200
> > 
> Hi Wim,
> 
> What is your take on "watchdog: Fix race condition in registration code" [1] ?
> 
> Thanks,
> Guenter
> 
> [1] http://www.spinics.net/lists/linux-watchdog/msg02291.html,
>     https://patchwork.kernel.org/patch/2400801/

Patch is the correct fix. I'll apply it later on.

Kind regards,
Wim.

