Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaEZH6w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 03:58:52 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:51861 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914AbaEZH6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 03:58:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140523211221.23136.12584@quantum>
References: <1395746185-16686-1-git-send-email-geert@linux-m68k.org>
	<20140513001759.5943.52169@quantum>
	<CAMuHMdWYTe8=jY3Y_jrZrRiHHMEhAuKHRRAzaC_Gvbi00dFY8A@mail.gmail.com>
	<20140523211221.23136.12584@quantum>
Date: Mon, 26 May 2014 09:58:49 +0200
X-Google-Sender-Auth: r1fhC0Jy0w_yjQ34Tgrt5bkHf3A
Message-ID: <CAMuHMdXifbBjCUsnyn=htsfqN7PR2Gy6tnVkOPYz-GWvFN98bA@mail.gmail.com>
Subject: Re: [PATCH] clk: Neaten clk_summary output
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Fri, May 23, 2014 at 11:12 PM, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Geert Uytterhoeven (2014-05-23 00:14:41)
>> On Tue, May 13, 2014 at 2:17 AM, Mike Turquette <mturquette@linaro.org> wrote:
>> > Quoting Geert Uytterhoeven (2014-03-25 04:16:24)
>> >> From: Geert Uytterhoeven <geert+renesas@glider.be>
>> >>
>> >>   - Limit ruler to 80 characters (was: 81),
>> >>   - Widen rate column by 1 for nicer spacing,
>> >>   - Right-align numbers and their column headers,
>> >>   - Move a newline to reduce the number of seq_printf() calls,
>> >>   - Use set_puts() for fixed strings.
>>
>> >> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> >
>> > Thanks for the fix. Taken into clk-next.
>>
>> I don't see it in clk-next, though?
>
> When I say "clk-next" I really mean my local/private branch. You'll see
> it at the end of today when I push my next set of tested patches out to
> my linaro mirror.

Thanks, I can see it now.

Sorry for being so impatient.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
