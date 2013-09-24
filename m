Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab3IXAFx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 20:05:53 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:48518 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3IXAFv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 20:05:51 -0400
Date: Tue, 24 Sep 2013 02:05:50 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        freemangordon@abv.bg, aaro.koskinen@iki.fi
Subject: Re: [PATCH 4/4] RX-51: Add platform function and data for bq24150a
 charger
Message-ID: <20130924000550.GC30967@amd.pavel.ucw.cz>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <201309232116.19161@pali>
 <20130923200008.GA21808@earth.universe>
 <201309232206.47391@pali>
 <20130923204714.GB22995@earth.universe>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130923204714.GB22995@earth.universe>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > No, isp1704 is power supply driver and export data via power 
> > supply (sysfs) interface. It is not regulator but charger driver.
> 
> well it does not charge the battery directly, but just provides a
> power line with 5 Volt and a specified amount of current to the
> system, doesn't it?

I don't want to talk about isp1704, but...

LiION charger is just something that provides 4.2V power line with
C/10 current limitation...

(IOW line between regulators and chargers is very very thin, if it
even exists).

									Pavel

            (who did use laboratory power supply as emergency battery charger)
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
