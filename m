Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086AbaF3QSx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:18:53 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:55868 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbaF3QSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:18:48 -0400
X-AuditID: cbfec37a-b7f206d000005572-52-53b18de78ee0
Message-id: <53B18DE4.3040304@samsung.com>
Date: Mon, 30 Jun 2014 10:18:44 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.15 000/139] 3.15.3-stable review
References: <20140628174605.352098823@linuxfoundation.org>
In-reply-to: <20140628174605.352098823@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.211]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9hP93nvRuDDU5dV7KYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGcsvn2QuOM5WcXzZTpYGxpmsXYycHBICJhL9bzdB2WISF+6tZ+ti
	5OIQEljGKLFg80RWCKeXSeJ152GozDZGiUO7mhlBWngFtCSWzWlmAbFZBFQlHjy8AjaKTUBd
	4vPrHewgtpCAnETTktXMILaoQITEgb5nrBC9ghI/Jt8D6xURCJZY+3UhI8gCZoFVjBLXLy9n
	A0kIC5hJXN9zjhFikJXEw2tPwQZxClhLLJ25FayZGajmUcs6ZghbXmLzmrfMEPXKEn8un2KC
	+E1Z4vnOnewTGEVmIdk9C0n7LCTtCxiZVzGKlRYnFxQnpadWGOoVJ+YWl+al6yXn525ihERT
	1Q7GO19tDjEKcDAq8fAqNGwMFmJNLCuuzD3EKMHBrCTCe9MHKMSbklhZlVqUH19UmpNafIiR
	iYNTqoExoHzPxrRy82eKmX2yz9Yu0yh3eZV87IZTidxcla74B/GMZw1vCPtlmZ1/JlsfG/Ld
	TIGFX2lXvo9f08KYyHOLa54H7Fr64fVegfr4NMn+nY8Xsce9fWgecrL9tvA25eJH/5OffrvT
	ePxSUGpogb35W0Xl4yvi2TZ+jn9qHi98KPKdfNs39SlKLMUZiYZazEXFiQA8gsA3hAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2014 11:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.15.3 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Jun 30 17:45:39 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.15.3-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>


Compiled and booted on my test system. No dmesg regressions.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
