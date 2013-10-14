Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab3JNSMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 14:12:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756152Ab3JNSMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 14:12:15 -0400
Date: Mon, 14 Oct 2013 11:12:14 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matthias Beyer <mail@beyermatthias.de>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] drivers: usb: core: devio.c: Coding style fixes
Message-ID: <20131014181214.GB6023@kroah.com>
References: <1381441292-6145-5-git-send-email-mail@beyermatthias.de>
 <1381575694-9886-1-git-send-email-mail@beyermatthias.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381575694-9886-1-git-send-email-mail@beyermatthias.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 12, 2013 at 01:01:34PM +0200, Matthias Beyer wrote:
> Whitespace fixes, including:
> 
> - Whitespace after if-keyword
> - Spaces to Tabs
> 
> Other coding style fixes:
> 
> - Added braces for if-else blocks where missing

When doing coding style cleanups, please only do one thing per patch.
You are doing a bunch of different things here, all in one patch, which
isn't good so I can't take it, sorry.

Please split this up into different patches and I will be glad to accept
it.

thanks,

greg k-h
