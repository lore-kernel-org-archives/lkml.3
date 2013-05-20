Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758139Ab3ETXHA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 19:07:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45074 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756026Ab3ETXG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 19:06:59 -0400
Date: Mon, 20 May 2013 16:06:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] tty: Add lock/unlock ldisc pair functions
Message-ID: <20130520230657.GA21500@kroah.com>
References: <20130415201411.GA27360@kroah.com>
 <1366107356-7699-1-git-send-email-peter@hurleysoftware.com>
 <1366107356-7699-2-git-send-email-peter@hurleysoftware.com>
 <20130520193403.GA14340@kroah.com>
 <519A9920.3010702@hurleysoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <519A9920.3010702@hurleysoftware.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 05:44:00PM -0400, Peter Hurley wrote:
> On 05/20/2013 03:34 PM, Greg Kroah-Hartman wrote:
> >On Tue, Apr 16, 2013 at 06:15:51AM -0400, Peter Hurley wrote:
> >>Just as the tty pair must be locked in a stable sequence
> >>(ie, independent of which is consider the 'other' tty), so must
> >>the ldisc pair be locked in a stable sequence as well.
> >>
> >>Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
> >>---
> >>  drivers/tty/tty_ldisc.c | 87 +++++++++++++++++++++++++++++++++++++++++++++++++
> >>  1 file changed, 87 insertions(+)
> >
> >This patch breaks the build :(
> 
> Sorry about that.
> 
> >I've taken the first one, care to mush this one with the 7/7 patch, so
> >there are no build breaks, and resend the 5 resulting patches so I can
> >apply these?
> 
> Maybe it would be better to reorder 7/7 to be 1/6, if that's ok?
> More work for me but the history will be cleaner.

Sure, that works for me as well, care to just resend them?  Or, I can
dig them out of my archive if needed.

thanks,

greg k-h
