Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab3JSDkE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 23:40:04 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:10356 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755417Ab3JSDkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 23:40:02 -0400
X-AuditID: cbfec37c-b7fd86d00000670b-1b-5261ff1029b0
Message-id: <5261FF07.7010604@samsung.com>
Date: Fri, 18 Oct 2013 21:39:51 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 0/7] 3.0.101-stable review
References: <20131018195036.020644622@linuxfoundation.org>
In-reply-to: <20131018195036.020644622@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9hP12B/4lBBp3tMhZz1q9hs2hevJ7N
	4vKuOWwWX386WCzY+IjR4lHfW3YHNo+ds+6ye5yY8ZvFY//cNewenzfJBbBEcdmkpOZklqUW
	6dslcGXcefuLseAGf0VbVyt7A+Ncni5GTg4JAROJpl3zmCBsMYkL99azdTFycQgJLGOU+Hv8
	NyOE08sksbrnJTOEs5FRYsbkhSwgLbwCWhId9z+D2SwCqhJbD51kBbHZBNQlPr/ewQ5iCwnI
	STQtWc0MYosKREisXPKAFaJXUOLH5HtgvSICxhL9Z2eB1TMLHGOUWNhsAmILC2hKrLi6DKiG
	A2iOlcTPZSkgYU4Ba4nfdzYyQ5RbS6yctI0RwpaX2LzmLTPEWmWJP5dPMYG0SggoSmxfbTWB
	UWQWksWzkHTPQtK9gJF5FaNYaXFyQXFSemqFsV5xYm5xaV66XnJ+7iZGSMTU7GC899XmEKMA
	B6MSD+/HR4lBQqyJZcWVuYcYJTiYlUR4ay4ChXhTEiurUovy44tKc1KLDzEycXBKNTAK1N0o
	LZALDRX/8u6ArZrqgr8GujamB1Z35cwJ+J61MfLs4ZTz7Mes/nVfaq765S9zoPCDrd7/x+uc
	5ap6uJSWqMjk+bB9iDc6n7+l++JBce6v7x+nNJ1yuHL20Nm5b5lcfz49ne82NffiOuZpApmf
	QyTZJn0//5R9nsijK3lbwq8t9cyaNPGrEktxRqKhFnNRcSIA1kENTnYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/18/2013 01:52 PM, Greg Kroah-Hartman wrote:
> NOTE:
>    This is the LAST 3.0.x stable kernel release that I will be doing.
>    After this release, 3.0.x is End-Of-Life, please move to the 3.10.x,
>    or if you must, 3.4.x series.  For more information about longterm
>    stable releases and how long they will be maintained, please see
>    https://www.kernel.org/category/releases.html
>
> This is the start of the stable review cycle for the 3.0.101 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Oct 20 19:50:26 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.101-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------

Patch applied cleanly 	 yes
Compile testing          passed
Boot testing 	         passed
dmesg regression testing passed
Cross-compile testing    passed

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions
in warn.

Test systems

     Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
     HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
     HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2 (cross-compile 
testing)

alpha 	defconfig 	Passed
arm 	defconfig 	not applicable
arm64 	defconfig 	Not applicable
blackfin defconfig 	Passed
c6x 	defconfig 	Not applicable
mips 	defconfig 	Passed
mipsel 	defconfig 	Passed
powerpc wii_defconfig	Passed
sh 	defconfig 	Passed
sparc 	defconfig 	Passed
tile 	tilegx_defconfig Passed 	

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
