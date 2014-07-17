Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932863AbaGQNYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:24:35 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:54444 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185AbaGQNYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:24:32 -0400
X-AuditID: cbfec37a-b7f206d000005572-5f-53c7ce8f8ac5
Message-id: <53C7CE8D.1050200@samsung.com>
Date: Thu, 17 Jul 2014 07:24:29 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.15 00/84] 3.15.6-stable review
References: <20140715231713.193785557@linuxfoundation.org>
In-reply-to: <20140715231713.193785557@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.242]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hX93+c8eDDe4vlbOYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGbeev2IpuMBWce1qB1MD40LWLkZODgkBE4lz57oYIWwxiQv31rN1
	MXJxCAksY5SYNOs/WEJIoJdJ4mODKkRiG6PEz1VzWEASvAJaEifPbgCbxCKgKrGjfzFYnE1A
	XeLz6x3sEM1yEk1LVjOD2KICERIH+p6xQvQKSvyYfA+sXkQgWGLt14WMIAuYBVYxSsw8/hcs
	IQx03o4tP5khBllJLN40BczmFLCWuLGqBWwBs4CZxKOWdcwQtrzE5jVvoeqVJf5cPsUE8Zqy
	xL4HcxgnMIrMQrJ7FpL2WUjaFzAyr2IUKy1OLihOSk+tMNQrTswtLs1L10vOz93ECImlqh2M
	d77aHGIU4GBU4uE9MfVYsBBrYllxZe4hRgkOZiUR3m1dx4OFeFMSK6tSi/Lji0pzUosPMTJx
	cEo1MMZGHnhyvWvL4tc57sfPsDW92su+xeNjyoounrOTnr5uvNydLhpeJvYxleXb1HkLO708
	jZ5/efPeKukkc/KTDWf6RRdWLApODeRmWVOo+vLP8s9Lzu0O3eT4ZPrkH8fbb0Xe+Fy67Ozk
	MsENJ5Xe3dKSmMzuJHAhIS/A0VZm3vLNH0xfMMb8iY9QYinOSDTUYi4qTgQA5eg1pYMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 05:16 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.15.6 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jul 17 23:17:00 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.15.6-rc1.gz
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
