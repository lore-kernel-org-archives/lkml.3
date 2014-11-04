Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbaKDAG6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 19:06:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35088 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaKDAG5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 19:06:57 -0500
Date: Mon, 3 Nov 2014 16:06:56 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Marek Belisko <marek.belisko@gmail.com>,
        devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/2] staging: ft1000: Whitespace neatening
Message-ID: <20141104000656.GA17825@kroah.com>
References: <cover.1414885739.git.joe@perches.com>
 <d33bf76b04e702685579a9607b509ea1e5c7282e.1414885739.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d33bf76b04e702685579a9607b509ea1e5c7282e.1414885739.git.joe@perches.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2014 at 04:53:38PM -0700, Joe Perches wrote:
> Use normal kernel style, indentation and alignment.
> 
> git diff -w shows no difference
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/staging/ft1000/ft1000-pcmcia/boot.h        |   34 +-
>  drivers/staging/ft1000/ft1000-pcmcia/ft1000.h      |   30 +-
>  drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c   |   50 +-
>  drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |  204 ++--
>  drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |  688 +++++------
>  drivers/staging/ft1000/ft1000-usb/ft1000_debug.c   | 1190 ++++++++++----------
>  .../staging/ft1000/ft1000-usb/ft1000_download.c    |  300 ++---
>  drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |  244 ++--
>  drivers/staging/ft1000/ft1000-usb/ft1000_ioctl.h   |   60 +-
>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |   14 +-
>  drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |    2 +-
>  11 files changed, 1408 insertions(+), 1408 deletions(-)

Fails to apply here:

checking file drivers/staging/ft1000/ft1000-pcmcia/boot.h
checking file drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
checking file drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
checking file drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
checking file drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
Hunk #41 FAILED at 992.
Hunk #49 FAILED at 1220.
Hunk #64 FAILED at 1743.
3 out of 78 hunks FAILED

Care to refresh it and resend both of these?

thanks,

greg k-h
