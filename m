Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaLSADE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 19:03:04 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:39713 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaLSADB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 19:03:01 -0500
MIME-Version: 1.0
In-Reply-To: <2855304.l47b4KVhTf@avalon>
References: <20141216094854.22639.69181.sendpatchset@w520>
	<CAMuHMdUzys9pbEjUybyDP-3=uemLZuP5WgXeyONxGmADUJJL4A@mail.gmail.com>
	<CANqRtoRTcC_ixjY_Qr1T=2Jhh9qu_5+=Z3YRBDUJX8HWHP6Nog@mail.gmail.com>
	<2855304.l47b4KVhTf@avalon>
Date: Fri, 19 Dec 2014 09:03:00 +0900
Message-ID: <CANqRtoQbtp_vgmcooiWpUvBMP7txGeYVGT-oLkRfMiM6Y51BQg@mail.gmail.com>
Subject: Re: [PATCH] clocksource: sh_tmu: Set cpu_possible_mask to fix SMP broadcast
From: Magnus Damm <magnus.damm@gmail.com>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Laurent,

On Wed, Dec 17, 2014 at 11:08 AM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> Magnus, you have told me that you've performed tests on Marzen with
> CONFIG_PREEMPT_NONE and with both TWD enabled and disabled. If you could
> perform the same tests with CONFIG_PREEMPT instead without noticing any
> regression I think we can merge your patch. Whatever breakage it has caused in
> the past is likely hidden somewhere beyond eyesight.

I've now successfully boot tested the different PREEMPT settings on
r8a7779 Marzen multiplatform. Everything seems to work as expected.

Compared to before I've been a bit more lazy, so I've kept the timer
config to default which means TWD and TMU enabled. The kernel tree is
renesas-devel-20141218-v3.18 which is v3.18 plus local integration
stuff including TWD DT. I've applied this patch too.

Thanks,

/ magnus
