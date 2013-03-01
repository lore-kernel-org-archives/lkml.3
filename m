Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750915Ab3CAN2r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 08:28:47 -0500
Received: from eu1sys200aog101.obsmtp.com ([207.126.144.111]:54124 "EHLO
	eu1sys200aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750696Ab3CAN2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 08:28:45 -0500
Message-ID: <5130ACF2.6070005@stericsson.com>
Date: Fri, 1 Mar 2013 14:28:18 +0100
From: Rickard Andersson <rickard.andersson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "john.stultz@linaro.org" <john.stultz@linaro.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "jacob.jun.pan@linux.intel.com" <jacob.jun.pan@linux.intel.com>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "viresh.kumar@linaro.org" <viresh.kumar@linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 3/4] ARM: nomadik: add dynamic irq flag to the timer
References: <1361917047-29230-1-git-send-email-daniel.lezcano@linaro.org>	<1361917047-29230-4-git-send-email-daniel.lezcano@linaro.org>	<CACRpkda=i5cXSbYCyb0gH0OLKj7396qguup1nqgqn0m-S1x1wg@mail.gmail.com> <CAKfTPtA=7pTPrwFHr61WiffXGv2Ztmaiji5q_vJpPj9XgyeZMg@mail.gmail.com>
In-Reply-To: <CAKfTPtA=7pTPrwFHr61WiffXGv2Ztmaiji5q_vJpPj9XgyeZMg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/01/2013 09:56 AM, Vincent Guittot wrote:
> On 1 March 2013 02:13, Linus Walleij<linus.walleij@linaro.org>  wrote:
>> On Tue, Feb 26, 2013 at 11:17 PM, Daniel Lezcano
>> <daniel.lezcano@linaro.org>  wrote:
>>
>>> Add the dynamic irq affinity feature to the timer clock device.
>>>
>>> Signed-off-by: Daniel Lezcano<daniel.lezcano@linaro.org>
>> Looks reasonable to me, sadly I do not fully grasp the patch set,
>> Vincent+Rickard can you have a look at this?
> ux500 is able to trig the wake up on one CPU and let the other one in
> WFI. This patch will minimize the spurious wake up of CPU0 when CPU1
> is the target CPU of the broadcast timer. One main consequence is that
> we will not uselessly execute all the deferrable and newly idle
> activities on the CPU0 .
>
> you can add my reviewed-by if you want
>
> Vincent
>
It looks ok to me as well.

BR
Rickard
