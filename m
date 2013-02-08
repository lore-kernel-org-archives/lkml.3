Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759596Ab3BHCTw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 21:19:52 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:33546 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab3BHCTt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 21:19:49 -0500
X-AuditID: cbfee61b-b7fb06d000000f28-74-511460c4f878
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 8BIT
Message-id: <511460BE.8010702@samsung.com>
Date: Fri, 08 Feb 2013 11:19:42 +0900
From: jonghwa3.lee@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, a.zummo@towertech.it,
        rtc-linux@googlegroups.com
Subject: Re: [PATCH v2] rtc: max8997: Add driver for max8997 rtc.
References: <1360234887-12360-1-git-send-email-jonghwa3.lee@samsung.com>
 <20130207134401.b4d90982.akpm@linux-foundation.org>
In-reply-to: <20130207134401.b4d90982.akpm@linux-foundation.org>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrEIsWRmVeSWpSXmKPExsVy+t8zLd0jCSKBBueecVtc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6MyS9nsxVc46+Y/fg+WwPjc54uRk4OCQETic3t11ghbDGJC/fW
	s3UxcnEICSxjlJi8oYMZpujh5X4WiMR0RondLxqZQBK8AoISPybfYwGxmQXUJSbNW8QMYYtI
	fOl6CWVrSyxb+JoZormLSeLr5olsEM1aEjN6/4OtZhFQlehb3cAIYrMJyEm8bfoGZHNwiApE
	SPzq5wAJiwjoSqx6vgtqZojEk4UnwMYICzhKXJx3kR3EFhKok3h3uRtsJKeAg8TiCU1geyUE
	utklNm7/BbVLQOLb5EMsIPMlBGQlNh2AelJS4uCKGywTGMVnIXltFpLXZiF5bRaS1xYwsqxi
	FE0tSC4oTkrPNdIrTswtLs1L10vOz93ECIkh6R2MqxosDjEKcDAq8fBqnBUOFGJNLCuuzD3E
	KMHBrCTCG6EuEijEm5JYWZValB9fVJqTWnyIMRno2InMUqLJ+cD4ziuJNzQ2MDY0tDQ0M7U0
	NSBNWEmcl/HUkwAhgfTEktTs1NSC1CKYLUwcnFINjIuTuGRe/C4uPx33hOfbi1SZq3fi3bnN
	ufOilwVMuqPfOv14pGI792cRs7X8x+SfMATvXv/AR6NfINsvbn9UViRfVZ/4scczy2Ybu+fV
	n1iy7MWCijWPGL/sXVO0NOi8bYoV8xK2edzT3j2se/r92mShO9f1VJvKA6UjAw8HXz0lNjeD
	Rcn2nxJLcUaioRZzUXEiAE9dWRHlAgAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrOIsWRmVeSWpSXmKPExsVy+t9jQd0jCSKBBpd3sFlc3jWHzYHR4/Mm
	uQDGqAZGm4zUxJTUIoXUvOT8lMy8dFsl7+B453hTMwNDXUNLC3MlhbzE3FRbJRefAF23zByg
	qUoKZYk5pUChgMTiYiV9O0wTQkPcdC1gGiN0fUOC4HqMDNBAwjrGjOsHmxkLtvFXzN65mbGB
	8ThPFyMnh4SAicTDy/0sELaYxIV769m6GLk4hASmM0rsftHIBJLgFRCU+DH5HlARBwezgLzE
	kUvZIGFmAXWJSfMWMUPUdzFJfN08kQ2iXktiRu9/VhCbRUBVom91AyOIzSYgJ/G26RsjyBxR
	gQiJX/0cIGERAV2JVc93MUPMDJF4svAE2BhhAUeJi/MusoPYQgJ1Eu8ud4ON5BRwkFg8oYl5
	AqPALCTXzUK4bhaS6xYwMq9iFE0tSC4oTkrPNdIrTswtLs1L10vOz93ECI62Z9I7GFc1WBxi
	FOBgVOLh1TgrHCjEmlhWXJl7iFGCg1lJhDdCXSRQiDclsbIqtSg/vqg0J7X4EGMy0G8TmaVE
	k/OBiSCvJN7Q2MTMyNLIzNjE3NiYNGElcV7GU08ChATSE0tSs1NTC1KLYLYwcXBKNTB6GJcd
	qDp+6eWPLdE/gwp/60qacLXP7YpMX/LY8Qr/2p3Hj2hrO00/l+Qzs+IFu2WFXWts/rknYro/
	X079edhU+MHqfI6zHbJRSSuc5xZ93LD23OFXEruTta44x3LVV4s05gYsW33pAvsmYQeXia8D
	lrFJbMrhlHuXULXt1VJ3d59HWzWC96grsRRnJBpqMRcVJwIA9VgqsPoCAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013년 02월 08일 06:44, Andrew Morton wrote:
> On Thu, 07 Feb 2013 20:01:27 +0900
> Jonghwa Lee <jonghwa3.lee@samsung.com> wrote:
> 
>> This patch adds rtc driver for Maxim 8997 multifunction chip.
>> Max8997 has rtc module in it. and it can be used for timekeeping
>> clock and system alarm. It provide various operational mode those are
>> BCD/binary, 24/12hour, am/pm. Driver sets binary/24/ for default.
>> Maxim 8997 also supports SMPL(Sudden Momentary Power Loss), WTSR
>> (Watchdog Timeout and Software Reset).
>>
>> Signed-off-by: Jonghwa Lee <jonghwa3.lee@samsung.com>
>> ---
>> v2
>>  - Add module parameter to enable/disable WTSR, SMPL fuction.
>>  - Add unregister_rtc_device() for accidental exit in probing.
>>
>> ...
>>
>> +/* Module parameter for WTSR function control */
>> +static int wtsr_en = 1;
>> +module_param(wtsr_en, int, 0444);
>> +MODULE_PARM_DESC(wtsr_en, "Wachdog Timeout & Sofware Reset (default=on)");
>> +/* Module parameter for SMPL function control */
>> +static int smpl_en = 1;
>> +module_param(smpl_en, int, 0444);
>> +MODULE_PARM_DESC(smpl_en, "Sudden Momentary Power Loss (default=on)");
> 
> "default=on" is interesting.  For what reasons would a user ever want
> to set this "off"?  Can we just remove the options and leave these
> things enabled all the time for everyone?
>

System with WTSR will be postponed to reset more than 58.6ms(250 ~ 1000ms) even if AP sends
POWERHOLD signal low. (By default(without WTSR) it keeps PMIC on 58.6ms , then re-check the
POWERHOLD signal to determine whether it needs PMIC off)
And with SMPL option enabled, system will be automatically re-boot when power has been recovered
before SMPL's timer is expired.

Those all functions are just optional not significant. And someone may not want to them, so
I think the better idea is leave it selectable. If you don't thinks so, I remove options and
keep it enabled for all.

Thanks,
Jonghwa.

> 
