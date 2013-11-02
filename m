Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3KBVbC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 17:31:02 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:50264 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab3KBVbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 17:31:00 -0400
X-AuditID: cbfec37c-b7fd86d00000670b-47-52756f13b318
Message-id: <52756F11.8010401@samsung.com>
Date: Sat, 02 Nov 2013 15:30:57 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.11 00/66] 3.11.7-stable review
References: <20131101220634.605745564@linuxfoundation.org>
In-reply-to: <20131101220634.605745564@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hP13h/NIgg7lv+SzmrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mp49HQha8F9zorbD96xNTCeZu9i5OSQEDCRODK3H8oWk7hwbz1bFyMXh5DAMkaJnkML
	WCGcXiaJR6eWsYFUCQlsYpR4fDILxOYV0JK4cngLI4jNIqAqcXPDblYQm01AXeLz6x3sEPVy
	Ek1LVjOD2KICERJHVz9jhegVlPgx+R4LiC0iECyx9utCRpBlzAIrGCWOv3wJtkwY6LyDV1ZB
	LbaSmHG8AWwop4C1xL77s8GGMguYSTxqWQdly0tsXvOWGaJeWeLP5VNMXYwcQK8pSmxfbTWB
	UWQWktWzkHTPQtK9gJF5FaNYaXFyQXFSemqFsV5xYm5xaV66XnJ+7iZGSMzU7GC899XmEKMA
	B6MSD68Hf0mQEGtiWXFl7iFGCQ5mJRFeOb/SICHelMTKqtSi/Pii0pzU4kOMTBycUg2MzPe5
	66480H62YiGHodi3v27MrzT3MXZsTfl4/V3V3gshM5sedfQ8VWJ4rHv6OmfV/J8TuiIOv/64
	tl1AIenGlfOabNWtM2zbD9zqUZ2wKqiYzeHRhWOrp2k/b/V5/yBsQhpn5d+nD5xNXyQlFolq
	iJc9yZU8ut+m8UZIZMu/3Oxsme6nBno/lViKMxINtZiLihMBsZ6m1HcCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 04:06 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.11.7 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Nov  3 22:04:49 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.11.7-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Release 3.11.7	

Patch applied cleanly	yes
Compile test		passed
Boot test		passed
dmesg regression test	passed
Cross-compile test	passed

Architecture 	Config 		3.11.7
alpha 		defconfig 	Passed
arm 		defconfig 	Passed
arm64 		defconfig 	Passed
blackfin 	defconfig 	Passed
c6x 		defconfig 	Passed
mips 		defconfig 	Passed
mipsel 		defconfig 	Passed
powerpc 	wii_defconfig 	Passed
sh 		defconfig 	Passed
sparc 		defconfig 	Passed
tile 		defconfig 	Passed

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
