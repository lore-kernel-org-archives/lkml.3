Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbaHFSd4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 14:33:56 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54723 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756357AbaHFSdz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 14:33:55 -0400
X-Sasl-enc: rJQ7ixnLbfGTLAKXmo88Z2aKej1/Jlrci8o/D9KbGC6h 1407350032
Date: Wed, 6 Aug 2014 11:33:19 -0700
From: Greg KH <greg@kroah.com>
To: Nick Krause <xerofoiffy@gmail.com>
Cc: Richard Weinberger <richard.weinberger@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        "open list:SPI SUBSYSTEM" <linux-spi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] spi: Remove unused definitions
Message-ID: <20140806183319.GA15654@kroah.com>
References: <1407347597-2168-1-git-send-email-xerofoiffy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407347597-2168-1-git-send-email-xerofoiffy@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 06, 2014 at 01:53:17PM -0400, Nick Krause wrote:
> Remove unused definition which cause the following warnings
> 
> drivers/spi/spi-omap-100k.c:73:0: warning: "WRITE" redefined [enabled by default]
> include/linux/fs.h:193:0: note: this is the location of the previous definition
> drivers/spi/spi-omap-100k.c:74:0: warning: "READ" redefined [enabled by default]
> include/linux/fs.h:192:0: note: this is the location of the previous definition
> 
> Signed-off-by: Nick Krause <xerofoiffy@gmail.com>
> ---
>  drivers/spi/spi-omap-100k.c | 4 ----
>  1 file changed, 4 deletions(-)

Nick, you were warned about this numerous times in the past.

By changing email addresses you have now ensured that we will never
listen to you, as you obviously are not listening to us.

greg k-h
