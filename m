Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934355Ab3CZJbo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:31:44 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38625 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759515Ab3CZJbm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:31:42 -0400
Date: Tue, 26 Mar 2013 10:31:39 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Christian Gmeiner <christian.gmeiner@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        linux-i2c@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/3] x86: Add basic support for the Congatec CGEB BIOS
 interface
Message-ID: <20130326093139.GL1906@pengutronix.de>
References: <1360663374-30951-1-git-send-email-s.hauer@pengutronix.de>
 <1360663374-30951-2-git-send-email-s.hauer@pengutronix.de>
 <CAH9NwWdOCo642KqUXk1y5hbwdtW5RYgQnQfZFUEe4FOJzSiByQ@mail.gmail.com>
 <20130326085454.GK1906@pengutronix.de>
 <20130326092435.GB8553@the-dreams.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326092435.GB8553@the-dreams.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:29:12 up 276 days, 40 min, 78 users,  load average: 10.83,
 10.73, 13.62
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Wolfram,

On Tue, Mar 26, 2013 at 10:24:35AM +0100, Wolfram Sang wrote:
> Hi Sascha,
> 
> > Any other comments to this series? Is the base cgeb support ok to
> > include?
> 
> I had a few comments to the I2C driver.

Yes, thanks, I have seen this and will address them. Atm I'm more
interested in the base support though, since without it there won't be a
need for the i2c driver ;)

Regards
 Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
