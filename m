Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaAGWAZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 17:00:25 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:36722 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbaAGWAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 17:00:17 -0500
X-AuditID: cbfec37a-b7ef66d000004f2b-d9-52cc78f0f5f6
Message-id: <52CC78EC.3000806@samsung.com>
Date: Tue, 07 Jan 2014 15:00:12 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.12 000/144] 3.12.7-stable review
References: <20140106223745.326293132@linuxfoundation.org>
 <52CC5062.3080708@samsung.com> <20140107191639.GA2825@kroah.com>
In-reply-to: <20140107191639.GA2825@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9hX90PFWeCDC4u5bCYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugStj0uHAgm7eijVTJzA1MK7m6mLk5JAQMJFoejeHEcIWk7hwbz1bFyMXh5DAMkaJ5k/T
	WCCcXiaJjxc2MINUCQlsZJT4+KICxOYV0JK48WIqWDeLgKrEnsWH2EBsNgF1ic+vd7BD1MtJ
	NC1ZDdYrKhAh8ersRBaIXkGJH5PvgdkiAsYS/WdnsYMsYxY4xiixfTLEIGEBM4mGhX9ZIAbV
	SrzZ0gY2iFNAT6Ln8zOwOLOAtcTKSdsYIWx5ic1r3kIdqizx5/Ippi5GDqDXFCW2r7aawCgy
	C8nqWUi6ZyHpXsDIvIpRrLQ4uaA4KT21wlCvODG3uDQvXS85P3cTIyRiqnYw3vlqc4hRgINR
	iYf3htqZICHWxLLiytxDjBIczEoivIklQCHelMTKqtSi/Pii0pzU4kOMTBycUg2MSefT1ZjP
	aBk4l7uztSzfE5f5b07Poki39qkbzi/b5KG19VLTx6Izsk4TsueXyd+YbqX9drdDT+zV7Vc+
	WDWntzDIXv7f9XXZqeZgXfe86vuBc+ftenidZ/Uhr2NGZvc1BS3c2lQMN/7ffvSvbVbWnUN3
	PbM1CvV9FH8fSYsMCV90xY370dm5SizFGYmGWsxFxYkA+rFIxHYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2014 12:16 PM, Greg Kroah-Hartman wrote:
> On Tue, Jan 07, 2014 at 12:07:14PM -0700, Shuah Khan wrote:
>> On 01/06/2014 03:36 PM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 3.12.7 release.
>>> There are 144 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed Jan  8 22:37:25 UTC 2014.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.7-rc1.gz
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> Patches testing - passed
>> Compile testing - passed
>> Boot testing - passed
>> dmesg regression testing - passed
>>
>> Test systems
>>
>>      Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
>>      HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
>>      Dell OptiPlex 790 Intel(R) Core(TM) i5-2400
>>
>> Detailed test status
>>
>> Patches applied cleanly
>> dmesgs look good. No regressions compared to the previous dmesgs for this
>> release. dmesg emerg, crit, alert, err are clean. No regressions in warn.
>
> Just in time for me to do a -rc2 release for this, and the 3.10 -rc1
> announcement, sorry :)
>

3.10.26-rc2 and 3.12.7-rc2 are looking good on all my 3 test systems. No 
dmesg regressions.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
