Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935317Ab3DHJlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:41:24 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49237 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934736Ab3DHJlW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:41:22 -0400
Date: Mon, 8 Apr 2013 11:41:20 +0200
From: Robert Schwebel <r.schwebel@pengutronix.de>
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: Wolfram Sang <wsa@the-dreams.de>, linux-i2c@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Christian Gmeiner <c.gmeiner@bachmann.info>
Subject: Re: [PATCH] at24: extend driver to allow writing via
 i2c_smbus_write_byte_data
Message-ID: <20130408094120.GI1366@pengutronix.de>
References: <1355933229-25865-1-git-send-email-christian.gmeiner@gmail.com>
 <20130124140746.GI12933@pengutronix.de>
 <CAH9NwWeKFaZEWwK9Dio39pkVqcRUfVi=dxvoXT71csJLA13qzQ@mail.gmail.com>
 <CAH9NwWcpXAD7Hm=+ateYXz2bHVbFmJGOH7sRsEh02eeYNyD36w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH9NwWcpXAD7Hm=+ateYXz2bHVbFmJGOH7sRsEh02eeYNyD36w@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:39:52 up 289 days, 51 min, 118 users,  load average: 0,34, 1,32,
 2,21
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christian,

On Mon, Apr 08, 2013 at 08:56:03AM +0200, Christian Gmeiner wrote:
> Using the new mail address of wolfram sang - got the following error:
> 
> 
> Delivery to the following recipient failed permanently:
> 
>      w.sang@pengutronix.de
> 
> Technical details of permanent failure:
> Google tried to deliver your message, but it was rejected by the
> server for the recipient domainpengutronix.de by mail.pengutronix.de.
> [2001:6f8:1178:4:290:27ff:fe1d:cc33].
> 
> The error that the other server returned was:
> 550 Account closed - please contact info@pengutronix.de instead

Using wsa@the-dreams.de is correct. Mainline is already up to date.

rsc <- info@pengutronix.de
-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
