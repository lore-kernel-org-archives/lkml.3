Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaFARrf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2014 13:47:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56552 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaFARre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2014 13:47:34 -0400
Date: Sun, 1 Jun 2014 10:47:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org, Emil Goode <emilgoode@gmail.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH] driver core/platform: remove unused implicit padding in
 platform_object
Message-ID: <20140601174731.GC1281@kroah.com>
References: <1401480167-15091-1-git-send-email-ydroneaud@opteya.com>
 <20140530201054.GF17724@mwanda>
 <1401523299.15490.6.camel@localhost.localdomain>
 <20140531120526.GL15585@mwanda>
 <1401609616.17059.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401609616.17059.2.camel@localhost.localdomain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 01, 2014 at 10:00:16AM +0200, Yann Droneaud wrote:
> Hi Dan,
> 
> Le samedi 31 mai 2014 à 15:05 +0300, Dan Carpenter a écrit :
> > On Sat, May 31, 2014 at 10:01:39AM +0200, Yann Droneaud wrote:
> > > Le vendredi 30 mai 2014 à 23:10 +0300, Dan Carpenter a écrit :
> > > > This changelog doesn't match the patch.
> > > > 
> > > 
> > > Hum, let me guess .... I've failed to set the proper subject prefix
> > > to add v6 suffic to PATCH: 
> > > I've changed the patch title since v5 (from Emil Goode)... so it's like
> > > a new one.
> > > 
> > > Is it really necessary to resend the patch ?
> > 
> > Oh.  Sorry, I didn't understand what you were trying to say...  You're
> > right.
> > 
> 
> Sorry about that.
> 
> If it's unclear, I should modify the commit message.

Nah, it looks good, I'll queue it up this week, thanks.

greg k-h
