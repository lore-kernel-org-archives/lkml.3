Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932401AbaDVL54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:57:56 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:59562 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbaDVL5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:57:33 -0400
Message-ID: <53565947.3020503@linaro.org>
Date: Tue, 22 Apr 2014 13:57:59 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/2] ARM: sunxi: Add A31 High Speed Timer Support
References: <1397725606-18000-1-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1397725606-18000-1-git-send-email-maxime.ripard@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 11:06 AM, Maxime Ripard wrote:
> Hi everyone,
>
> This patchset enables support for the High Speed Timer IP found in the
> Allwinner A31 SoCs.
>
> These timers are asserted in reset, and are not associated with any
> struct device, so we also add a small helper to the reset framework
> along the way to be able to retrieve the reset controller from the
> device tree directly.
>
> Thanks,
> Maxime
>
> Changes from v2:
>    - Rebased on top of 3.15-rc1
>
> Changes from v1:
>    - Rebased on top of 3.14-rc1 and reset/for_3.15
>
> Maxime Ripard (2):
>    clocksource: sun5i: Add support for reset controller
>    ARM: sun6i: a31: Add support for the High Speed Timers
>
>   .../devicetree/bindings/timer/allwinner,sun5i-a13-hstimer.txt |  4 ++++
>   arch/arm/boot/dts/sun6i-a31.dtsi                              | 11 +++++++++++
>   drivers/clocksource/timer-sun5i.c                             |  6 ++++++
>   3 files changed, 21 insertions(+)

Applied for 3.16

Thanks

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

