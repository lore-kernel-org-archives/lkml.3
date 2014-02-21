Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537AbaBUXjJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:39:09 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:60812 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753551AbaBUXjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:39:07 -0500
X-AuditID: cbfec37d-b7f616d0000059df-cc-5307e39960cd
Message-id: <5307E391.80206@samsung.com>
Date: Fri, 21 Feb 2014 16:38:57 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.10 00/66] 3.10.32-stable review
References: <20140220234909.482516304@linuxfoundation.org>
In-reply-to: <20140220234909.482516304@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.6]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hP91Zj9mDDWZ/YbOYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugSujZ/cFtoIX7BXtKzsYGxjns3UxcnJICJhI9K9uZYawxSQu3FsPFOfiEBJYxijxessb
	Zginl0mif9NesA4hgQ2MEg27KkFsXgENifV/F7GD2CwCqhLv/k5jArHZBNQlPr/ewQ5RLyfR
	tGQ12AZRgQiJV2cnskD0Ckr8mHwPzBYRCJZY+3UhI8gyZoEVjBLHX74EWyYsYCqx6t8dFohB
	VhK7m9aDDeUUsJZ4fuIJ2DJmATOJRy3rmCFseYnNa94yQ9QrS/y5fIoJ4jUFiUdXW9knMIrM
	QrJ7FpL2WUjaFzAyr2IUKy1OLihOSk+tMNErTswtLs1L10vOz93ECIma2h2M97/aHGIU4GBU
	4uGdkc4eLMSaWFZcmXuIUYKDWUmEV2URUIg3JbGyKrUoP76oNCe1+BAjEwenVAMjM4/GpoJn
	n+1kZx3enn/sbOuhLUcXXP3/Uuqx1NMZ/Cd9FKdkx82/uOLPnxCGQqHCfHVN7vu62Roq+apr
	tghYLVjn1GSWdPUuA9sMvzsvD/99/UND+vimvnWfQuW0bnlKLP3Od6B+9xy1VEPBJ/bxbopP
	7n+XzzvraLDsdvW0dfM0e/0NjSY7KrEUZyQaajEXFScCAGJSYG94AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 04:50 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.32 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Feb 22 23:48:52 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.32-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

After dropping the iio: max1363: Use devm_regulator_get_optional for 
optional regulator change:

Compile tests and boot tests passed. No dmesg regressions: emerg, crit, 
alert, err are clean. No regressions in warn.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
