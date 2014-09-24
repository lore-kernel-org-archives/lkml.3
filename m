Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264AbaIXN31 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:29:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56560 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751088AbaIXN30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:29:26 -0400
Date: Wed, 24 Sep 2014 15:29:22 +0200
From: Michael Grzeschik <mgr@pengutronix.de>
To: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 0/5] ARCNET: add support for EAE multi interfac card
Message-ID: <20140924132922.GD9715@pengutronix.de>
References: <1411556523-28100-1-git-send-email-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411556523-28100-1-git-send-email-m.grzeschik@pengutronix.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:26:19 up 14 days,  6:13, 78 users,  load average: 0,13, 0,09,
 0,12
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Sep 24, 2014 at 01:01:58PM +0200, Michael Grzeschik wrote:
> This series adds support for the PLX bridge based multi interface
> pci cards and adds support to change device address on com200xx chips
> during runtime.
> 
> Thanks,
> Michael
> 
> Michael Grzeschik (5):
>   ARCNET: return IRQ_NONE if the interface isn't running
>   ARCNET: add com20020_set_hwddr to change address
>   ARCNET: add com20020 PCI IDs with metadata
>   ARCNET: add support for multi interfaces on com20020
>   ARCNET: enable eae arcnet card support
> 
>  drivers/net/arcnet/arcnet.c       |   2 +-
>  drivers/net/arcnet/com20020-pci.c | 369 +++++++++++++++++++++++++++++---------
>  drivers/net/arcnet/com20020.c     |  14 ++
>  include/linux/com20020.h          |  29 +++
>  4 files changed, 330 insertions(+), 84 deletions(-)
> 
> -- 
> 2.1.0

This series was based on v3.16 and does not apply on master. Who could
expect somebody else be patching the arcnet dir in this century. :)

Will send a newer series in some minutes.

Michael Grzeschik


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
