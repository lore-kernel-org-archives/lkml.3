Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756058AbaF3QSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:18:21 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:35766 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613AbaF3QSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:18:20 -0400
X-AuditID: cbfec37c-b7fd06d000004f49-29-53b18dca0091
Message-id: <53B18DC8.3000602@samsung.com>
Date: Mon, 30 Jun 2014 10:18:16 -0600
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
Subject: Re: [PATCH 3.14 000/110] 3.14.10-stable review
References: <20140628174545.354748696@linuxfoundation.org>
In-reply-to: <20140628174545.354748696@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.211]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9hP91TvRuDDQ4+MLaYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGdemXGArOMlWsXLVFvYGxtmsXYycHBICJhIv2pcwQdhiEhfurWfr
	YuTiEBJYxihxYdofsCIhgV4miX2/oRLbGCVu9/xlBknwCmhJrF18kbGLkYODRUBVYm2HPUiY
	TUBd4vPrHewQvXISTUtWg5WLCkRIHOh7xgrRKijxY/I9FhBbRCBYYu3XhYwg85kFVjFKXL+8
	nA0kISxgLnG6+TYzxCArifaJ+8AaOAWsJXrOPgC7mlnATOJRyzpmCFteYvOat1D1yhJ/Lp+C
	+kxZ4vnOnewTGEVmIdk9C0n7LCTtCxiZVzGKlRYnFxQnpadWGOsVJ+YWl+al6yXn525ihERS
	zQ7Ge19tDjEKcDAq8fAqNGwMFmJNLCuuzD3EKMHBrCTCe9MHKMSbklhZlVqUH19UmpNafIiR
	iYNTqoExx1Lnyj7/5CWr1x2cw83v63PLJf2l0rdAlqA+fi1Tvfvu6kJyJ0rfnBMR5WWYz5AX
	yBP0JdejLnd1p6H+QTn7zKhGmz0Vs491LPfaXiMTFhLseVf7g5AST4fBVB7JjpYzb6JqXxWZ
	iD48cmTFpVKj8jyFteqnfwe/WLWQpXbpqolrTFbtZFZiKc5INNRiLipOBAAj8xo3ggIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2014 11:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.10 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Jun 30 17:45:23 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.10-rc1.gz
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
