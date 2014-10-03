Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751882AbaJCIyf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 04:54:35 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:34303 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbaJCIyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 04:54:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdUXk5HxwXzTMWP6R0W6gTA+vqNuu75z1DHa=8sF8SxL0g@mail.gmail.com>
References: <1411896385-25384-1-git-send-email-geert@linux-m68k.org>
	<m2oau09j6k.fsf@linux-m68k.org>
	<CAMuHMdUXk5HxwXzTMWP6R0W6gTA+vqNuu75z1DHa=8sF8SxL0g@mail.gmail.com>
Date: Fri, 3 Oct 2014 10:54:31 +0200
X-Google-Sender-Auth: d6aefdxvV-afi6HX2ozDKXs8_NQ
Message-ID: <CAMuHMdUD7yzx2pORC-+QKPubWFbafxCMF59ZH5ajZLEvJV0_aQ@mail.gmail.com>
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

On Sun, Sep 28, 2014 at 11:44 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Sun, Sep 28, 2014 at 11:40 AM, Andreas Schwab <schwab@linux-m68k.org> wrote:
>>> While most callers run early, before interrupt are disabled, or
>>
>>                                        interrupts are enabled
>
> Thanks, will fix.

Fixed and queued for 3.18, together with the reformat in PATCH 2/5.

I'll resend the remaining 3 after v3.18-rc1.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
