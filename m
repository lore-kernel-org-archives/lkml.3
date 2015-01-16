Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374AbbAPADM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 19:03:12 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:25713 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbbAPADJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 19:03:09 -0500
X-AuditID: cbfee691-f79b86d000004a5a-01-54b855391de9
Message-id: <54B85539.7090908@samsung.com>
Date: Fri, 16 Jan 2015 09:03:05 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
Cc: Chanwoo Choi <cwchoi00@gmail.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "inki.dae@samsung.com" <inki.dae@samsung.com>,
        Kukjin Kim <kgene@kernel.org>, Olof Johansson <olof@lixom.net>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RESEND PATCH v3] clocksource: exynos_mct: Add the support for
 Exynos 64bit SoC
References: <1421213603-5020-1-git-send-email-cw00.choi@samsung.com>
 <54B69072.4080607@kernel.org> <54B692FB.7030703@linaro.org>
 <54B7024C.4020407@samsung.com> <20150115112938.GB16217@leverpostej>
 <CAGTfZH0Ve+icxc6FpMJhfNMRMqQASrcUmnrZw-6sYQz8rabC_A@mail.gmail.com>
 <CAGTfZH0SQRyTMTmge6x2fXFBdVwtgJ_wcxK36mFrf6ZNPBn85w@mail.gmail.com>
 <20150115133404.GF16217@leverpostej>
In-reply-to: <20150115133404.GF16217@leverpostej>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCIsWRmVeSWpSXmKPExsWyRsSkUNcydEeIwe1dWhbPjmpbzPssa3F2
	2UE2i0n3J7BY9C64ymbR//g1s8Wmx9dYLS7vmsNmMeP8PiaLpdcvMlmcuv6ZzWLzpqnMDjwe
	a+atYfSY3XCRxWPnrLvsHptWdbJ53Lm2h83j3blz7B6bl9R7XDnRxOrRt2UVo8fnTXIBXFFc
	NimpOZllqUX6dglcGWfXTGQpOChX0XJvDXsD43mJLkYODgkBE4n7lzS6GDmBTDGJC/fWs3Ux
	cnEICSxllLjyegYzRMJE4vHCR1CJ6YwSrT/amSCc14wSC2bfA6viFdCSmLG4jxXEZhFQleh8
	9JEdxGYDiu9/cYMNxBYVCJNYOf0KC0S9oMSPyffAbBEBdYmeXV9YQIYyC8xlkejZNw2sWVgg
	TuL3kc0sENv+Mkn8WvsFbBKngKHEpyX7wbYxC+hI7G+dxgZhy0tsXvOWGaRBQmAih8T+OTuY
	IU4SkPg2+RALxNOyEpsOQP0mKXFwxQ2WCYxis5AcNQvJ2FlIxi5gZF7FKJpakFxQnJReZKpX
	nJhbXJqXrpecn7uJERjZp/89m7iD8f4B60OMAhyMSjy8jH7bQ4RYE8uKK3MPMZoCXTGRWUo0
	OR+YPvJK4g2NzYwsTE1MjY3MLc2UxHl1pH8GCwmkJ5akZqemFqQWxReV5qQWH2Jk4uCUamBs
	c3Rc8sGgaItfeP3B+cmzpm7l5VnlXqmec54vY0Vmn3G1cURP/M4/ngKav0Wq0mY0vgrJ4xXN
	jcnIMd9roPHvV3RVxeF8/vNBX/yzVp75Ga1R+dFhu7/a9bpdE33CDRYrXeRf2La1xuuSXfP3
	6GAJzbvs/LznnDbycxyVm/v729Ti/Qw3tyixFGckGmoxFxUnAgCDldp95wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPKsWRmVeSWpSXmKPExsVy+t9jQV3L0B0hBusXKlo8O6ptMe+zrMXZ
	ZQfZLCbdn8Bi0bvgKptF/+PXzBabHl9jtbi8aw6bxYzz+5gsll6/yGRx6vpnNovNm6YyO/B4
	rJm3htFjdsNFFo+ds+6ye2xa1cnmcefaHjaPd+fOsXtsXlLvceVEE6tH35ZVjB6fN8kFcEU1
	MNpkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXmAJ2tpFCW
	mFMKFApILC5W0rfDNCE0xE3XAqYxQtc3JAiux8gADSSsYcw4u2YiS8FBuYqWe2vYGxjPS3Qx
	cnJICJhIPF74iA3CFpO4cG89kM3FISQwnVGi9Uc7E4TzmlFiwex7zCBVvAJaEjMW97GC2CwC
	qhKdjz6yg9hsQPH9L26ATRIVCJNYOf0KC0S9oMSPyffAbBEBdYmeXV9YQIYyC8xlkejZNw2s
	WVggTuL3kc0sENv+Mkn8WvsFbBKngKHEpyX7wbYxC+hI7G+dxgZhy0tsXvOWeQKjwCwkS2Yh
	KZuFpGwBI/MqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjODE8UxqB+PKBotDjAIcjEo8vAx+
	20OEWBPLiitzDzFKcDArifDyMu8IEeJNSaysSi3Kjy8qzUktPsRoCgyDicxSosn5wKSWVxJv
	aGxiZmRpZG5oYWRsriTOq2TfFiIkkJ5YkpqdmlqQWgTTx8TBKdXAmBRaZegZlqJ1cfKP18ud
	d5/paQ/cX3H6o/S+0tcrf+41/nH6q8BK1dN8MWsl6k+pBZx7vySrMPsZ48nYjfnHJqz5+fnM
	QmPz5NM2Qru3PLnuEvFTM2imT0+08uyFPq6nwpv/KbqW3Hj+SPjB/7KkuMjZCSoF/BHzKtcW
	vPrYGcVzq/PLy2AhdyWW4oxEQy3mouJEAIXMexgyAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2015 10:34 PM, Mark Rutland wrote:
> On Thu, Jan 15, 2015 at 12:52:38PM +0000, Chanwoo Choi wrote:
>> On Thu, Jan 15, 2015 at 9:46 PM, Chanwoo Choi <cwchoi00@gmail.com> wrote:
>>> Hi Mark,
>>>
>>> On Thu, Jan 15, 2015 at 8:29 PM, Mark Rutland <mark.rutland@arm.com> wrote:
>>>> On Wed, Jan 14, 2015 at 11:57:00PM +0000, Chanwoo Choi wrote:
>>>>> Hi Kukjin,
>>>>>
>>>>> On 01/15/2015 01:02 AM, Daniel Lezcano wrote:
>>>>>> On 01/14/2015 04:51 PM, Kukjin Kim wrote:
>>>>>>> On 01/14/15 14:33, Chanwoo Choi wrote:
>>>>>>>
>>>>>>> Hi,
>>>>>>>
>>>>>>> + Doug, Olof
>>>>>>>
>>>>>>>> This patch adds the support for Exynos 64bit SoC. The delay_timer is only used
>>>>>>>> for Exynos 32bit SoC.
>>>>>>>>
>>>>>>> Yes, the Exynos MCT(Multi-Core Timer) is 64bit timer and it is available
>>>>>>> on 64bit exynos SoC such as exynos7. But basically ARMv8 architecture is
>>>>>>> including ARM ARCH timer (ARM Generic Timer) and exynos7 also has
>>>>>>> implemented it and additionally its access is faster than using memory
>>>>>>> mapped register called SFR for MCT...so Doug submitted patch to use MCT
>>>>>>> on 32bit exynos SoCs before.
>>>>>
>>>>> I know arch_timer. As you comment, ARCH timer would be used for system timer for ARMv8.
>>>>> But, Exynos5433/Exynos7 (ARMv8) include MCT (Multi-Core Timer) IP. I checked it on
>>>>> Exynos5433/EXynos7 User-manaual and tested it.
>>>>>
>>>>> I think that exynos_mct.c should support the Exynos 64-bit SoC
>>>>> because Exynos5433/Exynos7 include already MCT (Multi-Core Timer) IP.
>>>>>
>>>>> Also, I have a problem to verify ARCH timer on Exynos SoC. Exynos User-manual never includes
>>>>> the detailed information about for ARCH timer(e.g, clock for ARCH timer). I knew that
>>>>> I can get the document of ARCH timer for ARM official site but I think it is insufficient
>>>>> to implement ARCH timer on Exynos SoC.
>>>>
>>>> What do you mean by "insufficient to implement ARCH timer"?
>>>
>>> As I knew, timer must need the source clock. The clock for ARCH timer
>>> has dependency on Exynos SoC, But I cannot find
>>
>> I'm so sorry about this mistake. I pressed the send button before
>> completing reply.
>>
>> As I knew, timer must need the source clock. The clock for ARCH timer
>> has dependency on Exynos SoC, But I cannot find the clock information
>> for ARCH timer on Exynos SoC user-manual.
>>
>> When I tried to use ARCH timer on Exynos3250, It is not working. We
>> can check this ARCH timer issue of Exynos3250
>> on following patch[1]:
>> [1] http://www.spinics.net/lists/arm-kernel/msg322943.html
> 
> Hmm. That is annoying. Your boot code should have been initialising this
> already.

Right, 
I want to resolve the issue for Exynos3250 but I don't have any information.
Maybe this issue should be fixed by the architector of Exynos SoC or any samsung
developer who can contact the information of ARCH timer.

> 
>>>> The architected timer is mandatory in ARMv8, and required by the arm64
>>>> kernel.
>>>>
>>>> Additional timers may be requried if you want to put all CPUs into low
>>>> power states where the timer logic may be disabled and/or lose state,
>>>> but regardless the architected timers are necessary.
>>
>> I agree that ARCH timer is mandatory.
>>
>> I just think that existing exynos-mct.c driver should support the Exynos5/7 SoC
>> because released Exynos5/7 SoC includes already MCT IP for system timer.
> 
> I'm not opposed to the MCT. My only concern is that a configured and
> enabled architected timer is mandated by the boot protocol, and is a
> prerequisite for a functioning kernel. 

Thanks for your opinion.
As I replyed on previous mail, I agree that ARCH timer is necessary.

Your initial response made it
> sound like you expected the MCT alone to be sufficient.

I didn't mean it.

Best Regards,
Chanwoo Choi


