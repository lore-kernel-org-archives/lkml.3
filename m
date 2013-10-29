Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758418Ab3J2QW4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:22:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35944 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758381Ab3J2QWx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:22:53 -0400
Date: Tue, 29 Oct 2013 09:22:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Michal Simek <michal.simek@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: Re: [PATCH 1/3] tty: xuartps: Fix "may be used uninitialized" build
 warning
Message-ID: <20131029162252.GA21986@kroah.com>
References: <1382398861-21542-1-git-send-email-soren.brinkmann@xilinx.com>
 <1382398861-21542-2-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1382398861-21542-2-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 21, 2013 at 04:40:59PM -0700, Soren Brinkmann wrote:
> Initialize varibles for which a 'may be used uninitalized' warning is
> issued.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> The warning is actually a false positive. The variables are passed to a
> function per reference. That function uses those variables to return
> values, which then are used by the caller. Is there a way to
> avoid the initialization and the build warning alltogether?
> ---
>  drivers/tty/serial/xilinx_uartps.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Please properly credit the kbuild robot who found these issues the next
time...

thanks,

greg k-h
