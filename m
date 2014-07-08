Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471AbaGHTa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:30:56 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:8840 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932263AbaGHTay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:30:54 -0400
X-AuditID: cbfec37d-b7fbf6d000005712-28-53bc46edcdba
Message-id: <53BC46EA.4050304@samsung.com>
Date: Tue, 08 Jul 2014 13:30:50 -0600
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
Subject: Re: [PATCH 3.15 000/122] 3.15.5-stable review
References: <20140707235734.234226883@linuxfoundation.org>
In-reply-to: <20140707235734.234226883@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.209]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9hP923bnuCDT6ekrSYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGTvmv2YtOMpWsWvGGrYGxhmsXYycHBICJhKdn36wQ9hiEhfurWfr
	YuTiEBJYxijx58MzVginl0li77MOFghnG6PEzceXWUBaeAW0JBrvPGUEsVkEVCUaTv0Gs9kE
	1CU+v94BNlZIQE6iaclqZhBbVCBC4kDfM1aIXkGJH5Pvgc0REQiWWPt1ISPIAmaBVYwS1y8v
	ZwNJCAuYSZy4uosZYpCVxInbx8DinALWEgen/gNbxgxU86hlHTOELS+xec1bqHpliT+XTzFB
	/KYsMbHxNssERpFZSHbPQtI+C0n7AkbmVYxipcXJBcVJ6akVJnrFibnFpXnpesn5uZsYIdFU
	u4Px/lebQ4wCHIxKPLwnOPcEC7EmlhVX5h5ilOBgVhLhXS4IFOJNSaysSi3Kjy8qzUktPsTI
	xMEp1cCYWJn7ZeWjFImWv3v/dXdkvnZfu30ba215WlmJlYzE4VWMKguvljoz/T0+Oep7rrWH
	+PkDk5Y36Lo+33d+lorQ+59Br5k3z+Ar4N9W89Bnt8rHjZl7PkR5dT6e2bJ+ZvX3ua0rTldH
	rkuST0lI+PJNUSzhZ8yTZYrV7I0L0oNUhcrXbs5/yT1RiaU4I9FQi7moOBEAASPG54QCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 05:56 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.15.5 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jul  9 23:57:10 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.15.5-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my test system. No demsg regressions.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
