Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbaHZSwr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 14:52:47 -0400
Received: from mail-lb0-f173.google.com ([209.85.217.173]:52291 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752365AbaHZSwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 14:52:46 -0400
MIME-Version: 1.0
In-Reply-To: <1409079005-2454-1-git-send-email-geert@linux-m68k.org>
References: <1409079005-2454-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 26 Aug 2014 20:52:44 +0200
X-Google-Sender-Auth: o3pWeYVOJAQXoRRa6yIbpTAMVvg
Message-ID: <CAMuHMdUpA5DSXn3BQLL1r1Uuigay29R8vhjQXvcRiVYY4ZXPjA@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.17-rc2
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 8:50 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.17-rc2[1]  to v3.17-rc1[3], the summaries are:
>   - build errors: +4/-7

Nothing serious, just a known powerpc-randconfig issue and a few more
R_PPC64_REL24 relocation truncations in powerpc-allyesconfig.

> [1] http://kisskb.ellerman.id.au/kisskb/head/7808/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7787/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
