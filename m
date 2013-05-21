Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361Ab3EUG5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:57:37 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:62487 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387Ab3EUG5g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:57:36 -0400
MIME-Version: 1.0
In-Reply-To: <519AE6D7.1090401@asianux.com>
References: <5199B7D6.40907@asianux.com>
	<20130520091008.GB31359@mudshark.cambridge.arm.com>
	<519AE6D7.1090401@asianux.com>
Date: Tue, 21 May 2013 08:57:36 +0200
X-Google-Sender-Auth: CGHprDyor3KbJ-FteQWLGL2WV7M
Message-ID: <CAMuHMdWNHPDkf35MYMKnxt5pn3a+dsT4jgYxuuHrp+mpZMckfw@mail.gmail.com>
Subject: Re: [PATCH] arm64: kernel: need extern variable 'screen_info' for
 related driver using.
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Will Deacon <will.deacon@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 5:15 AM, Chen Gang <gang.chen@asianux.com> wrote:
>> I think it would be better if we added a something like
>> CONFIG_HAVE_VGA_CONSOLE, which VGA_CONSOLE can then depend on. Architectures
>> like x86 can then select the former, and we can remove the long list of
>> architectures from the current option.
>
> I guess your meaning is:
>
>   under arm64, actually, need not support 'VGA_CONSOLE', and 'screen_info' is useless.
>   So better to define 'CONFIG_HAVE_VGA_CONSOLE' which 'VGA_CONSOLE' can depend on it, and in arm64, we do not define CONFIG_HAVE_VGA_CONSOLE.
>
> Is it correct ?

No, you missed "and we can remove the long list of architectures from the
current option".

> If so, I recommend to add depend item for VGA_CONSOLE directly:

I strongly support CONFIG_HAVE_VGA_CONSOLE.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
