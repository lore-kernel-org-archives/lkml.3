Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbaBTAFF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:05:05 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:43424 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaBTAFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:05:01 -0500
X-AuditID: cbfec37d-b7ff46d000005528-03-530546ac1bd0
Message-id: <530546AA.6040505@samsung.com>
Date: Wed, 19 Feb 2014 17:04:58 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.12 00/32] 3.12.12-stable review
References: <20140218224500.101465031@linuxfoundation.org>
In-reply-to: <20140218224500.101465031@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.5]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hP901bqzBButWq1vMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJWxbPphpoJm9opX+w+wNDCeYu1i5OSQEDCRWHx3FxuELSZx4d56MFtIYBmjRP9CmS5G
	LiC7l0li7eSNTBDOBkaJe3vmM4FU8QpoSdy9+YQdxGYRUJXoWN8FFmcTUJf4/HoHO8QkOYmm
	JauZQWxRgQiJV2cnskD0Ckr8mHwPzBYRCJZY+3UhI8gCZoHDjBLn9l8DO09YwFRi+7Q3jBCD
	rCRe/5oFZnMKWEv0X9wINpQZyF45aRsjhC0vsXnNW2aIemWJP5dPMUG8piBxY+Ey1gmMIrOQ
	7J6FpH0WkvYFjMyrGMVKi5MLipPSUytM9IoTc4tL89L1kvNzNzFCoqZ2B+P9rzaHGAU4GJV4
	eCOuswQLsSaWFVfmHmKU4GBWEuGNZmMNFuJNSaysSi3Kjy8qzUktPsTIxMEp1cA4k192yQFP
	31/BCVuf8Z3L0GGf+js7lWfBkrTD/WaicT4T9Fbcypio/PLJ1ZT5cxz37X507dv3ryzMc8Tc
	nltoXL0wwSBeVXj+5TO8NwROxl7X2r9oya3vB1psgzYcj59QNv/9AcnuXH6enu0X4o9deOxq
	biTU6jA1aNeXOjO9jLk2av2W3vfUlFiKMxINtZiLihMB4Fu343gCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 03:47 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.12 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Feb 20 22:44:47 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.12-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compile tests and boot tests passed. No dmesg regressions: emerg, crit, 
alert, err are clean. No regressions in warn.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
