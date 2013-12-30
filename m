Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751191Ab3L3Fdp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 00:33:45 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3L3Fdo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 00:33:44 -0500
Date: Sun, 29 Dec 2013 21:34:30 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Wang YanQing <udknight@gmail.com>, jslaby@suse.cz, airlied@redhat.com,
        akpm@linux-foundation.org, kilobyte@angband.pl,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fonts:Kconfig: fix default enable FONT_8x8 and FONT_8x16
 at the same time
Message-ID: <20131230053430.GA11990@kroah.com>
References: <20131230033745.GA5855@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131230033745.GA5855@udknight>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 30, 2013 at 11:37:45AM +0800, Wang YanQing wrote:
> FONT_8x8 and FONT_8x16 have the same default value line:
> "default y if !SPARC && !FONTS"
> 
> I test run "make defconfig" for x86 will enable FONT_8x8 and FONT_8x16 at
> the same time.
> 
> This patch fix it, because FONT_AUTOSELECT choice FONT_8x16, so
> I decide to disable FONT_8x8, this patch will reduce size of kernel.
> 
> Signed-off-by: Wang YanQing <udknight@gmail.com>
> ---
>  lib/fonts/Kconfig | 1 -
>  1 file changed, 1 deletion(-)

I am not the maintainer of this file, sorry.  Also, I don't think it's
correct, if you want, you can always disable this option on your own.

greg k-h
