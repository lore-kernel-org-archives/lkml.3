Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbaE0BCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 21:02:50 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:60245 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaE0BCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 21:02:48 -0400
MIME-Version: 1.0
In-Reply-To: <1400781734-19002-1-git-send-email-geert+renesas@glider.be>
References: <1400781734-19002-1-git-send-email-geert+renesas@glider.be>
Date: Tue, 27 May 2014 10:02:46 +0900
Message-ID: <CANqRtoQk1=ZVJAqio4Oo-2NSO2qVo=xM0sUCDL_sMz1+zyOLPQ@mail.gmail.com>
Subject: Re: [PATCH v3] clk: shmobile: mstp: Fix the is_enabled() operation
From: Magnus Damm <magnus.damm@gmail.com>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Mike Turquette <mturquette@linaro.org>,
        SH-Linux <linux-sh@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 3:02 AM, Geert Uytterhoeven
<geert+renesas@glider.be> wrote:
> From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
>
> The MSTP[SC]R registers have clock stop bits, not clock enable bits. The
> bit value should thus be inverted in the is_enabled() operation.
>
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> Cc: Mike Turquette <mturquette@linaro.org>
> ---
> v3:
>   - This depends on commit 3c90c55dcde745bed81f6447f24ba96bda43d984
>     ("drivers: sh: compile drivers/sh/pm_runtime.c if
>     ARCH_SHMOBILE_MULTI"), which has entered mainline in v3.15-rc6.

Hi Geert,

Thanks for resubmitting this fix. Do you intend to get this included
in v3.15 (seems unlikely) or is your target v3.16?

Cheers,

/ magnus
