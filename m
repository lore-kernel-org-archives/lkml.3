Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab3A1I0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 03:26:52 -0500
Received: from mail-ve0-f181.google.com ([209.85.128.181]:58323 "EHLO
	mail-ve0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753671Ab3A1I0u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 03:26:50 -0500
X-Greylist: delayed 383 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jan 2013 03:26:49 EST
MIME-Version: 1.0
In-Reply-To: <51063248.5010800@samsung.com>
References: <1359282808-31398-1-git-send-email-geert@linux-m68k.org>
	<CAMuHMdU=4+AZDTHABzwkEEeDQNtMZfWgb23Tf1f1befofGMcQQ@mail.gmail.com>
	<51063248.5010800@samsung.com>
Date: Mon, 28 Jan 2013 09:20:25 +0100
X-Google-Sender-Auth: zgQ0JG7_Foc3Cf7NkBHmvv8yrSU
Message-ID: <CAMuHMdX_ihQO6=npNf+0O+VPNjUT=6kEbGgROjX30Y-4S7pX8A@mail.gmail.com>
Subject: Re: [PATCH v2 0/9] Provide dma_mmap_coherent() and dma_get_sgtable()
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On Mon, Jan 28, 2013 at 9:09 AM, Marek Szyprowski
<m.szyprowski@samsung.com> wrote:
> On 1/27/2013 11:43 AM, Geert Uytterhoeven wrote:
>> On Sun, Jan 27, 2013 at 11:33 AM, Geert Uytterhoeven
>> <geert@linux-m68k.org> wrote:
>> > I'll add this to the m68k for-next branch, so hopefully we can get an
>> > unbroken build in 3.8.
>>
>> Sorry, I meant "for-linus", as it's destined for 3.8, not 3.9.
>
> Do you want me to take those patches via dma-mapping tree or get my ack
> and put them together with your other m68k fixes for v3.8?

I don't mind if you take them, as that means less work for me ;-)
Thanks!

The other m68k fixes were pulled by Linus in 3.8-rc5, so I have no other things
left for 3.8.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
