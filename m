Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261Ab3KYIyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 03:54:49 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61098 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab3KYIys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 03:54:48 -0500
Message-ID: <5293105C.3070400@linaro.org>
Date: Mon, 25 Nov 2013 09:54:52 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] clksrc-of: warn if no clock sources are found
References: <1384937936-14267-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1384937936-14267-1-git-send-email-linus.walleij@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 09:58 AM, Linus Walleij wrote:
> Many platforms rely on clocksource_of_init() being implicitly
> called for registering clock sources and will get zero warnings
> if no working clock source is available. Let's print a critical
> error message if no clock source is found.
>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---

Applied to my tree for 3.14

Thanks !

   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

