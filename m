Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095AbaGQNZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:25:26 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:58412 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbaGQNZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:25:23 -0400
X-AuditID: cbfec37d-b7fbf6d000005712-b6-53c7cec1b9d3
Message-id: <53C7CEBF.5040400@samsung.com>
Date: Thu, 17 Jul 2014 07:25:19 -0600
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
Subject: Re: [PATCH 3.4 00/22] 3.4.99-stable review
References: <20140715231622.121816073@linuxfoundation.org>
In-reply-to: <20140715231622.121816073@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.242]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9hP92D544HG/TMNraYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGT9ndLMUXGKrmH17B1MD40LWLkZODgkBE4nDc3exQ9hiEhfurWfr
	YuTiEBJYxijR2r2EHcLpZZJ4fHM7VGYbo0THlGYmkBZeAS2J2Wc+sYDYLAKqEjcfrwUbyyag
	LvH59Q6wsUICchJNS1Yzg9iiAhESB/qesUL0Ckr8mHwPrFdEIFhi7deFjCALmAVWMUpcv7yc
	DSQhLGAs8evafKhBVhJnL7wAa+AUsJZYcH8XWA2zgJnEo5Z1zBC2vMTmNW+ZIeqVJf5cPsUE
	8ZuyxL4HcxgnMIrMQrJ7FpL2WUjaFzAyr2IUKy1OLihOSk+tMNErTswtLs1L10vOz93ECImm
	2h2M97/aHGIU4GBU4uFNaD0WLMSaWFZcmXuIUYKDWUmEd1vX8WAh3pTEyqrUovz4otKc1OJD
	jEwcnFINjBZcJYYFu45dD8r9ybks8/l+jxmNqheN/LntLeL7tNxFZA2dfhR6uDJedDxUrl5v
	2VbOH5ck/cfHUXbfkWkmCdrHS1u8HBojz59LWnVd6TC7rlvCrVWTdsteVvTXerbn/2K9gwaB
	XAmZ6jfSJU5LMPHyxE/0jQw+cqBnypuLQov5pKuvlXcosRRnJBpqMRcVJwIAVn2ihoQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 05:17 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.99 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jul 17 23:16:04 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.99-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

rc1 and rc2 compiled and booted on my test system. No dmesg regressions.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
