Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965162Ab3E2IWW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 04:22:22 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:49309 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964992Ab3E2IWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 04:22:19 -0400
Message-ID: <51A5BAB8.7000906@linaro.org>
Date: Wed, 29 May 2013 10:22:16 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] clocksource: dw_apb: fix error check
References: <90d7cc35674bf04806531eb2e9836fdc382868d9.1369655478.git.baruch@tkos.co.il>
In-Reply-To: <90d7cc35674bf04806531eb2e9836fdc382868d9.1369655478.git.baruch@tkos.co.il>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2013 01:51 PM, Baruch Siach wrote:
> irq_of_parse_and_map() returns 0 on error, while the code checks for NO_IRQ.
> This breaks on platforms that have NO_IRQ != 0.
> 
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Baruch Siach <baruch@tkos.co.il>
> ---

I queued the patch in my tree [1] for 3.11

Thanks
  -- Daniel

[1]
https://git.linaro.org/gitweb?p=people/dlezcano/clockevents.git;a=shortlog;h=refs/heads/timers/clockevents

-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

