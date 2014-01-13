Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaAMI1w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 03:27:52 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:57968 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291AbaAMI1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 03:27:50 -0500
Message-ID: <52D3A385.8060504@linaro.org>
Date: Mon, 13 Jan 2014 09:27:49 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Axel Lin <axel.lin@ingics.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [GIT PULL] clockevents/clocksource : new material for 3.14
References: <52C1479E.80808@linaro.org> <20140112163318.GA21054@gmail.com>
In-Reply-To: <20140112163318.GA21054@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/2014 05:33 PM, Ingo Molnar wrote:

[ ... ]

> Pulled into tip:timers/core, thanks Daniel!
>
> Note that there was a conflict in drivers/clocksource/clksrc-of.c,
> caused by interaction with this commit:
>
>    4c4b053235fa clocksource: clksrc-of: Do not drop unheld reference on device node
>
> I've resolved it, but please double check the end result once I've
> pushed it all out.

Done. The resolution is ok.

Thanks !
   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

