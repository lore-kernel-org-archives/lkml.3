Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751463Ab3JUUx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 16:53:28 -0400
Received: from mail-wg0-f49.google.com ([74.125.82.49]:58765 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110Ab3JUUx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 16:53:27 -0400
Message-ID: <52659443.2050203@linaro.org>
Date: Mon, 21 Oct 2013 22:53:23 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Nicolas Ferre <nicolas.ferre@atmel.com>, linux-kernel@vger.kernel.org,
        Marc Pignat <marc.pignat@hevs.ch>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>, kernel@pengutronix.de,
        John Stulz <john.stultz@linaro.org>,
        Ronald Wahl <ronald.wahl@raritan.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] fixes for integer rounding in timer core
References: <alpine.DEB.2.02.1309191629040.4089@ionos.tec.linutronix.de> <1380052223-24139-1-git-send-email-u.kleine-koenig@pengutronix.de> <5253D9A1.1080106@pengutronix.de> <20131008153147.GR10079@pengutronix.de> <20131014073436.GX10079@pengutronix.de> <20131021071240.GI10079@pengutronix.de>
In-Reply-To: <20131021071240.GI10079@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2013 09:12 AM, Uwe Kleine-König wrote:
> Hello,
>
> [added Daniel Lezcano to To:]
>
> On Mon, Oct 14, 2013 at 09:34:37AM +0200, Uwe Kleine-König wrote:
>> On Tue, Oct 08, 2013 at 05:31:47PM +0200, Uwe Kleine-König wrote:
>>>> What's the status of this patch?
>>> I pinged Thomas about it already via irc, but I didn't get a response up
>>> to now. It would be great to get that into 3.12. To make it easy for
>>> Thomas, here is a pull request that includes the fix and converts
>>> at91rm9200 back to clockevents_config_and_register dropping one of the
>>> workarounds for the fixed bug.

[ ... ]

>>> ----------------------------------------------------------------
>>> The first patch in this pull request fixes an old integer rounding bug in the
>>> timer core that was (and still is) worked around in a few arch's timer code.
>>> The second patch drops such a work around now that the core is fixed.
>> It would be nice to get that fix into 3.12, but Thomas stopped
>> responding nearly a month ago---his last mail in this thread[1] dates back
>> to September 20.
> Still no sign of life from Thomas.
>
>> Can one of you please take it directly?
> Daniel, would you care to take it?

Yes, sure.

   -- Daniel


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

