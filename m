Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbaKXOTq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 09:19:46 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:58754 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbaKXOTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 09:19:45 -0500
Message-ID: <54733E7B.7090602@linaro.org>
Date: Mon, 24 Nov 2014 15:19:39 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sudeep Holla <Sudeep.Holla@arm.com>, Will Deacon <Will.Deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "dianders@chromium.org" <dianders@chromium.org>,
        Marc Zyngier <Marc.Zyngier@arm.com>, Olof Johansson <olof@lixom.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH v5] clocksource: arch_timer: Fix code to use physical
 timers when requested
References: <1416812564-26465-1-git-send-email-sonnyrao@chromium.org> <5472F3F0.8060701@linaro.org> <20141124141649.GD15872@e104818-lin.cambridge.arm.com>
In-Reply-To: <20141124141649.GD15872@e104818-lin.cambridge.arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2014 03:16 PM, Catalin Marinas wrote:
> Acked-by: Catalin Marinas<catalin.marinas@arm.com>

Thanks !

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

