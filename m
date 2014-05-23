Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaEWHOo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 03:14:44 -0400
Received: from mail-ie0-f176.google.com ([209.85.223.176]:58758 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752047AbaEWHOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 03:14:42 -0400
MIME-Version: 1.0
In-Reply-To: <20140513001759.5943.52169@quantum>
References: <1395746185-16686-1-git-send-email-geert@linux-m68k.org>
	<20140513001759.5943.52169@quantum>
Date: Fri, 23 May 2014 09:14:41 +0200
X-Google-Sender-Auth: 75AAe1p7T8ug7shKddseXEXlBHo
Message-ID: <CAMuHMdWYTe8=jY3Y_jrZrRiHHMEhAuKHRRAzaC_Gvbi00dFY8A@mail.gmail.com>
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

On Tue, May 13, 2014 at 2:17 AM, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Geert Uytterhoeven (2014-03-25 04:16:24)
>> From: Geert Uytterhoeven <geert+renesas@glider.be>
>>
>>   - Limit ruler to 80 characters (was: 81),
>>   - Widen rate column by 1 for nicer spacing,
>>   - Right-align numbers and their column headers,
>>   - Move a newline to reduce the number of seq_printf() calls,
>>   - Use set_puts() for fixed strings.

>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>
> Thanks for the fix. Taken into clk-next.

I don't see it in clk-next, though?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
