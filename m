Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbaIEJRf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 05:17:35 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:60721 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbaIEJRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 05:17:33 -0400
MIME-Version: 1.0
In-Reply-To: <CAMuHMdU0GJyYiP8NkELZia00gzKMmVRQ+1YwWCrFRLQytJ6YPw@mail.gmail.com>
References: <201407310023.43605.sergei.shtylyov@cogentembedded.com>
	<540772A1.8080101@cogentembedded.com>
	<CAMuHMdU0GJyYiP8NkELZia00gzKMmVRQ+1YwWCrFRLQytJ6YPw@mail.gmail.com>
Date: Fri, 5 Sep 2014 11:17:30 +0200
X-Google-Sender-Auth: RY8ovfC_to2L8xBiJ6z5I_47XGs
Message-ID: <CAMuHMdUoZ3AX-y51BaBuodu1Lmw1SvzvGUNNEtfPvfYdsWJOCw@mail.gmail.com>
Subject: Re: [PATCH] clk-rcar-gen2: RCAN clock support
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Pavel Kiryukhin <vksavl@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sergei,


On Fri, Sep 5, 2014 at 11:03 AM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> On Wed, Sep 3, 2014 at 9:57 PM, Sergei Shtylyov
> <sergei.shtylyov@cogentembedded.com> wrote:
>> On 07/31/2014 12:23 AM, Sergei Shtylyov wrote:
>>
>>> Add RCAN clock support to the R-Car generation 2 CPG driver. This clock
>>> gets
>>> derived from the USB_EXTAL clock by dividing it by 6. The layout of
>>> RCANCKCR
>>> register is close to those of the clocks supported by the 'clk-div6'
>>> driver
>>> but has no divider field, and so can't be supported by that driver...
>
> I'm not a clock expert (pulling in Laurent), but it looks fine to me.

While you did add the rcan clock to the dtsi in "[PATCH v3 1/3] ARM:
shmobile: r8a7791: add CAN clocks", I couldn't find a patch to update
the renesas,rcar-gen2-cpg-clocks binding doc?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
