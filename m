Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933419Ab3E1IJI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 04:09:08 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.146]:45304 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933327Ab3E1IJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 04:09:04 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-8.tower-180.messagelabs.com!1369728539!24813040!2
X-Originating-IP: [83.171.138.125]
X-StarScan-Received: 
X-StarScan-Version: 6.9.6; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Tue, 28 May 2013 10:09:00 +0200
Date: Tue, 28 May 2013 10:10:53 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: Wim Van Sebroeck <wim@iguana.be>
CC: <linux-watchdog@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 1/2] watchdog: New watchdog driver for MEN A21
 watchdogs
Message-ID: <20130528081053.GC818@jtlinux>
References: <20130527090756.GA14258@spo001.leaseweb.com>
 <1369678434-13515-1-git-send-email-johannes.thumshirn@men.de>
 <20130527182554.GB14258@spo001.leaseweb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130527182554.GB14258@spo001.leaseweb.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 28 May 2013 08:08:59.0642 (UTC) FILETIME=[9BAF55A0:01CE5B7A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 27, 2013 at 08:25:54PM +0200, Wim Van Sebroeck wrote:
[...]
> > +	watchdog_set_drvdata(&a21_wdt, drv);
>
> I am missing the initialisation of the watchdog's timeout value here...

This watchdog only knows two timeout values, 1s and 30s with the constraint
that you can't go back to 30s once your in a 1s timeout without a reset of the
CPLD. I could initially set it to 30s but that would be redundant.

> For the rest this looks OK.
>
> Kind regards,
> wim.
>

This sounds pretty good.
