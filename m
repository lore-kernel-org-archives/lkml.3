Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322Ab3HIEo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 00:44:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56972 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154Ab3HIEo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 00:44:57 -0400
Date: Thu, 8 Aug 2013 21:46:20 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [ 008/102] ARM: make vectors page inaccessible from userspace
Message-ID: <20130809044620.GA10681@kroah.com>
References: <20130809015010.208118575@linuxfoundation.org>
 <20130809015012.154316979@linuxfoundation.org>
 <201308090629.21809.s.L-H@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201308090629.21809.s.L-H@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 06:29:17AM +0200, Stefan Lippers-Hollmann wrote:
> On Friday 09 August 2013, Greg Kroah-Hartman wrote:
> > 3.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Russell King <rmk+kernel@arm.linux.org.uk>
> > 
> > commit a5463cd3435475386cbbe7b06e01292ac169d36f upstream.
> > 
> > If kuser helpers are not provided by the kernel, disable user access to
> > the vectors page.  With the kuser helpers gone, there is no reason for
> > this page to be visible to userspace.
> > 
> > Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 
> If I read Russell King's response in 
> 
> 	http://www.spinics.net/lists/stable/msg16792.html
> 	Message-ID: <20130804105241.GG23006@n2100.arm.linux.org.uk>
> 
> correctly, this patch might not be wanted for -stable; this only 
> affects queue-3.10 at the moment.

Yes, I know there's a build warning/error here, but it only affects no
mmu systems, right?  I'll pick up the fix that hits Linus's tree for
this when it gets there.

thanks,

greg k-h
