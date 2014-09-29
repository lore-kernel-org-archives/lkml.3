Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060AbaI2JH1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 05:07:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34703 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439AbaI2JH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 05:07:26 -0400
Date: Mon, 29 Sep 2014 11:07:21 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: David Miller <davem@davemloft.net>
Cc: m.grzeschik@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 0/5] ARCNET: add support for EAE multi interfac card
Message-ID: <20140929090721.GE18174@pengutronix.de>
References: <1411566113-15583-1-git-send-email-m.grzeschik@pengutronix.de>
 <20140928.164421.1247481867383564525.davem@davemloft.net>
 <20140928.170150.1279138730834841306.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140928.170150.1279138730834841306.davem@davemloft.net>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 11:06:37 up 19 days,  1:54, 74 users,  load average: 0,14, 0,07,
 0,07
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 05:01:50PM -0400, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Sun, 28 Sep 2014 16:44:21 -0400 (EDT)
> 
> > From: Michael Grzeschik <m.grzeschik@pengutronix.de>
> > Date: Wed, 24 Sep 2014 15:41:48 +0200
> > 
> >> this series adds support for the PLX Bridge based multi interface
> >> pci cards and adds support to change device address on com200xx chips
> >> during runtime.
> >> 
> >> This series is based on v3.17-rc6.
> > 
> > Series applied to net-next, thanks.
> 
> I had to revert, this breaks the build:
> 
> drivers/net/arcnet/com20020_cs.c:115:8: error: redefinition of ‘struct com20020_dev’
>  struct com20020_dev {
>         ^
> In file included from drivers/net/arcnet/com20020_cs.c:43:0:
> include/linux/com20020.h:66:8: note: originally defined here
>  struct com20020_dev {
>         ^
> make[3]: *** [drivers/net/arcnet/com20020_cs.o] Error 1
> make[2]: *** [drivers/net/arcnet] Error 2
> make[2]: *** Waiting for unfinished jobs....
> make[1]: *** [drivers/net] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [drivers] Error 2

Oh, I didn't look into the other com20020 drivers.
I will fix it and send v2.

Thanks,
Michael

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
