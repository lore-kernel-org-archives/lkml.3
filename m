Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388AbaFERzR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:55:17 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:61581 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaFERzP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:55:15 -0400
X-AuditID: cbfec37a-b7f206d000005572-7c-5390af018f40
Message-id: <5390AEF8.6050908@samsung.com>
Date: Thu, 05 Jun 2014 11:55:04 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.14 000/228] 3.14.6-stable review
References: <20140604232347.966798903@linuxfoundation.org>
In-reply-to: <20140604232347.966798903@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.6]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9hP13G9ROCDX5OsrGYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGZNnbGQsOMlWse9acAPjbNYuRk4OCQETic2PJzBB2GISF+6tZ+ti
	5OIQEljGKLF0UQuU08sk0bRgAxOEs4FR4vakJnaQFl4BLYktX94ygtgsAqoSz2euBxvLJqAu
	8fn1DrAaIQE5iaYlq5m7GDk4RAUiJB5fEIJoFZT4MfkeC4gtIhAssfbrQkaQ+cwCqxglrl9e
	zgaSEBYwk3j35gUrxBwric1fV4E1cApYS1ya1AlWwwxU86hlHTOELS+xec1bZoh6ZYk/l09B
	vaYg8ehqK/sERpFZSHbPQtI+C0n7AkbmVYxipcXJBcVJ6akVhnrFibnFpXnpesn5uZsYIZFU
	tYPxzlebQ4wCHIxKPLwB/ROChVgTy4orcw8xSnAwK4nw8qwACvGmJFZWpRblxxeV5qQWH2Jk
	4uCUamC0PqSx2PHXpulK9wuvLfttOl28sX/rrTxjb+b4mLrCWXIr33abC5kn9+Up7nHIvrHt
	j/LZa/s6vcuFPN94pZ/78Lgm9dg0XhUrvfbAP5kPNp9gi7fm0dHqsNvObH9II3GDala3Q0wf
	28T4zsR/lin1Ztq7nENt/ROqHwhfMbVkq6xu7SqZqcRSnJFoqMVcVJwIAGxBsoyCAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 05:20 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.6 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Jun  6 23:23:11 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.6-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my test system with no dmesg regressions.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
