Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857Ab3HUIV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 04:21:56 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:38367 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450Ab3HUIVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 04:21:52 -0400
Date: Wed, 21 Aug 2013 09:21:42 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Olof Johansson <olof@lixom.net>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: [PATCH 05/13] ARM: ux500: Apply a ste-* prefix onto snowball.dts
Message-ID: <20130821082142.GB29850@lee--X1>
References: <1374243229-8585-1-git-send-email-lee.jones@linaro.org>
 <1374243229-8585-6-git-send-email-lee.jones@linaro.org>
 <CAOesGMgd51g7WAkQu+ckT-=skKuMyj19nJkHxh+YmGSBhSL+Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOesGMgd51g7WAkQu+ckT-=skKuMyj19nJkHxh+YmGSBhSL+Vg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Aug 2013, Olof Johansson wrote:

> On Fri, Jul 19, 2013 at 7:13 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  arch/arm/boot/dts/{snowball.dts => ste-snowball.dts} | 0
> >  1 file changed, 0 insertions(+), 0 deletions(-)
> >  rename arch/arm/boot/dts/{snowball.dts => ste-snowball.dts} (100%)
> >
> > diff --git a/arch/arm/boot/dts/snowball.dts b/arch/arm/boot/dts/ste-snowball.dts
> > similarity index 100%
> > rename from arch/arm/boot/dts/snowball.dts
> > rename to arch/arm/boot/dts/ste-snowball.dts
> 
> Grmbl, grmbl, grmbl. This now breaks any script that knows to use
> snowball.dtb. :(
> 
> It's good to get the prefixes added, but it's annoying to have to deal
> with both during an overlap period. Maybe generate both dtb filenames
> for a while but rename the source?

How would you create both DTB files from one DTS file?

Surely they only solution would be to maintain both snowball.dts and
ste-snowball.dts at the same time, which doesn't sound logical at all.

Why can't you do as Linus and I have done and just change your script?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
