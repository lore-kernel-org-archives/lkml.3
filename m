Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab3HDTgw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Aug 2013 15:36:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41537 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753771Ab3HDTgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Aug 2013 15:36:50 -0400
Date: Sun, 4 Aug 2013 21:36:47 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Olof Johansson <olof@lixom.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jonathan Austin <jonathan.austin@arm.com>
Subject: Re: Build breakage due to latest ARM fixes
Message-ID: <20130804193647.GD6104@pengutronix.de>
References: <CAOesGMgWeP-CdmOE-S7XZmJ-+1buP9a1cqavUns2gpgKrrhaxQ@mail.gmail.com>
 <20130803000731.GS23006@n2100.arm.linux.org.uk>
 <20130804125346.GH23006@n2100.arm.linux.org.uk>
 <CAOesGMhNr5-6T9s8Y9jr2pWy=baceuZwGFNj2HtnqU9DbwPLvw@mail.gmail.com>
 <20130804183708.GI23006@n2100.arm.linux.org.uk>
 <CAOesGMiDBT9NAhCiVe0mMTk4KXJZVynNaBHqk5+T9a6QYaFZvw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOesGMiDBT9NAhCiVe0mMTk4KXJZVynNaBHqk5+T9a6QYaFZvw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sun, Aug 04, 2013 at 11:47:04AM -0700, Olof Johansson wrote:
> On Sun, Aug 4, 2013 at 11:37 AM, Russell King - ARM Linux
> > The only real testing I'm aware of is when I recreated the OKI67001
> > support a while back and got my board to boot.
> 
> Uwe has been busy pushing various patches for M3/M4 support, I don't
> know how far it is from having some real hardware usable though. Uwe?
On my efm32 devboard I have 3.11-rc running. The missing bits are
available in my efm32 branch at

	git://git.pengutronix.de/git/ukl/linux.git efm32
	http://git.pengutronix.de/?p=ukl/linux.git;a=shortlog;h=refs/heads/efm32

. It's not yet in a form ready for mainline but there isn't much
missing. There is one problem I didn't debug yet (/proc/devicetree
doesn't appear although I have the respective Kconfig symbol on); other
than that I didn't notice any no-mmu problems. Also Jonathan Austin does
some no-MMU work.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
