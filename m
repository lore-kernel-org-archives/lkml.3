Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757895Ab3G3Uzg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 16:55:36 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:34180 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756925Ab3G3Uze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 16:55:34 -0400
Date: Tue, 30 Jul 2013 13:55:32 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>, Nicolas Pitre <nico@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 3/9] ARM: msm: Move debug-macro.S to include/debug
Message-ID: <20130730205532.GA18638@codeaurora.org>
References: <1374699274-18388-1-git-send-email-sboyd@codeaurora.org>
 <1374699274-18388-4-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1374699274-18388-4-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 01:54:28PM -0700, Stephen Boyd wrote:
>One more step to allowing MSM to participate in the
>multi-platform defconfig.

Full patch: https://patchwork.kernel.org/patch/2833034/

>Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>---
> arch/arm/Kconfig.debug                             |  9 +++-
> .../mach/debug-macro.S => include/debug/msm.S}     | 32 ++++++++++-
> arch/arm/mach-msm/include/mach/msm_iomap-8960.h    |  5 --
> arch/arm/mach-msm/include/mach/msm_iomap-8x60.h    |  5 --
> arch/arm/mach-msm/include/mach/msm_iomap.h         | 12 -----
> arch/arm/mach-msm/include/mach/uncompress.h        | 63 ----------------------
> arch/arm/mach-msm/io.c                             | 40 +++++++-------
> 7 files changed, 58 insertions(+), 108 deletions(-)
> rename arch/arm/{mach-msm/include/mach/debug-macro.S => include/debug/msm.S} (61%)
> delete mode 100644 arch/arm/mach-msm/include/mach/uncompress.h

Any comments on this?  This is mostly an MSM change, but I'd like to
get an Ack from someone because of the file moving into
arch/arm/include/debug.

Thanks,
David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
