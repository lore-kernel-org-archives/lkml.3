Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757301Ab3B0Vzw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 16:55:52 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60895 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753612Ab3B0Vzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 16:55:51 -0500
Date: Wed, 27 Feb 2013 13:55:48 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Jiri Slaby <jslaby@suse.cz>
Cc: Daniel Mack <zonque@gmail.com>, Larry Finger <Larry.Finger@lwfinger.net>,
        jirislaby@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] TTY: disable debugging warning
Message-ID: <20130227215548.GA28005@kroah.com>
References: <1362000624-18155-1-git-send-email-jslaby@suse.cz>
 <20130227214225.GB27224@kroah.com>
 <512E7F1D.2070401@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512E7F1D.2070401@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 27, 2013 at 10:48:13PM +0100, Jiri Slaby wrote:
> On 02/27/2013 10:42 PM, Greg KH wrote:
> > On Wed, Feb 27, 2013 at 10:30:24PM +0100, Jiri Slaby wrote:
> >> We added a warning to flush_to_ldisc to report cases when it is called
> >> with a NULL tty. It was for debugging purposes and it lead to a
> >> patchset from Peter Hurley. The patchset however did not make it to
> >> 3.9, so disable the warning now to not disturb people.
> >>
> >> We can re-add it when the series is in and we are hunting for another
> >> bugs.
> >>
> >> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> >> ---
> >>  drivers/tty/tty_buffer.c | 2 +-
> >>  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Thanks, I'll queue this up for 3.9-final, but does it also need to go
> > into 3.8?
> 
> That's a question... In 3.8 it happened too, but very seldomly. Read:
> only triggerable by trinity fuzz tester after hours of fuzzing. But
> yeah, let's disable it there too so that people won't complain.

Ok, I'll queue it up for the stable release then, thanks.

greg k-h
