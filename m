Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab3FZOiS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:38:18 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab3FZOiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:38:14 -0400
Date: Wed, 26 Jun 2013 07:38:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH 0/2] some uio patches
Message-ID: <20130626143857.GA13583@kroah.com>
References: <1366970549-16292-1-git-send-email-u.kleine-koenig@pengutronix.de>
 <20130626100038.GV11232@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130626100038.GV11232@pengutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 12:00:38PM +0200, Uwe Kleine-König wrote:
> Hello,
> 
> On Fri, Apr 26, 2013 at 12:02:27PM +0200, Uwe Kleine-König wrote:
> > these two patches are not really related, I only sent them in a series because
> > they touch the same file and fail to apply in reversed order.
> > 
> > Patch 1 is useful for debugging with gdb, patch 2 is a cleanup. Note that patch
> > 2 is only compile-tested because I don't have an uio driver that uses a
> > non-physical map.
> ping

ping on what?  I don't have your patches in my to-review queue anymore,
you need to resend them please, like I recently asked for all UIO
patches to be resent.

But my trees are now closed for 3.11, so please wait until after
3.11-rc1 is out before sending them as I can't do anything with them
until then.

greg k-h
