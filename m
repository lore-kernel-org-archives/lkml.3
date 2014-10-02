Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644AbaJBMn1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 08:43:27 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:34245 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaJBMn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 08:43:26 -0400
Date: Thu, 2 Oct 2014 13:40:37 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Maarten ter Huurne <maarten@treewalker.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Apelete Seketeli <apelete@seketeli.net>, <linux-fbdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fonts: Add 6x10 font
Message-ID: <20141002134037.4d437d7b@alan.etchedpixels.co.uk>
In-Reply-To: <542A7ADA.4010500@ti.com>
References: <1410263188-10532-1-git-send-email-maarten@treewalker.org>
	<542A7ADA.4010500@ti.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Sep 2014 12:41:46 +0300
Tomi Valkeinen <tomi.valkeinen@ti.com> wrote:

> Hi,
> 
> On 09/09/14 14:46, Maarten ter Huurne wrote:
> > This font is suitable for framebuffer consoles on devices with a
> > 320x240 screen, to get a reasonable number of characters (53x24) that
> > are still at a readable size.
> > 
> > The font is derived from the existing 6x11 font, but gets 3 extra
> > lines without sacrificing readability. Also I redesigned a some glyhps
> > so they are more distinct and better fill the available space.
> > 
> > Signed-off-by: Maarten ter Huurne <maarten@treewalker.org>
> > ---
> >  include/linux/font.h  |    4 +-
> >  lib/fonts/Kconfig     |    9 +
> >  lib/fonts/Makefile    |    1 +
> >  lib/fonts/font_6x10.c | 3086 +++++++++++++++++++++++++++++++++++++++++++++++++
> >  lib/fonts/fonts.c     |    4 +
> >  5 files changed, 3103 insertions(+), 1 deletion(-)
> >  create mode 100644 lib/fonts/font_6x10.c
> 
> I think the patch is fine, but there hasn't been any comments or acks
> for this. I'm a bit reluctant to add this much data to the kernel if
> there are no users (except you) for this.
> 
> So I'd like to hear at least one "yeah, I could maybe use that font"
> from someone =).

It only going to get linked if someone asks for it so that seems ok to
me. We support a variety of panels and the like with 320x240 displays and
ucLinux platforms so IMHO it makes sense to have such a font available.

I am planning to use the font - just ermm.. not in Linux ;)

Alan
