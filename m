Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab3GHGyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 02:54:17 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.106]:10837 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753661Ab3GHGyQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 02:54:16 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-6.tower-193.messagelabs.com!1373266453!10945664!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.9; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 08 Jul 2013 08:54:13 +0200
Date: Mon, 8 Jul 2013 08:59:02 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Wim Van Sebroeck <wim@iguana.be>
CC: Johannes Thumshirn <johannes.thumshirn@men.de>,
        <linux-kernel@vger.kernel.org>, <linux-watchdog@vger.kernel.org>,
        <guenter@roeck-us.net>
Subject: Re: [PATCH RESEND v10 1/2] watchdog: New watchdog driver for MEN A21
 watchdogs
Message-ID: <20130708065902.GA22574@jtlinux>
References: <20130617140019.GA23794@roeck-us.net>
 <20130618151939.GA23296@jtlinux>
 <20130705210119.GA10354@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130705210119.GA10354@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 08 Jul 2013 06:54:13.0111 (UTC) FILETIME=[F470C870:01CE7BA7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 05, 2013 at 11:01:19PM +0200, Wim Van Sebroeck wrote:
> Hi Johannes,
>
> > This patch adds the driver for the watchdog devices found on MEN Mikro
> > Elektronik A21 VMEbus CPU Carrier Boards. It has DT-support and uses the
> > watchdog framework.
> >
> > Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> > Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>
> I added this patch to linux-watchdog-next.
> I am still thinking about wether or not we shouldn't add a timer to this
> watchdog device driver. But that's something we can change later on.

Probably yes, but that really would be some work for watchdog core imho.

Anyway, tanks for adding the patch.

Thanks,
Johannes

>
> Kind regards,
> Wim.
>
