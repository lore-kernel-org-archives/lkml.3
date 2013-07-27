Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab3G0Vtg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 17:49:36 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46514 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab3G0Vtf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 17:49:35 -0400
Date: Sat, 27 Jul 2013 23:49:11 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 1/2] uio: provide vm access to UIO_MEM_PHYS maps
Message-ID: <20130727214911.GK1754@pengutronix.de>
References: <1373995264-31448-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <1373995264-31448-2-git-send-email-u.kleine-koenig@pengutronix.de>
 <20130727005810.GA16817@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130727005810.GA16817@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 26, 2013 at 05:58:10PM -0700, Greg Kroah-Hartman wrote:
> On Tue, Jul 16, 2013 at 07:21:03PM +0200, Uwe Kleine-König wrote:
> > This makes it possible to let gdb access mappings of the process that is
> > being debugged.
> > 
> > uio_mmap_logical was moved and uio_vm_ops renamed to group related code
> > and differentiate to new stuff.
> > 
> > Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> 
> This patch breaks the build:
> 
> drivers/uio/uio.c: In function ‘uio_mmap_logical’:
> drivers/uio/uio.c:627:17: error: ‘uio_vm_ops’ undeclared (first use in this function)
Hmm, in my original patch this is OK, I don't have no idea how I could
bork that for submission. While looking into that problem I noticed that
there is yet another problem. I will send a fixed patch early next week.

Best regards and thanks for testing,
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
