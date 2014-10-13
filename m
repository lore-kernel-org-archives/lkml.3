Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaJMTx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 15:53:29 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:50593 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751188AbaJMTx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 15:53:28 -0400
MIME-Version: 1.0
In-Reply-To: <20141013182423.39feb60f.m.chehab@samsung.com>
References: <1412234489-1330-1-git-send-email-thierry.reding@gmail.com>
	<CAMuHMdXG1pD1-O2m1NXp6gr4aVqyqV=-x-nPoWQJMWr_0XF42w@mail.gmail.com>
	<20141013182423.39feb60f.m.chehab@samsung.com>
Date: Mon, 13 Oct 2014 21:53:26 +0200
X-Google-Sender-Auth: sTB-MLexwiLtI8MRjKrEoBmdGCE
Message-ID: <CAMuHMdUwPhr7J8Zh2eNFJa4DmJ8005qGvJWhu7Sv8X6Q4po5aA@mail.gmail.com>
Subject: Re: [PATCH] [media] s5p-jpeg: Only build suspend/resume for PM
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mauro,

On Mon, Oct 13, 2014 at 6:24 PM, Mauro Carvalho Chehab
<m.chehab@samsung.com> wrote:
> Em Mon, 13 Oct 2014 18:16:10 +0200
> Geert Uytterhoeven <geert@linux-m68k.org> escreveu:
>> On Thu, Oct 2, 2014 at 9:21 AM, Thierry Reding <thierry.reding@gmail.com> wrote:
>> > From: Thierry Reding <treding@nvidia.com>
>> >
>> > If power management is disabled these function become unused, so there
>> > is no reason to build them. This fixes a couple of build warnings when
>> > PM(_SLEEP,_RUNTIME) is not enabled.
>>
>> Thanks!
>>
>> Despite the availability of your patch, this build warning has
>> migrated to mainline.
>
> That's because I didn't have any time yet to backport the fixes for
> 3.18 and send those to -next. Also, while warnings are annoying,
> a warning like that is not really an urgent matter, as gcc should
> remove the dead code anyway.

Understood.

> I should be handling fixes next week, after my return from LinuxCon EU,
> gstreamer conf, audio mini-summit and media summit. This will be a too
> busy week.

I hope you'll enjoy the busy conference week. We're all hamsters in the same
threadmill, CU ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
