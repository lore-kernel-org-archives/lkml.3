Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932304AbaKSIke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 03:40:34 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:41914 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259AbaKSIka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 03:40:30 -0500
MIME-Version: 1.0
In-Reply-To: <20141118231239.25314.54610@quantum>
References: <CAMuHMdX1U1YQ29gcveLq2YbdGohk60+pXbjjJU1bV+AM1ZxZFg@mail.gmail.com>
	<20141118231239.25314.54610@quantum>
Date: Wed, 19 Nov 2014 09:40:28 +0100
X-Google-Sender-Auth: BvMGIInHdyf8CXKi1uj-ICCjASc
Message-ID: <CAMuHMdXWXXsj6HXRwO+N4osFeOpeMscZSX0SaOrHdQ0i0fFjoQ@mail.gmail.com>
Subject: Re: [git pull] clk/shmobile updates for v3.19
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Mike Turquette <mturquette@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>, Simon Horman <horms@verge.net.au>,
        Ulrich Hecht <ulrich.hecht@gmail.com>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mike,

On Wed, Nov 19, 2014 at 12:12 AM, Mike Turquette <mturquette@linaro.org> wrote:
> Quoting Geert Uytterhoeven (2014-11-12 06:02:29)
>> This is my first pull request from renesas-drivers.
>> If there's anything that can be improved, please let me know.
>> Thanks!
>
> Hurray for new pull requests! They simplify things a lot.

Good to hear you're happy ;-)

>> The following changes since commit 206c5f60a3d902bc4b56dab2de3e88de5eb06108:
>>
>>   Linux 3.18-rc4 (2014-11-09 14:55:29 -0800)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/geert/renesas-drivers.git
>> div6-clk-for-3.19
>
> Minor nitpick: its easier for me to copy/paste the line above if it is
> not wrapped.

Will not use the gmail web interface next time.

>> for you to fetch changes up to bfadcadf03a63bc841f69ed1c47e930b2ba2273d:
>>
>>   clk: shmobile: document DIV6 clock parent bindings (2014-11-12 14:24:08 +0100)
>>
>> Summary:
>>   - clk: shmobile: DIV6 clock variable parent support (from Ulrich Hecht)
>>
>> Thanks for pulling!
>>
>> ----------------------------------------------------------------
>> Ulrich Hecht (2):
>>       clk: shmobile: div6: support selectable-input clocks
>>       clk: shmobile: document DIV6 clock parent bindings
>
> So the move to generic clock-indices didn't make it in? See:
>
> http://lkml.kernel.org/r/<1415645379-3366-1-git-send-email-geert+renesas@glider.be>

That would be a separate topic/branch.

However, as that series has only one patch for your tree, I hoped you could
take "[PATCH v2 1/6] clk: shmobile: Deprecate renesas,clock-indices" manually?
After that Simon can apply the .dtsi updates.

Alternatively, you can give your ack and Simon can take the whole series?

Or do you still prefer a pull request?

> Anyways these changes look good to me and I've applied them to clk-next.

Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
