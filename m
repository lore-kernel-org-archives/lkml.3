Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753428Ab3FQUBk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 16:01:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40517 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751836Ab3FQUBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 16:01:38 -0400
Date: Mon, 17 Jun 2013 13:01:38 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH v4 00/24] lockless n_tty receive path
Message-ID: <20130617200138.GA8199@kroah.com>
References: <1366039168-8510-1-git-send-email-peter@hurleysoftware.com>
 <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371302076-4688-1-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 15, 2013 at 09:14:12AM -0400, Peter Hurley wrote:
> Greg,
> 
> As before, this patchset is dependent on the 'ldsem patchset'.
> The reason is that this series abandons tty->receive_room as
> a flow control mechanism (because that requires locking),
> and the TIOCSETD ioctl _without ldsem_ uses tty->receive_room
> to shutoff i/o.
> 
> It is also dependent on 'n_tty fixes' which I recently resent
> to you.

Thanks for rebasing all of this, and resending it.  It's late in the
3.11 development cycle, so I'm going to wait unto 3.11-rc1 is out to
queue it up for 3.12, to get it lots of testing in linux-next.  So don't
worry, they aren't lost, just waiting a few more weeks before I can
apply them.

thanks,

greg k-h
