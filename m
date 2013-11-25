Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab3KYNRy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:17:54 -0500
Received: from www17.your-server.de ([213.133.104.17]:48326 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754364Ab3KYNRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:17:50 -0500
Date: Mon, 25 Nov 2013 14:17:28 +0100
Subject: Re: [i915] BUG: Bad page state in process Xorg
From: thomas@m3y3r.de
To: daniel@ffwll.ch, robdclark@gmail.com
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@linux.ie>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <E1Vkw2k-00015V-Ao@www17.your-server.de>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rAPDI50Z002866

Hi,

It turns out that this seems to be a bug in udl DRM driver.

I bisected the problem to this patch:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/drivers/gpu/drm/udl?id=5dc9e1e87229cb786a5bb58ddd0d60fee6eb4641

With kind regards
Thomas

Am 22.11.2013 17:18 schrieb Daniel Vetter <daniel@ffwll.ch>:
>
> On Fri, Nov 22, 2013 at 4:54 PM, Thomas Meyer <thomas@m3y3r.de> wrote: 
> >> Am 22.11.2013 um 11:55 schrieb Daniel Vetter <daniel@ffwll.ch>: 
> >> 
> >> On Fri, Nov 22, 2013 at 11:36 AM, Dave Airlie <airlied@linux.ie> wrote: 
> >>>> Hi, 
> >>> 
> >>> cc'ing mailing list, 
> >>> 
> >>> Daniel any ideas? 
> >> 
> >> Nope, not really :( And no ideas how to triage this further - if it 
> >> takes 9 days to hit it eventually we'll have a real hard time. Or does 
> >> this happen even after just a short X run? 
> > 
> > Seems to happen every time while stopping the x server. Also after a short run time. 
> > 
> > The current fedora 3.11 kernel doesn't show this bug. I'm using fedora 19, with a self compiled kernel. 
> > 
> > I did turn on config-debug-pagealloc but this didn't show any wrongness. 
>
> In that case I think the bisect is the fastest way to insight - atm 
> I'm really at loss what could be wrong here. 
> -Daniel 
> -- 
> Daniel Vetter 
> Software Engineer, Intel Corporation 
> +41 (0) 79 365 57 48 - http://blog.ffwll.ch 
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
