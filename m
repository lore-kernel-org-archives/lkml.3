Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab3LSUsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:48:22 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:30463 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365Ab3LSUsT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:48:19 -0500
X-AuditID: cbfec37b-b7f216d000006a8d-ee-52b35b92a7cf
Message-id: <52B35B8D.3000901@samsung.com>
Date: Thu, 19 Dec 2013 13:48:13 -0700
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
Subject: Re: [PATCH 3.12 000/118] 3.12.6-stable review
References: <20131218211219.461663463@linuxfoundation.org>
In-reply-to: <20131218211219.461663463@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hP91J0ZuDDCav17GYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugStj/7F/rAUXOStOHrrE0sB4mr2LkZNDQsBEYvbUQywQtpjEhXvr2boYuTiEBJYxSnTc
	u84E4fQySdy9cYkdwtnIKNEyo5sRpIVXQEvi/OxWsHYWAVWJm0+mMIHYbALqEp9f7wBbISQg
	J9G0ZDUziC0qECFxdPUzVoheQYkfk++B9YoIBEus/bqQEWQBs8AKRonjL1+ygSSEBcwktlx7
	zwgxyErixO1jYEM5BawlNs+ZChZnBqp51LKOGcKWl9i85i0zRL2yxJ/Lp4AO4gD6TVFi+2qr
	CYwis5CsnoWkexaS7gWMzKsYxUqLkwuKk9JTK4z0ihNzi0vz0vWS83M3MUKipnoH492vNocY
	BTgYlXh4K802BwmxJpYVV+YeYpTgYFYS4f0ZCRTiTUmsrEotyo8vKs1JLT7EyMTBKdXAGF0k
	Ia1qqDt/nThbcK3W8XmP9e5sXrhdeM7GZ6WlL698uy5o4PGxxH6hAvubkHmXHu2QdNqwXHzh
	3x1vrzGLzIxg3dP0+vzyO+/FPMU/O01bnRay23zay9Wl4Slfw4IT4qvNuRe7KTHVTV2dWpdS
	tVaUZXF4jwN/9lWembNdaz8t8zqV+jdBVomlOCPRUIu5qDgRABT7Gr94AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 02:10 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.6 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Dec 20 21:12:03 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.6-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patch applied cleanly
Compile testing - passed
Boot testing - passed
dmesg regression testing - passed

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

Test systems

     Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
     HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
     Dell OptiPlex 790 Intel(R) Core(TM) i5-2400

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
