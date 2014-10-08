Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527AbaJHHZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 03:25:34 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:47806 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754076AbaJHHZd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 03:25:33 -0400
X-Originating-IP: 88.159.34.112
From: Maarten ter Huurne <maarten@treewalker.org>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Apelete Seketeli <apelete@seketeli.net>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fonts: Add 6x10 font
Date: Wed, 08 Oct 2014 09:25:11 +0200
Message-ID: <2514574.0C4va8fPM6@hyperion>
User-Agent: KMail/4.14.1 (Linux/3.11.10-21-desktop; KDE/4.14.1; x86_64; ; )
In-Reply-To: <542A7ADA.4010500@ti.com>
References: <1410263188-10532-1-git-send-email-maarten@treewalker.org> <542A7ADA.4010500@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 30 September 2014 12:41:46 Tomi Valkeinen wrote:
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
> > 
> >  include/linux/font.h  |    4 +-
> >  lib/fonts/Kconfig     |    9 +
> >  lib/fonts/Makefile    |    1 +
> >  lib/fonts/font_6x10.c | 3086
> >  +++++++++++++++++++++++++++++++++++++++++++++++++ lib/fonts/fonts.c   
> >   |    4 +
> >  5 files changed, 3103 insertions(+), 1 deletion(-)
> >  create mode 100644 lib/fonts/font_6x10.c
> 
> I think the patch is fine, but there hasn't been any comments or acks
> for this. I'm a bit reluctant to add this much data to the kernel if
> there are no users (except you) for this.

Are you counting end users, developers or projects? We've got at least 
several thousand end users in OpenDingux for Dingoo A320 and GCW Zero 
combined. I could ask a few fellow developers for signed-off-by lines, if 
that helps. But it's all from the same project.

I think the font fills a space that is currently unoccupied: the 4x6 font is 
space efficient but barely readable, the 8x8 font gets only 40 columns on 
320x240 and the 6x11 font doesn't use the vertical space efficiently.

Bye,
		Maarten

