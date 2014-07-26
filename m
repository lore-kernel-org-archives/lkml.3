Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaGZPrh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 11:47:37 -0400
Received: from mail-lb0-f178.google.com ([209.85.217.178]:45641 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaGZPrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 11:47:36 -0400
MIME-Version: 1.0
In-Reply-To: <1406389178-9780-1-git-send-email-geert@linux-m68k.org>
References: <1406389178-9780-1-git-send-email-geert@linux-m68k.org>
Date: Sat, 26 Jul 2014 17:47:34 +0200
X-Google-Sender-Auth: JGCyKzuwBP26ksApGnJBmiCSB0o
Message-ID: <CAMuHMdWjw4wTARUaLQU2vGJ0_-jK+9Bva13QQJPj3uJ+e9mJ4w@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.16-rc6
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 26, 2014 at 5:39 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.16-rc6[1]  to v3.16-rc5[3], the summaries are:
>   - build errors: +6/-12

Nothing serious, just a few know sh-randconfig issues and a few more
R_PPC64_REL24 truncated relocations in powerpc-allyesconfig.

> [1] http://kisskb.ellerman.id.au/kisskb/head/7690/ (all 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/7665/ (all 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
