Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756685Ab3EOJX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:23:29 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:51123 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab3EOJX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:23:27 -0400
Date: Wed, 15 May 2013 10:23:22 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>,
        Russell King <linux@arm.linux.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH] serial: pl011: protect attribute read from NULL platform
 data struct
Message-ID: <20130515092322.GC3494@gmail.com>
References: <1368103855-28363-1-git-send-email-lee.jones@linaro.org>
 <CACRpkdZR3AsGyCUH=cbskcZPs0PVBjH6QXUGkD+KG8SzGMMOKg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZR3AsGyCUH=cbskcZPs0PVBjH6QXUGkD+KG8SzGMMOKg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 May 2013, Linus Walleij wrote:

> On Thu, May 9, 2013 at 2:50 PM, Lee Jones <lee.jones@linaro.org> wrote:
> 
> > It's completely feasible that platform data will be empty i.e. when
> > booting with Device Tree with no device AUXDATA. So we must protect
> > it's use in these use-cases, or risk a kernel Oops.
> >
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Jiri Slaby <jslaby@suse.cz>
> > Cc: linux-serial@vger.kernel.org
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> > *******                                                        *******
> > If this issue has not already been fixed, this patch should be applied
> > during the v3.10 -rc:s, as it fixes a serious bug which was introduced
> > in the merge-window.
> > *******                                                        *******
> 
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
> 
> You should probably put Greg on To: so that he picks this up for
> the -rc:s ASAP.

I spoke with Greg yesterday. He's catching up on mail.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
