Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136Ab3IFWXX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 18:23:23 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:48627 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752585Ab3IFWXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 18:23:20 -0400
X-AuditID: cbfec37c-b7fd86d00000670b-9d-522a55d732d2
Message-id: <522A55D4.4000608@samsung.com>
Date: Fri, 06 Sep 2013 16:23:16 -0600
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
Subject: Re: [ 00/14] 3.4.61-stable review
References: <20130905202614.354156084@linuxfoundation.org>
 <522A1515.8090300@samsung.com> <20130906184606.GB5274@kroah.com>
In-reply-to: <20130906184606.GB5274@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9hX93roVpBBlevS1nMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJUx+9YnloLjEhUPDt1kbmDcKdzFyMEhIWAisXNebBcjJ5ApJnHh3nq2LkYuDiGBZYwS
	mxq3MkI4vUwSb5v2sEI4GxklHt5fzAbSwiugJTFt2S9mEJtFQFVi7d9OMJtNQF3i8+sd7CC2
	kICcRNOS1WBxUYEIiZVLHrBC9ApK/Jh8jwXEFhEwlug/O4sdZAGzwDFGie2TD4EtEAZa8Prt
	TDaQU4UEaiU+/9ACCXMK6Ek8u/6eEcRmFrCWWDlpG5QtL7F5zVtmiL3KEn8un2KC+FJRYvtq
	qwmMIrOQbJ6FpHsWku4FjMyrGMVKi5MLipPSUyuM9YoTc4tL89L1kvNzNzFCIqZmB+O9rzaH
	GAU4GJV4eG/c0AwSYk0sK67MPcQowcGsJMJ7hkErSIg3JbGyKrUoP76oNCe1+BAjEwenVANj
	6cSI25Knf4h/v5Cks+5CxlyNpJRaPW/Jqrh7puWvpCN6eVv4fj/4FraZ0/rvVjHzPSkH/kax
	L4lbVT1HccLyae8YbbjX7N7ix1d8a33Ciq8Xvq+vjmnscq384/Ju8QnjkyW9k59ILOVkN+BT
	PjWn4tKHJYeFa98LrWmvNq4L+3/igYyY+mQ3JZbijERDLeai4kQANXpOy3YCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2013 12:46 PM, Greg Kroah-Hartman wrote:
> On Fri, Sep 06, 2013 at 11:47:01AM -0600, Shuah Khan wrote:
>> On 09/05/2013 02:28 PM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 3.4.61 release.
>>> There are 14 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat Sep  7 20:25:41 UTC 2013.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.61-rc1.gz
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>> -------------
>>
>>
>> 3.4.61-rc1 applied cleanly to 3.4.60
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
>> 3.4.60 compile fail - it is not a regression. Existing issue in
>> 3.4.y It has to do with missing config selections in
>> arch/arm/mach-exynos/Kconfig for this system. Debugging now using
>> the Kconfig selections from 3.10.y for this file.
>
> Is there a patch I can backport for this to work properly?  I'd like to
> get some type of ARM coverage if possible.
>
> thanks,
>
> greg k-h
>

Greg,

I did some debugging and found 3.4 needs several patches to that made 
exynos4 support common for exynos4 and exynos5. It appears some changes 
made it into 3.4, at least changing the directory name from mach-exynos4 
to mach-exynos, however the rest of the support is not in 3.4. I 
identified the following commits:

6f9e95e6ed34ceff090ec1a1d27dfc85828d1dbd
60e49ca654eea42e04912b259fa36bad2c3e56ef
20ef9e08d27b3f5e09c32d4d371fa97f610a3069
b1b3f49ce4606452279b58b17f2bbe2ba00304b

Essentially every single commit that adds support for these config options:

diff --git a/arch/arm/mach-exynos/Kconfig b/arch/arm/mach-exynos/Kconfig
index b8df521..3be8f7c 100644
--- a/arch/arm/mach-exynos/Kconfig
+++ b/arch/arm/mach-exynos/Kconfig
@@ -61,6 +61,11 @@ config SOC_EXYNOS5250
         bool "SAMSUNG EXYNOS5250"
         default y
         depends on ARCH_EXYNOS5
+       select PM_GENERIC_DOMAINS if PM
+       select S5P_PM if PM
+        select S5P_SLEEP if PM
+        select S5P_DEV_MFC
+       select SAMSUNG_DMADEV
         help
           Enable EXYNOS5250 SoC support

I am guessing you wouldn't want to make such extensive changes to 3.4 to 
add full support for Chromebook.

3.10.y has full support for all of the above.

Thoughts. Agree with my assessment?

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
