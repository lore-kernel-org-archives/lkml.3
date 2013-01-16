Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757579Ab3APGqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 01:46:36 -0500
Received: from mail.kernel.org ([198.145.19.201]:36224 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593Ab3APGqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 01:46:35 -0500
Date: Tue, 15 Jan 2013 22:47:35 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/10] TTY: switch flipping functions to tty_port
Message-ID: <20130116064735.GA7743@kroah.com>
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 03, 2013 at 03:53:00PM +0100, Jiri Slaby wrote:
> In this series we get rid of the tty_port_tty_get in most hot paths as
> all the flipping functions needs to know is in tty_port already. This
> simplifies the code at some places a lot.
> 
> Two fixes for coverity issues are included.

All applied, but the drivers/staging/sb105x/ driver is now broken, can
you send me a follow-on patch to fix it?

thanks,

greg k-h
