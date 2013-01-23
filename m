Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab3AWJ4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:56:38 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:52249 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754420Ab3AWJ4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:56:37 -0500
Date: Wed, 23 Jan 2013 10:56:27 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Laurent Navet <laurent.navet@gmail.com>
Cc: ben-linux@fluff.org, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: i2c: muxes: fix sizeof(ptr)
Message-ID: <20130123095627.GD3767@nekote.pengutronix.de>
References: <1357652409-22907-1-git-send-email-laurent.navet@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357652409-22907-1-git-send-email-laurent.navet@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 02:40:09PM +0100, Laurent Navet wrote:
> sizeof when applied to a pointer typed expression gives the size of
> the pointer
> 
> The semantic patch that makes this output is available
> in scripts/coccinelle/misc/noderef.cocci.
> 
> More information about semantic patching is available at
> http://coccinelle.lip6.fr/
> 
> Signed-off-by: Laurent Navet <laurent.navet@gmail.com>

Thanks, applied to for-current.
