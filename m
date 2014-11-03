Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294AbaKCRqH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 12:46:07 -0500
Received: from v032797.home.net.pl ([89.161.177.31]:63903 "HELO
	v032797.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753136AbaKCRqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 12:46:05 -0500
Message-ID: <5457BF57.3020906@elproma.com.pl>
Date: Mon, 03 Nov 2014 18:45:59 +0100
From: =?UTF-8?B?SmFudXN6IFXFvHlja2k=?= <j.uzycki@elproma.com.pl>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>,
        Thierry Reding <thierry.reding@gmail.com>
CC: Philipp Zabel <p.zabel@pengutronix.de>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-pwm@vger.kernel.org
Subject: Re: [PATCH] clk: Add PWM clock driver
References: <5410AEFD.5030302@elproma.com.pl> <20140923085130.GO30514@ulmo> <20140927200122.19023.40310@quantum>
In-Reply-To: <20140927200122.19023.40310@quantum>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


W dniu 2014-09-27 o 22:01, Mike Turquette pisze:
> Quoting Thierry Reding (2014-09-23 01:51:31)
>> On Wed, Sep 10, 2014 at 10:05:17PM +0200, Janusz Użycki wrote:
>>> Hi,
>>>
>>> http://patchwork.ozlabs.org/patch/359069/
>>> https://lkml.org/lkml/2014/6/12/186
>>>
>>> Will the patch ever included to linux-next?
>> I've never seen this patch before. From a quick look it doesn't seem
>> like it would work as is, but the idea is certainly interesting. If
>> somebody decides to continue work on it, please Cc me and the linux-pwm
>> mailing list.
> I just merged a gpio-controlled clock gate and I'm fine with a PWM clock
> output.
>
> Janusz, how are you testing the clock driver?

Sorry, I didn't noticed the email.
I didn't test the patch yet. However I plan to check it this year.

best regards
Janusz

>
> Regards,
> Mike
>
>>> pwm_config()  API could be extended to support
>>> not only period [ns] and duty [ns] time
>>> but also frequency [Hz] and duty cycle fraction [1/1000?]
>>> (instead of time in ns) as parameters.
>>> Then  ns (rounded by pwm) to freq. conversion problem
>>> inclk_pwm_recalc_rate() usingpwm_get_period()
>>> could be avoided.
>>> To extend the API pwm_config() can support
>>> new flags forduty_ns and period_ns,
>>> eg. PWM_DUTY_PERCENT and PWM_PERIOD_HZ.
>> Is that rounding really a problem? Also the PWM chips will most likely
>> use the concept of period and duty-cycle internally anyway, so it will
>> convert back from Hz/percentage to nanoseconds and fall victim to
>> similar rounding effects.
>>
>> Thierry
>

