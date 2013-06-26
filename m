Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751569Ab3FZNYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:24:14 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:62387 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab3FZNYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:24:13 -0400
Message-ID: <51CAEB87.2070209@linaro.org>
Date: Wed, 26 Jun 2013 15:24:23 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Stuart Menefy <stuart.menefy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robherring2@gmail.com>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v7] clocksource:arm_global_timer: Add ARM global timer
 support.
References: <1372247318-28869-1-git-send-email-srinivas.kandagatla@st.com>
In-Reply-To: <1372247318-28869-1-git-send-email-srinivas.kandagatla@st.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 01:48 PM, Srinivas KANDAGATLA wrote:
> From: Stuart Menefy <stuart.menefy@st.com>
> 
> This is a simple driver for the global timer module found in the Cortex
> A9-MP cores from revision r1p0 onwards. This should be able to perform
> the functions of the system timer and the local timer in an SMP system.
> 
> The global timer has the following features:
>     The global timer is a 64-bit incrementing counter with an
> auto-incrementing feature. It continues incrementing after sending
> interrupts. The global timer is memory mapped in the private memory
> region.
>     The global timer is accessible to all Cortex-A9 processors in the
> cluster. Each Cortex-A9 processor has a private 64-bit comparator that
> is used to assert a private interrupt when the global timer has reached
> the comparator value. All the Cortex-A9 processors in a design use the
> banked ID, ID27, for this interrupt. ID27 is sent to the Interrupt
> Controller as a Private Peripheral Interrupt. The global timer is
> clocked by PERIPHCLK.
> 
> Signed-off-by: Stuart Menefy <stuart.menefy@st.com>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Rob Herring <robherring2@gmail.com>
> CC: Linus Walleij <linus.walleij@linaro.org>
> CC: Will Deacon <will.deacon@arm.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> ---
> Thankyou for reveiwing the v6 patch.
> This patch is split out of the orignal 10 patches submitted for Stixxxx SOC
> support to arm-kernel mailing list. This patch has undergone few cycles of
> reviews in arm-kernel mailing list.
> 
> This patch is generated on top of timers/core branch.
> 
> Arnd already picked up SOC support patches [4-10] and merged them via arm-soc
> tree for 3.11.
> And most of the patches are in next branches.
> 
> If its not too late can this patch be considered for 3.11 via clocksource tree?
> This patch has no build dependencies.

I took it in my tree but it is too late for a 3.11, sorry.

Thanks
  -- Daniel

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

