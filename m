Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758406Ab3J2Q0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:26:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36240 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3J2Q0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:26:08 -0400
Date: Tue, 29 Oct 2013 09:26:06 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 0/3] tty: xuartps: Fix build
Message-ID: <20131029162606.GA22291@kroah.com>
References: <1382398861-21542-1-git-send-email-soren.brinkmann@xilinx.com>
 <20131029162457.GA22189@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029162457.GA22189@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 09:24:57AM -0700, Greg Kroah-Hartman wrote:
> On Mon, Oct 21, 2013 at 04:40:58PM -0700, Soren Brinkmann wrote:
> > This should fix the issues in the x86 build of the xuartps driver. The
> > issues are:
> >  - [tty:tty-next 72/75] drivers/tty/serial/xilinx_uartps.c:436:7: error:
> >    'PRE_RATE_CHANGE' undeclared
> >  - [tty:tty-next 73/75] drivers/tty/serial/xilinx_uartps.c:1227:21:
> >    error: 'xuartps_uart_driver' undeclared
> > 
> > Additionally I found some build warnings while fixing those issues.
> > 
> > There are some additional comments regarding patches 1 and 3 in their
> > respective email.
> > This series is based on the tty-next tree.
> 
> No it isn't, it doesn't apply there at all.  Please respin these against
> the latest tty-next branch and resend them so that I can apply them.

Doh, nevermind, I was using the wrong branch of that tree, sorry, my
fault.

/me needs more coffee...

greg k-h
