Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026AbaCIFxO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 00:53:14 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54315 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751804AbaCIFxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 00:53:13 -0500
Date: Sat, 8 Mar 2014 21:53:49 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: linux-kernel@vger.kernel.org, Johannes Thumshirn <morbidrsa@gmail.com>
Subject: Re: [PATCH 2/2] iio: adc: Fix build error discovered by 0-day build
 bot
Message-ID: <20140309055349.GB15581@kroah.com>
References: <1393879609-3284-1-git-send-email-johannes.thumshirn@men.de>
 <1393879609-3284-2-git-send-email-johannes.thumshirn@men.de>
 <20140309055232.GA15581@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140309055232.GA15581@kroah.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 09:52:32PM -0800, Greg Kroah-Hartman wrote:
> On Mon, Mar 03, 2014 at 09:46:49PM +0100, Johannes Thumshirn wrote:
> > From: Johannes Thumshirn <morbidrsa@gmail.com>
> > 
> > men_z188_adc needs to include linux/io.h. This fixes a build error
> > discovered by 0-day buid bot
> > 
> > Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> > ---
> >  drivers/iio/adc/men_z188_adc.c | 1 +
> >  1 file changed, 1 insertion(+)
> 
> Please properly credit who reported the issue with a "Reported-by:"
> line.
> 
> Also send patches to the correct maintainers using
> scripts/get_maintainers.pl, I am not the IIO maintainer.

Ah, I see I took your previous patch, that makes a bit more sense why
you sent it to me, so I'll queue it up to fix the reported issue...

