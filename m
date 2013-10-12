Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab3JLAJc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 20:09:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49576 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753304Ab3JLAJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 20:09:31 -0400
Date: Fri, 11 Oct 2013 17:09:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthias Beyer <mail@beyermatthias.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6] drivers: usb: core: Adapt source to styleguide
Message-ID: <20131012000930.GA8806@kroah.com>
References: <1381441292-6145-1-git-send-email-mail@beyermatthias.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381441292-6145-1-git-send-email-mail@beyermatthias.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 11:41:26PM +0200, Matthias Beyer wrote:
> Hi,
> 
> I patches several files in drivers/usb/core/ to adapt them to the kernel
> styleguide.
> 
> Most of these patches are whitespace/indention fixes.
> 
> As these patches are only style-patches, I just compiled the kernel, no compile
> errors or warnings. So I think everything seems to be okay!
> 
> Note: I did not fix all ERROR messages from the scripts/checkpatch.pl script, as
> I don't know what to do with "do not use assignments in if-condition" messages.

You can fix those up if you want.  An example would be:
	bad code:
		if ((x = foo() == NULL)
			do_something();
	good code:
		x = foo();
		if (x == NULL)
			do_something();

Hope this helps,

greg k-h
