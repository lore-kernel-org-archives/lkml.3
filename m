Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554Ab3J2QZR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:25:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36009 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226Ab3J2QY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:24:58 -0400
Date: Tue, 29 Oct 2013 09:24:57 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 0/3] tty: xuartps: Fix build
Message-ID: <20131029162457.GA22189@kroah.com>
References: <1382398861-21542-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382398861-21542-1-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 04:40:58PM -0700, Soren Brinkmann wrote:
> This should fix the issues in the x86 build of the xuartps driver. The
> issues are:
>  - [tty:tty-next 72/75] drivers/tty/serial/xilinx_uartps.c:436:7: error:
>    'PRE_RATE_CHANGE' undeclared
>  - [tty:tty-next 73/75] drivers/tty/serial/xilinx_uartps.c:1227:21:
>    error: 'xuartps_uart_driver' undeclared
> 
> Additionally I found some build warnings while fixing those issues.
> 
> There are some additional comments regarding patches 1 and 3 in their
> respective email.
> This series is based on the tty-next tree.

No it isn't, it doesn't apply there at all.  Please respin these against
the latest tty-next branch and resend them so that I can apply them.

thanks,

greg k-h
