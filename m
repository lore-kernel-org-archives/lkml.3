Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3KIQII (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 11:08:08 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:42844 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab3KIQIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 11:08:04 -0500
Date: Sat, 9 Nov 2013 08:10:30 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 50/74] uio: provide vm access to UIO_MEM_PHYS maps
Message-ID: <20131109161030.GA22695@kroah.com>
References: <20131109065113.502217951@linuxfoundation.org>
 <20131109065117.016923315@linuxfoundation.org>
 <20131109142216.GB14892@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20131109142216.GB14892@pengutronix.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 09, 2013 at 03:22:16PM +0100, Uwe Kleine-König wrote:
> On Fri, Nov 08, 2013 at 10:51:55PM -0800, Greg Kroah-Hartman wrote:
> > 3.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
> > 
> > commit 7294151d0592e0ff48c61fca9fd7c93d613134da upstream.
> > 
> > This makes it possible to let gdb access mappings of the process that is
> > being debugged.
> > 
> > uio_mmap_logical was moved and uio_vm_ops renamed to group related code
> > and differentiate to new stuff.
> I wonder why you picked that one for stable?!

Because of a bugfix in a later patch that requires this one...

thanks,

greg k-h
