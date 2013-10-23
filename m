Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684Ab3JWHDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 03:03:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3JWHDF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 03:03:05 -0400
Date: Wed, 23 Oct 2013 08:04:32 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Thierry Reding <thierry.reding@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        linux-serial@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>
Subject: Re: linux-next: Tree for Oct 22 (xilinx_uartps)
Message-ID: <20131023070432.GB31203@kroah.com>
References: <1382454517-4074-1-git-send-email-treding@nvidia.com>
 <5266F658.5030904@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5266F658.5030904@infradead.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 03:04:08PM -0700, Randy Dunlap wrote:
> On 10/22/13 08:08, Thierry Reding wrote:
> > Hi all,
> > 
> > I've uploaded today's linux-next tree to the master branch of the
> > repository below:
> > 
> >         git://gitorious.org/thierryreding/linux-next.git
> > 
> > A next-20131022 tag is also provided for convenience.
> > 
> > Gained a couple new conflicts, fixed more build failures. ARM seems to
> > be in pretty good shape, as is the 64-bit x86 allmodconfig.
> 
> 
> on i386:
> 
>   CC [M]  drivers/tty/serial/xilinx_uartps.o
> drivers/tty/serial/xilinx_uartps.c: In function 'xuartps_suspend':
> drivers/tty/serial/xilinx_uartps.c:1227:21: error: 'xuartps_uart_driver' undeclared (first use in this function)
> drivers/tty/serial/xilinx_uartps.c:1227:21: note: each undeclared identifier is reported only once for each function it appears in
> drivers/tty/serial/xilinx_uartps.c: In function 'xuartps_resume':
> drivers/tty/serial/xilinx_uartps.c:1308:27: error: 'xuartps_uart_driver' undeclared (first use in this function)
> drivers/tty/serial/xilinx_uartps.c:1309:1: warning: control reaches end of non-void function [-Wreturn-type]

There are some patches sent that should resolve this issue now, I'll try
to apply them later today.

thanks,

greg k-h
