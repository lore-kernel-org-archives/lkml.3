Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932399AbaIENdf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 09:33:35 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:64343 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756950AbaIENdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 09:33:33 -0400
Message-ID: <5409BBA8.8080202@cogentembedded.com>
Date: Fri, 05 Sep 2014 17:33:28 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Pavel Kiryukhin <vksavl@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Subject: Re: [PATCH] clk-rcar-gen2: RCAN clock support
References: <201407310023.43605.sergei.shtylyov@cogentembedded.com>	<540772A1.8080101@cogentembedded.com> <CAMuHMdU0GJyYiP8NkELZia00gzKMmVRQ+1YwWCrFRLQytJ6YPw@mail.gmail.com>
In-Reply-To: <CAMuHMdU0GJyYiP8NkELZia00gzKMmVRQ+1YwWCrFRLQytJ6YPw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09/05/2014 01:03 PM, Geert Uytterhoeven wrote:

>>> Add RCAN clock support to the R-Car generation 2 CPG driver. This clock
>>> gets
>>> derived from the USB_EXTAL clock by dividing it by 6. The layout of
>>> RCANCKCR
>>> register is close to those of the clocks supported by the 'clk-div6'
>>> driver
>>> but has no divider field, and so can't be supported by that driver...

>>> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

>>> ---
>>> The patch is against the 'clk-next' branch of Mike Turquette's 'linux.git'
>>> repo.

>>>    drivers/clk/shmobile/clk-rcar-gen2.c |   99
>>> +++++++++++++++++++++++++++++++++++
>>>    1 file changed, 99 insertions(+)

>>     More than a months has passed, there hasn't been any feedback, patch
>> hasn't been applied... what's wrong with it?

> Sorry for missing this, it went under my radar.

> I'm not a clock expert (pulling in Laurent), but it looks fine to me.
> I'm just wondering whether you can simplify the code by using clk-gate?

    The gated clocks inherit their clock rate from the parent, while the RCAN 
clock has a fixed divisor (6). I'm gonna look into composite clocks instead.

> Gr{oetje,eeting}s,
>                          Geert

WBR, Sergei

