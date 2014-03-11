Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754528AbaCKQXj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 12:23:39 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:53300 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279AbaCKQXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 12:23:38 -0400
MIME-Version: 1.0
In-Reply-To: <1802214.NxZUiJcWLG@avalon>
References: <1394531952-3905-1-git-send-email-geert@linux-m68k.org>
	<1394531952-3905-2-git-send-email-geert@linux-m68k.org>
	<1802214.NxZUiJcWLG@avalon>
Date: Tue, 11 Mar 2014 17:23:37 +0100
X-Google-Sender-Auth: YMPtAKXbQ-qupqLSuCl2BjwnLuA
Message-ID: <CAMuHMdVOUuFsObEag_MwUT_jaqfOHMEcUScrkbaTEitmyJr+NQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] spi: sh-msiof: Convert to spi core auto_runtime_pm framework
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mark Brown <broonie@kernel.org>, linux-spi <linux-spi@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@linux-m68k.org>,
        Magnus Damm <magnus.damm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Tue, Mar 11, 2014 at 4:55 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Does this require drivers/sh/pm_runtime.c to be compiled in ?

Let's check...

My koelsch-legacy kernel has drivers/sh/pm_runtime.c compiled in.
My koelsch-reference kernel hasn't.

However, under the -reference kernel many MSTP clocks (incl. MSIOF)
seem to be enabled all the time, while under -legacy they are enabled and
disabled on demand.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
