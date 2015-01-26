Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195AbbAZK0w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:26:52 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46547 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164AbbAZK0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:26:48 -0500
Message-ID: <54C61665.1000300@linaro.org>
Date: Mon, 26 Jan 2015 11:26:45 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Baruch Siach <baruch@tkos.co.il>
CC: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/2] clocksource: driver for Conexant Digicolor SoC
 timer
References: <cover.1422256855.git.baruch@tkos.co.il> <d2d06d04f8ee8acb62e7748b42c3177229de478a.1422256855.git.baruch@tkos.co.il> <54C60C4F.50507@linaro.org> <20150126101511.GC3148@tarshish>
In-Reply-To: <20150126101511.GC3148@tarshish>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 11:15 AM, Baruch Siach wrote:
> Hi Daniel,

[ ... ]

>>
>> What do you think ?
>
> OK. I'll give it a try.
>
> Thanks for your prompt response and thorough review.

Maxime Ripard just sent a patchset (patch 4/5) with some changes 
suggested above :)

http://www.spinics.net/lists/arm-kernel/msg394704.html

As you may see, the enable/disable is passing the timer channel as 
parameter while I suggested to store it in the structure. It is up to 
you to choose what fits better for your future needs.

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

