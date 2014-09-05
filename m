Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaIEPr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 11:47:56 -0400
Received: from mail-la0-f43.google.com ([209.85.215.43]:47285 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaIEPrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 11:47:53 -0400
Message-ID: <5409DB25.3070204@cogentembedded.com>
Date: Fri, 05 Sep 2014 19:47:49 +0400
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
References: <201407310023.43605.sergei.shtylyov@cogentembedded.com>	<540772A1.8080101@cogentembedded.com>	<CAMuHMdU0GJyYiP8NkELZia00gzKMmVRQ+1YwWCrFRLQytJ6YPw@mail.gmail.com> <CAMuHMdUoZ3AX-y51BaBuodu1Lmw1SvzvGUNNEtfPvfYdsWJOCw@mail.gmail.com>
In-Reply-To: <CAMuHMdUoZ3AX-y51BaBuodu1Lmw1SvzvGUNNEtfPvfYdsWJOCw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2014 01:17 PM, Geert Uytterhoeven wrote:

>>>> Add RCAN clock support to the R-Car generation 2 CPG driver. This clock
>>>> gets
>>>> derived from the USB_EXTAL clock by dividing it by 6. The layout of
>>>> RCANCKCR
>>>> register is close to those of the clocks supported by the 'clk-div6'
>>>> driver
>>>> but has no divider field, and so can't be supported by that driver...

>> I'm not a clock expert (pulling in Laurent), but it looks fine to me.

> While you did add the rcan clock to the dtsi in "[PATCH v3 1/3] ARM:
> shmobile: r8a7791: add CAN clocks", I couldn't find a patch to update
> the renesas,rcar-gen2-cpg-clocks binding doc?

    Thanks, I didn't know I need to update the bindings as well...

> Gr{oetje,eeting}s,
>                          Geert

WBR, Sergei

