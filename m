Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab3LPUIX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:08:23 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:49982 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab3LPUIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:08:22 -0500
Message-ID: <52AF5DB5.8090302@linaro.org>
Date: Mon, 16 Dec 2013 21:08:21 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Thomas Gleixner <tglx@linutronix.de>, Axel Lin <axel.lin@ingics.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] clocksource: time-efm32: Select CLKSRC_MMIO
References: <1384913711.13115.2.camel@phoenix> <20131210132431.GB18888@pengutronix.de> <52A71746.6080809@linaro.org> <20131210160548.GC18888@pengutronix.de>
In-Reply-To: <20131210160548.GC18888@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 05:05 PM, Uwe Kleine-König wrote:
> Hello Daniel,
>
> On Tue, Dec 10, 2013 at 02:29:42PM +0100, Daniel Lezcano wrote:
>> On 12/10/2013 02:24 PM, Uwe Kleine-König wrote:
>>> On Wed, Nov 20, 2013 at 10:15:11AM +0800, Axel Lin wrote:
>>>> The time-efm32 driver uses the clocksource MMIO functions.
>>>> Thus it needs to select CLKSRC_MMIO in Kconfig.

[ ... ]

>> I sent the PR with this patch. If everything is ok, it should be in
>> the next -rc.
> ok. Thanks for your quick reply.
>
> It would be great if your tree were included in linux-next. Don't you
> think this is feasible?

Well, yes it could be a good idea. But if you are suggesting to use 
linux-next for the fixes, that should be already taken into account with 
the #auto-latest branch of tip.




-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

