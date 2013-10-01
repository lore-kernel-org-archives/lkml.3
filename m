Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3JABim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 21:38:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754816Ab3JABil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 21:38:41 -0400
Date: Mon, 30 Sep 2013 18:38:44 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jesper Juhl <jj@chaosbits.net>
Cc: Forest Bond <forest@alittletooquiet.net>, Joe Perches <joe@perches.com>,
        Hema Prathaban <hemaklnce@gmail.com>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        "David S. Miller" <davem@davemloft.net>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: don't leak when returning -EOPNOTSUPP
 in vt6655_hostap_ioctl
Message-ID: <20131001013844.GA28118@kroah.com>
References: <alpine.LNX.2.00.1309302220160.4992@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1309302220160.4992@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 10:22:11PM +0200, Jesper Juhl wrote:
> Make sure we always free(param); and remove a redundant "goto out;"
> just before we'll hit the label anyway.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/staging/vt6655/hostap.c |   25 ++++++++++---------------
>  1 files changed, 10 insertions(+), 15 deletions(-)

Applied, thanks.

greg k-h
