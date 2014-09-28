Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716AbaI1JoS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 05:44:18 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:51879 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbaI1JoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 05:44:16 -0400
MIME-Version: 1.0
In-Reply-To: <m2oau09j6k.fsf@linux-m68k.org>
References: <1411896385-25384-1-git-send-email-geert@linux-m68k.org>
	<m2oau09j6k.fsf@linux-m68k.org>
Date: Sun, 28 Sep 2014 11:44:14 +0200
X-Google-Sender-Auth: MxFoA--Xjzoj3kbOygl0K_uR3rM
Message-ID: <CAMuHMdUXk5HxwXzTMWP6R0W6gTA+vqNuu75z1DHa=8sF8SxL0g@mail.gmail.com>
Subject: Re: [PATCH 1/5] m68k: Disable/restore interrupts in hwreg_present()/hwreg_write()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Finn Thain <fthain@telegraphics.com.au>,
        linux-m68k <linux-m68k@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 11:40 AM, Andreas Schwab <schwab@linux-m68k.org> wrote:
>> While most callers run early, before interrupt are disabled, or
>
>                                        interrupts are enabled

Thanks, will fix.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
