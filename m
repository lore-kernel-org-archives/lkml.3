Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866Ab3IFSsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 14:48:43 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:30074 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708Ab3IFSsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 14:48:41 -0400
X-AuditID: cbfec37c-b7fd86d00000670b-01-522a23881268
Message-id: <522A2385.9090006@samsung.com>
Date: Fri, 06 Sep 2013 12:48:37 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [ 00/36] 3.10.11-stable review
References: <20130905202702.289738686@linuxfoundation.org>
 <522A12AE.2090600@samsung.com> <20130906184514.GA5274@kroah.com>
In-reply-to: <20130906184514.GA5274@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hP90OZa0gg5ef5SzmrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mq4MVmnYBJfxcTLK5kbGJdydzFyckgImEjsvfKLHcIWk7hwbz1bFyMXh5DAMkaJQxvX
	MkM4vUwSy5q/QDmbGSX2XJ/DBNLCK6AlcaThB5jNIqAqseheExuIzSagLvH59Q6wsUICchJN
	S1Yzg9iiAhESK5c8YIXoFZT4MfkeC4gtImAs0X92FjvIAmaBY4wS2ycfAhskLKAtcavvHDPE
	oFqJ9f82MILYnAJ6Ere+vQNbzCxgLbFy0jZGCFteYvOat1D1yhJ/Lp8CquEA+k1RYvtqqwmM
	IrOQrJ6FpHsWku4FjMyrGMVKi5MLipPSUyuM9YoTc4tL89L1kvNzNzFCYqZmB+O9rzaHGAU4
	GJV4eG/c0AwSYk0sK67MPcQowcGsJMJ7hkErSIg3JbGyKrUoP76oNCe1+BAjEwenVAOju5Do
	TjHJmSoTNme4PbvTa7KGLVVWK7xStdTeZTvjvjn8XHyZCy1TPLKjTDfvbXoTuOOe80L3R6qh
	FT75N56m2t58e0bp4Ub1Kd77XGzjM27N9BHafPdT5Bq+s3Kmya6PN116FKdbGXxoe9HliPyz
	Ysr5vYsFWR9JT/3RZFBx90g3i+8tnttKLMUZiYZazEXFiQAie8BZdwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2013 12:45 PM, Greg Kroah-Hartman wrote:
> On Fri, Sep 06, 2013 at 11:36:46AM -0600, Shuah Khan wrote:
>> On 09/05/2013 02:27 PM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 3.10.11 release.
>>> There are 36 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat Sep  7 20:26:25 UTC 2013.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.11-rc1.gz
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> 3.10.11-rc1 applied cleanly to 3.10.10
>>
>> Compiled and booted on the following systems:
>>
>> Samsung Series 9 900X4C Intel Corei5
>> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
>>
>> dmesgs look good. No regressions compared to the previous dmesgs for
>> this release. dmesg emerg, crit, alert, err are clean. No
>> regressions in warn.
>
> Thanks for testing and letting me know.
>
>> Compile tested on Samsung Chromebook Exynos5 (ARMv7):
>> Note: Hoping to run boot tests on this new test system, but I was
>> able to compile the 3.10.11-rc1 on this system running Ubuntu 13.04
>> so far.
>
> "able", or "unable"?  What's the problem you are getting?
>

Compiled just fine. No issues with compile and installed fine. I am 
figuring out the boot-loader config on this system to be able to boot 
the new image. Will get there soon. :)

-- Shuah
-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
