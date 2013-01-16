Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362Ab3APPiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:38:24 -0500
Received: from mail.kernel.org ([198.145.19.201]:50827 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752688Ab3APPiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:38:23 -0500
Date: Wed, 16 Jan 2013 07:39:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: alan@linux.intel.com, jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 00/10] TTY: switch flipping functions to tty_port
Message-ID: <20130116153911.GB1329@kroah.com>
References: <1357224789-2853-1-git-send-email-jslaby@suse.cz>
 <20130116064735.GA7743@kroah.com>
 <50F6AD15.708@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50F6AD15.708@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 02:37:25PM +0100, Jiri Slaby wrote:
> On 01/16/2013 07:47 AM, Greg KH wrote:
> > On Thu, Jan 03, 2013 at 03:53:00PM +0100, Jiri Slaby wrote:
> >> In this series we get rid of the tty_port_tty_get in most hot paths as
> >> all the flipping functions needs to know is in tty_port already. This
> >> simplifies the code at some places a lot.
> >>
> >> Two fixes for coverity issues are included.
> > 
> > All applied, but the drivers/staging/sb105x/ driver is now broken, can
> > you send me a follow-on patch to fix it?
> 
> I intentionally ignored that one as at the time of sending the patches,
> it was marked as BROKEN in -next. It is still broken, since it does not
> even have a tty_port for each port which is a requirement for a while
> already. That is also a prerequisite to fix the build failure.

It used to be marked BROKEN, I'll go do that now again to solve this
issue.

greg k-h
