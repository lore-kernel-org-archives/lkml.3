Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760469Ab3DCPZZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 11:25:25 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:43369 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757901Ab3DCPZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:25:23 -0400
Date: Wed, 3 Apr 2013 17:16:54 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-i2c@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] watchdog: Add Congatec CGEB watchdog driver
Message-ID: <20130403151654.GY1906@pengutronix.de>
References: <1360663374-30951-1-git-send-email-s.hauer@pengutronix.de>
 <1360663374-30951-4-git-send-email-s.hauer@pengutronix.de>
 <CAH9NwWd7YdtK0urutisVgKoE7NmPFLpG3wFG5W6P7o45vUqAng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH9NwWd7YdtK0urutisVgKoE7NmPFLpG3wFG5W6P7o45vUqAng@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 17:15:33 up 284 days,  6:27, 113 users,  load average: 2.52, 4.00,
 5.56
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 11:16:35AM +0100, Christian Gmeiner wrote:
> 2013/2/12 Sascha Hauer <s.hauer@pengutronix.de>:
> > --
> 
> There seems to be a problem:
> 
> Mar 26 16:11:25 OT kernel: [   80.207514] cgeb-watchdog
> cgeb-watchdog.0: registered
> Mar 26 16:11:38 OT watchdog[2519]: stopping daemon (5.9)
> Mar 26 16:11:43 OT watchdog[2750]: starting daemon (5.9):
> Mar 26 16:11:43 OT watchdog[2750]: int=1s realtime=yes sync=no soft=no
> mla=0 mem=0
> Mar 26 16:11:43 OT watchdog[2750]: ping: no machine to check
> Mar 26 16:11:43 OT watchdog[2750]: file: no file to check
> Mar 26 16:11:43 OT watchdog[2750]: pidfile: no server process to check
> Mar 26 16:11:43 OT watchdog[2750]: interface: no interface to check
> Mar 26 16:11:43 OT watchdog[2750]: test=none(0) repair=none(0)
> alive=/dev/watchdog heartbeat=none temp=none to=root no_act=no
> Mar 26 16:11:43 OT watchdog[2750]: cannot set timeout 60 (errno = 95 =
> 'Operation not supported')

As mentioned in my other mail the watchdog core no longer sets
wdd->timeout which results in the above message. Should be fixed
with the next version.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
