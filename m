Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251AbaFISNW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 14:13:22 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:53252 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820AbaFISNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 14:13:19 -0400
MIME-Version: 1.0
In-Reply-To: <5395F54C.3080806@codeaurora.org>
References: <1402063412-10407-1-git-send-email-sviau@codeaurora.org>
	<5395F54C.3080806@codeaurora.org>
Date: Mon, 9 Jun 2014 14:13:18 -0400
Message-ID: <CAF6AEGvA7Q_nDR2z2OXvrbsVyqgHoJhoDrC1YmJD2YeXC8Hm6Q@mail.gmail.com>
Subject: Re: [PATCH] drm/msm/hdmi: set hdp clock rate before prepare_enable call
From: Rob Clark <robdclark@gmail.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Stephane Viau <sviau@codeaurora.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 9, 2014 at 1:56 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 06/06/14 07:03, Stephane Viau wrote:
>> The clock driver usually complains when a clock is being prepared
>> before setting its rate. It is the case here for "core_clk" which
>> needs to be set at 19.2 MHz before we attempt a prepare_enable().
>
> That's only true in the downstream vendor kernel. Upstream we detect all
> rates when clocks are registered. Given that 19.2Mhz is the default rate
> out of reset for this clock this patch is fairly useless.
>

well, I've got this patch (with a slight tweak) queued up already..
I'm tempted to keep it, unless downstream kernel can be fixed, just to
make it easier to sync things back to downstream kernel..

BR,
-R

> --
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
>
