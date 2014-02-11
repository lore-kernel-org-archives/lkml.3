Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547AbaBKM6H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:58:07 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:46420 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaBKM6F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:58:05 -0500
Message-ID: <52FA1E59.1000307@linaro.org>
Date: Tue, 11 Feb 2014 13:58:01 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>, santosh.shilimkar@ti.com,
        rob@landley.net, linux@arm.linux.org.uk, galak@codeaurora.org
CC: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, tglx@linutronix.de,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        grygorii.strashko@ti.com, joshc@codeaurora.org
Subject: Re: [PATCH v6 1/3] clocksource: timer-keystone: introduce clocksource
 driver for Keystone
References: <1392027058-11680-1-git-send-email-ivan.khoronzhuk@ti.com> <1392027058-11680-2-git-send-email-ivan.khoronzhuk@ti.com>
In-Reply-To: <1392027058-11680-2-git-send-email-ivan.khoronzhuk@ti.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/10/2014 11:10 AM, Ivan Khoronzhuk wrote:
> Add broadcast clock-event device for the Keystone arch.
>
> The timer can be configured as a general-purpose 64-bit timer,
> dual general-purpose 32-bit timers. When configured as dual 32-bit
> timers, each half can operate in conjunction (chain mode) or
> independently (unchained mode) of each other.
>
> Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>
> Acked-by: Santosh shilimkar <santosh.shilimkar@ti.com>
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---

Applied to my tree for 3.15

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

