Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751790AbaLSAqg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 19:46:36 -0500
Received: from galahad.ideasonboard.com ([185.26.127.97]:51605 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273AbaLSAqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 19:46:35 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        "Simon Horman [Horms]" <horms@verge.net.au>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clocksource: sh_tmu: Set cpu_possible_mask to fix SMP broadcast
Date: Fri, 19 Dec 2014 02:46:37 +0200
Message-ID: <2833437.mUHC45LYXV@avalon>
User-Agent: KMail/4.14.3 (Linux/3.16.5-gentoo; KDE/4.14.3; x86_64; ; )
In-Reply-To: <CANqRtoQbtp_vgmcooiWpUvBMP7txGeYVGT-oLkRfMiM6Y51BQg@mail.gmail.com>
References: <20141216094854.22639.69181.sendpatchset@w520> <2855304.l47b4KVhTf@avalon> <CANqRtoQbtp_vgmcooiWpUvBMP7txGeYVGT-oLkRfMiM6Y51BQg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus,

On Friday 19 December 2014 09:03:00 Magnus Damm wrote:
> On Wed, Dec 17, 2014 at 11:08 AM, Laurent Pinchart wrote:
> > Magnus, you have told me that you've performed tests on Marzen with
> > CONFIG_PREEMPT_NONE and with both TWD enabled and disabled. If you could
> > perform the same tests with CONFIG_PREEMPT instead without noticing any
> > regression I think we can merge your patch. Whatever breakage it has
> > caused in the past is likely hidden somewhere beyond eyesight.
> 
> I've now successfully boot tested the different PREEMPT settings on
> r8a7779 Marzen multiplatform. Everything seems to work as expected.
> 
> Compared to before I've been a bit more lazy, so I've kept the timer
> config to default which means TWD and TMU enabled.

If your test setup is still around could you quickly test PREEMPT + TMU 
without TWD ?

> The kernel tree is renesas-devel-20141218-v3.18 which is v3.18 plus local
> integration stuff including TWD DT. I've applied this patch too.

-- 
Regards,

Laurent Pinchart

