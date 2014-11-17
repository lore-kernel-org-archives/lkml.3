Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaKQQVf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 11:21:35 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:47192 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaKQQVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 11:21:34 -0500
MIME-Version: 1.0
In-Reply-To: <1416241069-30522-1-git-send-email-geert@linux-m68k.org>
References: <1416241069-30522-1-git-send-email-geert@linux-m68k.org>
Date: Mon, 17 Nov 2014 17:21:33 +0100
X-Google-Sender-Auth: IukxP9extXgrrJcgFe19OcVbdm0
Message-ID: <CAMuHMdVRjkXD3EOi-jcJUJH8hJLG9Y+NKNEStEJBO9-XOWXyZA@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.18-rc5
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 17, 2014 at 5:17 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.18-rc5[1] to v3.18-rc4[3], the summaries are:
>   - build errors: +9/-6

Just the obligatory powerpc-allyesconfig relocation truncations.

> [1] http://kisskb.ellerman.id.au/kisskb/head/8092/ (120 out of 119 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/8061/ (120 out of 119 configs)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
