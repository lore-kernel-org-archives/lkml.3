Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766AbaAWRZm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 12:25:42 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:41486 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961AbaAWRZk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 12:25:40 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 0/2] Enable clock controllers on MSM
References: <1389921904-3777-1-git-send-email-sboyd@codeaurora.org>
Date: Thu, 23 Jan 2014 09:25:37 -0800
In-Reply-To: <1389921904-3777-1-git-send-email-sboyd@codeaurora.org> (Stephen
	Boyd's message of "Thu, 16 Jan 2014 17:25:02 -0800")
Message-ID: <878uu6y5im.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Boyd <sboyd@codeaurora.org> writes:

> These patches add the clock controller nodes, enable the clock drivers
> on MSM based platforms, and hook it up enough to get the serial console
> working. This is based on the merge of Mike's clk-next branch with
> linux-next-20140116. The changes need the clk-next branch because that's
> where the DTS include files landed.

I forgot to repond to this earlier, but I tested this on top of -next
and it gets the dragonboard booting w/mainline.  Yay!

> Perhaps this can be applied after 3.14-rc1 is out?

Yeah, sounds good.

Kevin

> Stephen Boyd (2):
>   ARM: dts: msm: Add clock controller nodes and hook into uart
>   ARM: msm_defconfig: Enable MSM clock drivers
>
>  arch/arm/boot/dts/qcom-msm8660-surf.dts | 11 +++++++++++
>  arch/arm/boot/dts/qcom-msm8960-cdp.dts  | 18 ++++++++++++++++++
>  arch/arm/boot/dts/qcom-msm8974.dtsi     | 24 ++++++++++++++++++++++++
>  arch/arm/configs/msm_defconfig          |  4 ++++
>  4 files changed, 57 insertions(+)
