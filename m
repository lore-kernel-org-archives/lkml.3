Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754704Ab3KBVcF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Nov 2013 17:32:05 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:50275 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754487Ab3KBVcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Nov 2013 17:32:02 -0400
X-AuditID: cbfec37b-b7fa96d00000716e-92-52756f5222d3
Message-id: <52756F50.5070700@samsung.com>
Date: Sat, 02 Nov 2013 15:32:00 -0600
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
Subject: Re: [PATCH 3.10 00/54] 3.10.18-stable review
References: <20131101220211.311926234@linuxfoundation.org>
In-reply-to: <20131101220211.311926234@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hP92g/NIgg75/IhZz1q9hs2hevJ7N
	4vKuOWwWX386WCzY+IjR4lHfW3YHNo+ds+6ye5yY8ZvFY//cNewenzfJBbBEcdmkpOZklqUW
	6dslcGX82f2BteAfV8XWf7vYGhhPc3QxcnJICJhIXOpexwhhi0lcuLeerYuRi0NIYBmjxLIN
	txghnF4miSuf/rJDOJsYJU5OeArWwiugJbHh/hYWEJtFQFViysFVTCA2m4C6xOfXO9hBbCEB
	OYmmJauZQWxRgQiJo6ufsUL0Ckr8mHwPrFdEIFhi7deFYNuYBVYwShx/+ZINJCEsYCrx8P0L
	JohBVhKvD94HauDg4BSwluheoA0SZhYwk3jUso4ZwpaX2LzmLTNEubLEn8unmEDKJQQUJbav
	tprAKDILyeZZSLpnIelewMi8ilGstDi5oDgpPbXCSK84Mbe4NC9dLzk/dxMjJGaqdzDe/Wpz
	iFGAg1GJh9eDvyRIiDWxrLgy9xCjBAezkgivnF9pkBBvSmJlVWpRfnxRaU5q8SFGJg5OqQZG
	Tk27nFNee/odbi6rfpN77KfQ3/7fVerZntMaORhyuiLOKn5YWScgELJtwbH6shQ70dTdLjob
	i6a5bWS8tNU8feosZSPXrsUCZ448FMlweyW28dBpE631W2SE1KuvWTJIqhjwLy0IjBbwPe47
	6dC6JoN87pU2FXoBjZrMlx4YK6cqTPf3EFRiKc5INNRiLipOBABK/tYPdwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/01/2013 04:03 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.18 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Nov  3 22:00:53 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.18-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Release 3.10.18	

Patch applied cleanly	yes
Compile test		passed
Boot test		passed
dmesg regression test	passed
Cross-compile test	passed

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

Architecture 	Config 		3.10.18
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
