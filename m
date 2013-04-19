Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967823Ab3DSCCw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 22:02:52 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:48249 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967742Ab3DSCCt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 22:02:49 -0400
Date: Thu, 18 Apr 2013 19:02:40 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Joe Perches <joe@perches.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        linux-usb <linux-usb@vger.kernel.org>,
        usb-storage <usb-storage@lists.one-eyed-alien.net>
Subject: Re: [PATCH usb-next] usb: storage: Fix link error
Message-ID: <20130419020240.GA6931@kroah.com>
References: <20130418160541.57123749577f29665fba7839@canb.auug.org.au>
 <1366319834.2119.27.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366319834.2119.27.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 02:17:14PM -0700, Joe Perches wrote:
> Fix allmodconfig link error introduced by commit 75b9130e8a
> ("usb: storage: Add usb_stor_dbg, reduce object size")
> 
> Export the symbol usb_stor_dbg.
> Add export.h
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/usb/storage/debug.c | 2 ++
>  1 file changed, 2 insertions(+)

You forgot the "Reported-by:" line :(

I'll go add it now, thanks for the quick fix-up patch.

greg k-h
