Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753493AbaIBJ2U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 05:28:20 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:40394 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbaIBJ2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 05:28:18 -0400
MIME-Version: 1.0
In-Reply-To: <1409649666-12855-1-git-send-email-geert@linux-m68k.org>
References: <1409649666-12855-1-git-send-email-geert@linux-m68k.org>
Date: Tue, 2 Sep 2014 11:28:17 +0200
X-Google-Sender-Auth: 7PUCix8FduKV3_fEX5FJresvxOE
Message-ID: <CAMuHMdVEYeNbmbJsQ9Sxji9-ZeYURdBh+CowrGHZO6BSJ9CfBA@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.17-rc3
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 11:21 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> JFYI, when comparing v3.17-rc3[1]  to v3.17-rc2[3], the summaries are:
>   - build errors: +10/-22

Only known randconfig and new R_PPC64_REL24 relocation truncations.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
