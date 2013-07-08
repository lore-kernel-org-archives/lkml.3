Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab3GHHB6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 03:01:58 -0400
Received: from mail1.bemta3.messagelabs.com ([195.245.230.176]:40375 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753491Ab3GHHB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 03:01:56 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-4.tower-39.messagelabs.com!1373266912!11757544!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 08 Jul 2013 09:01:52 +0200
Date: Mon, 8 Jul 2013 09:06:45 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Wim Van Sebroeck <wim@iguana.be>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>,
        <linux-kernel@vger.kernel.org>, <linux-watchdog@vger.kernel.org>,
        <guenter@roeck-us.net>
Subject: Re: [PATCH RESEND v10 2/2] watchdog: Sysfs interface for MEN A21
 watchdog
Message-ID: <20130708070645.GB22574@jtlinux>
References: <20130618151939.GA23296@jtlinux>
 <20130618152119.GA23399@jtlinux>
 <20130705210321.GB10354@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130705210321.GB10354@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 08 Jul 2013 07:01:52.0429 (UTC) FILETIME=[063725D0:01CE7BA9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 11:03:21PM +0200, Wim Van Sebroeck wrote:
> Hi Johannes,
>
> > This patch adds a sysfs interface for the watchdog
> > device found on MEN A21 Boards.
> >
> > The newly generated files are:
> > * rebootcause:
> > Can be one of:
> > Power on Reset,
> > CPU Reset Request,
> > Push Button,
> > FPGA Reset Request,
> > Watchdog,
> > Local Power Bad,
> > Invalid or
> > BDI
> > and shows the reason of the boards last reboot.
> >
> > * active:
> > Shows if the watchdog CPLD is actually running
> >
> > * allow_disable:
> > Shows if the watchdog is allowed to be disabled (NOWAYOUT disabled)
>
> allow_disable should be nowayout because that is the general watchdog
> parameter we will have for all watchdog drivers.
>
> > * fastmode:
> > Shows if the CPLD is running in fast mode (1s timeout), once it is in
> > fastmode it can't be switched back to slow mode (30s timeout) until the
> > next reboot.
> >
> > Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
>
> I will not add this patch and put it in my waiting queue.
> Reason: we should first do the sysfs stuff for the wwatchdog_core (since
> active and nowayout are parameters that will be in the sysfs watchdog core).
>
> Kind regards,
> Wim.
>


Ok. If you want to offload it, I think I could spend some time on it the next
weeks, as I'll probably have to write a driver for a Ti TPS3813K33 watchdog
anyway, I can have a look into watchdog core as well.

Byte,
Johannes
