Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216AbaCNLWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 07:22:03 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:36254 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbaCNLWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 07:22:00 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-f5-5322e65458ef
Message-id: <5322E653.90107@samsung.com>
Date: Fri, 14 Mar 2014 12:21:55 +0100
From: Robert Baldyga <r.baldyga@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Mark Brown <broonie@kernel.org>, Lee Jones <lee.jones@linaro.org>
Cc: Chanwoo Choi <cw00.choi@samsung.com>, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, dmitry.torokhov@gmail.com,
        cooloney@gmail.com, rpurdie@rpsys.net, dbaryshkov@gmail.com,
        dwmw2@infradead.org, lgirdwood@gmail.com, a.zummo@towertech.it,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        rtc-linux@googlegroups.com, m.szyprowski@samsung.com,
        k.kozlowski@samsung.com
Subject: Re: [PATCH v3 4/4] mfd: max8997: move regmap handling to function
 drivers
References: <1394703532-494-1-git-send-email-r.baldyga@samsung.com>
 <1394703532-494-5-git-send-email-r.baldyga@samsung.com>
 <532191E6.6080108@samsung.com> <20140313125504.GA10356@lee--X1>
 <20140313140901.GW366@sirena.org.uk>
In-reply-to: <20140313140901.GW366@sirena.org.uk>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprKIsWRmVeSWpSXmKPExsVy+t/xa7ohz5SCDd4e1LVYcvEqu8XUh0/Y
	LI7unMhkcf3Lc1aLSU/eM1scXvSC0WLiysnMFq9fGFrc/3qU0eLblQ4mi5ufvrFaXN41h81i
	65t1jBZrj9xlt7jduILN4tre48wWu3c9ZbXY39nBaHG6m9VB2GPnrLvsHnsmnmTz2LxCy2PT
	qk42jzvX9rB5zDsZ6LFn/g9Wj74tqxg9ps/7yeTxeZOcx/otW5kCuKO4bFJSczLLUov07RK4
	Mub//sde8IW9YsXlh8wNjPPZuhg5OSQETCSaN3SxQ9hiEhfurQeKc3EICSxllPh44xYrSEJI
	4COjxOV2LhCbV0BD4vqmX2ANLAKqEvMur2ABsdkEdCS2fJ/ACGKLCkRIzJ24mQ2iXlDix+R7
	YDUiAq4St04eZwFZwCxwkFniV88CsCJhgRCJTWsWsUNsfsYoseLDNLDNnAKGEm8fvAIrYhZQ
	l5g0bxEzhC0vsXnNW+YJjAKzkCyZhaRsFpKyBYzMqxhFU0uTC4qT0nON9IoTc4tL89L1kvNz
	NzFCovLrDsalx6wOMQpwMCrx8M44qhgsxJpYVlyZe4hRgoNZSYT35GOlYCHelMTKqtSi/Pii
	0pzU4kOMTBycUg2MgX+D38rvWGEiJCgk9Ta2+Puv5VZ3dmx7mVxYu+jh9wyRtD2Wm87vO+gQ
	o3agSH/DjLq75p2VZ/dyZj990+rFxeSQxFTYdyH5mlpl8oYl3pNmfi0Sf+xmcneO1ZEp7scZ
	/r09+WcV38ld12UvnFhzS/vEqfuTtp1MZA9aumGRLofskW0vVDsWzlJiKc5INNRiLipOBAB8
	VqTzqAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/13/2014 03:09 PM, Mark Brown wrote:
> On Thu, Mar 13, 2014 at 12:55:04PM +0000, Lee Jones wrote:
>>> Is it necessary? If previous mfd driver has various i2c line, previous mfd driver
>>> initialize regmap/i2c setting on mfd driver.
>>> I'm not sure that regmap/i2c setting code move from mfd driver to each driver.
>>>
>>> Dear Lee Jones,
>>> I need your opinion about moving regmap/i2c code from mfd driver to each driver.
> 
>> I'd rather take advice from Mark on this one.
> 
> I don't really case that much; I'm having a hard time seeing it as
> particularly useful to do the refactoring but if it makes people
> happy...  Keeping things in the core would help promote reusability I
> guess but I'm not sure that's likely to actually happen with this sort
> of driver/device.
> 

If you think it's not needed, you can ignore this patch. I prepared it
due to Dmitry Torokhov suggestion. If you think it's useless it doesn't
make me unhappy :)

Best regards
Robert Baldyga
