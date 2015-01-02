Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbbABJbI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2015 04:31:08 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:51616 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbbABJbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2015 04:31:02 -0500
MIME-Version: 1.0
In-Reply-To: <201412310916.57808.gheskett@wdtv.com>
References: <201412310916.57808.gheskett@wdtv.com>
Date: Fri, 2 Jan 2015 10:31:00 +0100
X-Google-Sender-Auth: iWj4ROJuUj5WBXzAiRcBPUN8PTo
Message-ID: <CAMuHMdU5fPrD-ZLTxQZH0FB3_9VkRNU+aMYkOSNZYS-VoE=fVA@mail.gmail.com>
Subject: Re: apparent loss of continuity in kernel .config?
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Gene Heskett <gheskett@wdtv.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gene,

On Wed, Dec 31, 2014 at 3:16 PM, Gene Heskett <gheskett@wdtv.com> wrote:
> Attempting to go from 3.16.0 to 3.16.7 last night, a make oldconfig
> started from scratch as if there were no .config's in the directory.  I
> stood on the enter key to take the defaults, then ran a make xconfig to
> discover it was totally wrong for an AMD phenom, no networking, no disc
> drivers, video was an old ATI, when there is an nvidia card in it, yadda,
> yadda.

Being someone who runs "make oldconfig" and compares .config.old and .config
all the time, I never saw this. However, those are almost never x86 oldconfigs.

Did it change from 64BIT=y to no or vice versa?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
