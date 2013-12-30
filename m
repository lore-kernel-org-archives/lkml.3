Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497Ab3L3Gtr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 01:49:47 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:61515 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751230Ab3L3Gtq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 01:49:46 -0500
Date: Mon, 30 Dec 2013 14:48:42 +0800
From: Wang YanQing <udknight@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: jslaby@suse.cz, airlied@redhat.com, akpm@linux-foundation.org,
        kilobyte@angband.pl, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fonts:Kconfig: fix default enable FONT_8x8 and FONT_8x16
 at the same time
Message-ID: <20131230064842.GA6592@udknight>
Mail-Followup-To: Wang YanQing <udknight@gmail.com>,
	Greg KH <gregkh@linuxfoundation.org>, jslaby@suse.cz,
	airlied@redhat.com, akpm@linux-foundation.org, kilobyte@angband.pl,
	linux-kernel@vger.kernel.org
References: <20131230033745.GA5855@udknight>
 <20131230053430.GA11990@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131230053430.GA11990@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 29, 2013 at 09:34:30PM -0800, Greg KH wrote:
> On Mon, Dec 30, 2013 at 11:37:45AM +0800, Wang YanQing wrote:
> > FONT_8x8 and FONT_8x16 have the same default value line:
> > "default y if !SPARC && !FONTS"
> > 
> > I test run "make defconfig" for x86 will enable FONT_8x8 and FONT_8x16 at
> > the same time.
> > 
> > This patch fix it, because FONT_AUTOSELECT choice FONT_8x16, so
> > I decide to disable FONT_8x8, this patch will reduce size of kernel.
> > 
> > Signed-off-by: Wang YanQing <udknight@gmail.com>
> > ---
> >  lib/fonts/Kconfig | 1 -
> >  1 file changed, 1 deletion(-)
> 
> I am not the maintainer of this file, sorry.  Also, I don't think it's
> correct, if you want, you can always disable this option on your own.
> 
Hi Greg KH.

Sorry for confusion, the default behavior enable FONT_8x8 and FONT_8x16,
FONT_8x8 eat ~50KB memory, but kernel never use it. I think this is not
good default behavior.

Thanks.
