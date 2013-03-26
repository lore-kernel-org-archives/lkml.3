Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab3CZV3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 17:29:36 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:54328 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751657Ab3CZV3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 17:29:34 -0400
X-Sasl-enc: Mo7UOTEQ5ySlEPhUK+cPOkcOKhh2nFUSyKUw7Juwi+dp 1364333373
Date: Tue, 26 Mar 2013 14:29:32 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Johan Hovold <jhovold@gmail.com>
Subject: Re: linux-next: manual merge of the usb tree with the tty tree
Message-ID: <20130326212932.GA27132@kroah.com>
References: <20130326144932.aae6ea8285bba0a98b0b6193@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130326144932.aae6ea8285bba0a98b0b6193@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 02:49:32PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/serial/usb-serial.c between commit 6aad04f21374 ("TTY: add
> tty_port_tty_wakeup helper") from the tty tree and commit d12e211d4484
> ("USB: serial: clean up debug info") from the usb tree.
> 
> I fixed it up (I just used the version of usb_serial_port_work() from the
> tty tree - see below) and can carry the fix as necessary (no action is
> required).

Looks correct, thanks.

greg k-h
