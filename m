Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118Ab3IFXYK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 19:24:10 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:8832 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750726Ab3IFXYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 19:24:07 -0400
X-AuditID: cbfec37b-b7fa96d00000716e-6a-522a641493bd
Message-id: <522A6412.5070701@samsung.com>
Date: Fri, 06 Sep 2013 17:24:02 -0600
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
 <522A55D4.4000608@samsung.com> <20130906231159.GA7394@kroah.com>
In-reply-to: <20130906231159.GA7394@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9hX13RFK0gg9/VFnPWr2GzaF68ns3i
	8q45bBZffzpYLNj4iNHiUd9bdgc2j52z7rJ7nJjxm8Vj/9w17B6fN8kFsERx2aSk5mSWpRbp
	2yVwZTy6fYC1YJ14xcXZk5gbGN8LdTFyckgImEgce9vPDGGLSVy4t56ti5GLQ0hgGaNE09OF
	jBBOL5PEwaPL2SGcjYwSJzY/YAdp4RXQkjg3+S6QzcHBIqAq0bpAASTMJqAu8fn1DrASIQE5
	iaYlq8E2iApESKxc8oAVolVQ4sfkeywgtoiAsUT/2Vlg85kFjjFKbJ98iA0kIQw0//XbmVAn
	HWCUODalF2wZp4CexPa5jiA1zALWEisnbWOEsOUlNq95ywyxWFniz+VTTCDlEgKKEttXW01g
	FJmFZPUsJN2zkHQvYGRexShWWpxcUJyUnlphpFecmFtcmpeul5yfu4kREjHVOxjvfrU5xCjA
	wajEw2twWzNIiDWxrLgy9xCjBAezkgjvGQatICHelMTKqtSi/Pii0pzU4kOMTBycUg2M9ZIa
	N6U/q6pHLfnzlI1dJPZel8TfX2svXlvKYPaCt3PNnFnPshpm3WW+9zPJTKJy4vGT6/0fSXWs
	Wyi2Y7/zVGXO9epKcsLy+p0nyhc4vvXgsmGfPc93xf7zJayvrkQ+N2CZf/eDrMUj2e49EXnS
	H71XmgY3rP1if/HhITNjlaVT4mTqrrzXUmIpzkg01GIuKk4EAGDaUy12AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/06/2013 05:11 PM, Greg Kroah-Hartman wrote:
> On Fri, Sep 06, 2013 at 04:23:16PM -0600, Shuah Khan wrote:
>> On 09/06/2013 12:46 PM, Greg Kroah-Hartman wrote:
>>> On Fri, Sep 06, 2013 at 11:47:01AM -0600, Shuah Khan wrote:
>>>> On 09/05/2013 02:28 PM, Greg Kroah-Hartman wrote:
>>>>> This is the start of the stable review cycle for the 3.4.61 release.
>>>>> There are 14 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Sat Sep  7 20:25:41 UTC 2013.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>> The whole patch series can be found in one patch at:
>>>>> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.61-rc1.gz
>>>>> and the diffstat can be found below.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>>
>>>>> -------------
>>>>
>>>>
>>>> 3.4.61-rc1 applied cleanly to 3.4.60
>>>>
>>>> Compiled and booted on the following systems:
>>>>
>>>> Samsung Series 9 900X4C Intel Corei5
>>>> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
>>>>
>>>> dmesgs look good. No regressions compared to the previous dmesgs for
>>>> this release. dmesg emerg, crit, alert, err are clean. No
>>>> regressions in warn.
>>>
>>> Thanks for testing and letting me know.
>>>
>>>> Compile tested on Samsung Chromebook Exynos5 (ARMv7):
>>>> 3.4.60 compile fail - it is not a regression. Existing issue in
>>>> 3.4.y It has to do with missing config selections in
>>>> arch/arm/mach-exynos/Kconfig for this system. Debugging now using
>>>> the Kconfig selections from 3.10.y for this file.
>>>
>>> Is there a patch I can backport for this to work properly?  I'd like to
>>> get some type of ARM coverage if possible.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> Greg,
>>
>> I did some debugging and found 3.4 needs several patches to that
>> made exynos4 support common for exynos4 and exynos5. It appears some
>> changes made it into 3.4, at least changing the directory name from
>> mach-exynos4 to mach-exynos, however the rest of the support is not
>> in 3.4. I identified the following commits:
>>
>> 6f9e95e6ed34ceff090ec1a1d27dfc85828d1dbd
>> 60e49ca654eea42e04912b259fa36bad2c3e56ef
>> 20ef9e08d27b3f5e09c32d4d371fa97f610a3069
>
> Those three are "reasonable".

Cool. I will pull just these 3 patches and see if that works and let you 
know if it works.

>
>> b1b3f49ce4606452279b58b17f2bbe2ba00304b
>
> That just reorders the config options, is that really needed?
>
> So, with those first 3 patches, does the kernel now work on that
> platform for you?
>
> thanks,
>
> greg k-h
>

Yes the last one b1b3f49ce4606452279b58b17f2bbe2ba00304b, is a 
reordering patch.

-- Shuah
-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
