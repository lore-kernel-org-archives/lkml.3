Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243Ab3KTP2j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 10:28:39 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:39832 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab3KTP2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 10:28:37 -0500
X-AuditID: cbfec37d-b7f0e6d00000657c-4b-528cd5249b4c
Message-id: <528CD522.4020603@samsung.com>
Date: Wed, 20 Nov 2013 08:28:34 -0700
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
Subject: Re: [PATCH 3.4 00/12] 3.4.70-stable review
References: <20131118184130.257996039@linuxfoundation.org>
In-reply-to: <20131118184130.257996039@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9hP12Vqz1BBp/3a1jMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJWx55t9wTWuirMvF7A2MB7l6GLk5JAQMJHY37iGFcIWk7hwbz1bFyMXh5DAMkaJ59db
	mSCcXiaJnwfes4BUCQlsYpS41RoDYvMKaEm075rPBmKzCKhKvJ08C8xmE1CX+Px6BztEvZxE
	05LVzCC2qECExNHVz1ghegUlfky+BzZTRCBYYu3XhYwgy5gFVjBKHH/5EmyQsICxxNODL6AG
	WUnceLKYCcTmFLCWWDXrFNggZiB75aRtjBC2vMTmNW+ZIeqVJf5cPgVUzwH0mqLE9tVWExhF
	ZiFZPQtJ9ywk3QsYmVcxipUWJxcUJ6WnVpjoFSfmFpfmpesl5+duYoRETO0OxvtfbQ4xCnAw
	KvHwFi7qDhJiTSwrrsw9xCjBwawkwtu1tydIiDclsbIqtSg/vqg0J7X4ECMTB6dUA+ME/5oT
	cTPvn7n5KmFefvJEoy/xy3e6bREICttjtClm3+eFn1aL5xdITOk+K5ks5N79WKJUy/botB+1
	awxZLqkaaE2SDbE6evjq590bWg+I/uxbeefR+ZfC8bvWG0tu51cqN9e5NnuWyzPf8zrf7ruo
	GU+c9P3BvtlTW5I4zqk4KpY7TNCZxbxViaU4I9FQi7moOBEAZWDE03YCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2013 11:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.70 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Nov 20 18:41:11 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.70-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.4.70:

patches applied cleanly
Compile test - passed
Boot tests - passed

dmesg regression tests - passed
[dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.]

Cross-compile testing - limited tests passed (alpha, arm, arm64, 
blackfin, c6x, powerpc, sh, sparc, tile)

Test systems:
Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2 (cross-compile testing)

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
