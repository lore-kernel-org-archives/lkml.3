Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751047AbbAHFEa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 00:04:30 -0500
Received: from mail-qa0-f52.google.com ([209.85.216.52]:41440 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbbAHFE3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 00:04:29 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1501072228440.1322@knanqh.ubzr>
References: <alpine.LFD.2.11.1501041547050.18844@knanqh.ubzr>
	<CA+55aFy5yB2d-1iXEUtU+puua4TAmV0kZF_7TBhXO1Y4Khqb9Q@mail.gmail.com>
	<alpine.LFD.2.11.1501041609290.18844@knanqh.ubzr>
	<20150104212659.GC12302@n2100.arm.linux.org.uk>
	<alpine.LFD.2.11.1501042343240.18844@knanqh.ubzr>
	<CAHkRjk6Vg_AR8rFNYzPcnPwfKZqaVuaCoG67CEVPRgp1-bDetA@mail.gmail.com>
	<CA+55aFypmZExpCvD699TQOs1NDK_mT-_rR3UWOdxdzkOKvbdoA@mail.gmail.com>
	<alpine.LFD.2.11.1501071354130.1322@knanqh.ubzr>
	<CA+55aFw70ZvHKH+8_aS7E7FZZuuWQA++zGQuSmuvDE3DWU+x3A@mail.gmail.com>
	<alpine.LFD.2.11.1501071446460.1322@knanqh.ubzr>
	<20150107205346.GO12302@n2100.arm.linux.org.uk>
	<CAHkRjk6FT+WJ3u9qhfB-EMcqhOHGQSe4dW4MpZF6vE97B0vD0A@mail.gmail.com>
	<CA+55aFz0cjsS4BTwtBt9P1pKHmPjXPYnOvFuP07UVoek7jSYLw@mail.gmail.com>
	<alpine.LFD.2.11.1501071914250.1322@knanqh.ubzr>
	<CA+55aFyKz2tZDq6ANjKVmuvipKtjr+UP4c7ypNXtbXBcapOpKg@mail.gmail.com>
	<alpine.LFD.2.11.1501072228440.1322@knanqh.ubzr>
Date: Wed, 7 Jan 2015 21:04:28 -0800
X-Google-Sender-Auth: qJpbapyK6pAUciif6HSETkCFsKA
Message-ID: <CA+55aFyDQ4Mk8hHOvH-2nhpDgN+gBgiLf6=dLVcjKC5uetqzJw@mail.gmail.com>
Subject: Re: [PATCH] Revert 9fc2105aeaaf56b0cf75296a84702d0f9e64437b to fix
 pyaudio (and probably more)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Pavel Machek <pavel@ucw.cz>, Marc Zyngier <marc.zyngier@arm.com>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 8:56 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
>>
>> Yes, I actually would mind, unless you have a damn good reason for it.
>
> Consistency.

Fuck no.

"Completely made up number that you cannot explain" is not consistency.

The *current* situation is consistency. I can - and have in this very
thread - explained what bogomips is in just a sentence or two.

You are just making shit up. Bad shit. Get off the drugs, because it's
not the good kind.

> On ARM we just can't find the CPU clock in a generic way.

Cry me a river.

So you want to make bogomips a totally random number, that has no
meaning, no correlation to any clocksource, and no correlation to cpu
frequency either?

And you argue for this though exactly WHAT? "Consistency".

Bullshit.

This whole thread is now marked as "muted" for me, because I can't
take the BS any more. You make no sense.

You guys playing games with bogomips was what broke things in the
first place, and now you want to play *more* games?

You're crazy. Go away. Or don't. I won't be seeing your emails anyway,
so why would I care?

                            Linus
