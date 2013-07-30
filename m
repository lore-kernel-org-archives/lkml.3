Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260Ab3G3VJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 17:09:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:39325 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757853Ab3G3VJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 17:09:29 -0400
Date: Tue, 30 Jul 2013 22:09:13 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Brown <davidb@codeaurora.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Jason Cooper <jason@lakedaemon.net>, Nicolas Pitre <nico@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 3/9] ARM: msm: Move debug-macro.S to include/debug
Message-ID: <20130730210912.GS24642@n2100.arm.linux.org.uk>
References: <1374699274-18388-1-git-send-email-sboyd@codeaurora.org> <1374699274-18388-4-git-send-email-sboyd@codeaurora.org> <20130730205532.GA18638@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130730205532.GA18638@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 01:55:32PM -0700, David Brown wrote:
> On Wed, Jul 24, 2013 at 01:54:28PM -0700, Stephen Boyd wrote:
>> One more step to allowing MSM to participate in the
>> multi-platform defconfig.
>
> Full patch: https://patchwork.kernel.org/patch/2833034/
>
>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>> ---
>> arch/arm/Kconfig.debug                             |  9 +++-
>> .../mach/debug-macro.S => include/debug/msm.S}     | 32 ++++++++++-
>> arch/arm/mach-msm/include/mach/msm_iomap-8960.h    |  5 --
>> arch/arm/mach-msm/include/mach/msm_iomap-8x60.h    |  5 --
>> arch/arm/mach-msm/include/mach/msm_iomap.h         | 12 -----
>> arch/arm/mach-msm/include/mach/uncompress.h        | 63 ----------------------
>> arch/arm/mach-msm/io.c                             | 40 +++++++-------
>> 7 files changed, 58 insertions(+), 108 deletions(-)
>> rename arch/arm/{mach-msm/include/mach/debug-macro.S => include/debug/msm.S} (61%)
>> delete mode 100644 arch/arm/mach-msm/include/mach/uncompress.h
>
> Any comments on this?  This is mostly an MSM change, but I'd like to
> get an Ack from someone because of the file moving into
> arch/arm/include/debug.

Well, there will be some conflicts in Kconfig.debug, but there's some
other comments.  Please see my reply on the actual patch.
