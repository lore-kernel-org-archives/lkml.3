Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757890Ab3ETTeH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:34:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46141 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756396Ab3ETTeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:34:04 -0400
Date: Mon, 20 May 2013 12:34:03 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] tty: Add lock/unlock ldisc pair functions
Message-ID: <20130520193403.GA14340@kroah.com>
References: <20130415201411.GA27360@kroah.com>
 <1366107356-7699-1-git-send-email-peter@hurleysoftware.com>
 <1366107356-7699-2-git-send-email-peter@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366107356-7699-2-git-send-email-peter@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 16, 2013 at 06:15:51AM -0400, Peter Hurley wrote:
> Just as the tty pair must be locked in a stable sequence
> (ie, independent of which is consider the 'other' tty), so must
> the ldisc pair be locked in a stable sequence as well.
> 
> Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> ---
>  drivers/tty/tty_ldisc.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 87 insertions(+)

This patch breaks the build :(

I've taken the first one, care to mush this one with the 7/7 patch, so
there are no build breaks, and resend the 5 resulting patches so I can
apply these?

thanks,

greg k-h
