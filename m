Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbaG2RsX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 13:48:23 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:58890 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaG2RsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 13:48:21 -0400
MIME-Version: 1.0
In-Reply-To: <1406656015-20105-1-git-send-email-geert@linux-m68k.org>
References: <1406656015-20105-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 29 Jul 2014 19:48:20 +0200
X-Google-Sender-Auth: SoIrarNgmJazB6opi0Zhv-mQ-eA
Message-ID: <CAMuHMdU4RS8C+xHQ6_GWh7nZxmoP7fxu+Ps94U4jQMm+fMxd_A@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.16-rc7
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 29, 2014 at 7:46 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.16-rc7[1]  to v3.16-rc6[3], the summaries are:
>   - build errors: +3/-5

One known randconfig issue and two more R_PPC64_REL24 relocation
truncations.

> [1] http://kisskb.ellerman.id.au/kisskb/head/7708/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7690/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
