Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522AbaJPMdL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 08:33:11 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:37375 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490AbaJPMdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 08:33:09 -0400
Message-ID: <543FBAFD.7060205@linaro.org>
Date: Thu, 16 Oct 2014 14:33:01 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
CC: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: integrator: move AP timer to clocksource
References: <1413444463-15823-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1413444463-15823-1-git-send-email-linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16/2014 09:27 AM, Linus Walleij wrote:
> This moves the timer/clocksource implementation for the
> Integrator/AP down to drivers/clocksource and augments the
> driver a little to use CLOCKSOURCE_OF_DECLARE(). Remove
> the static mapping of the timer blocks while we're at it.
>
> Tested on the Integrator/AP.
>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Daniel, Thomas: can you ACK this to be taken through ARM SoC?

Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

