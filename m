Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaDAVGo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:06:44 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:19946 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbaDAVGm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:06:42 -0400
X-AuditID: cbfec37c-b7f536d0000059f2-54-533b2a602209
Message-id: <533B2A5D.2030403@samsung.com>
Date: Tue, 01 Apr 2014 15:06:37 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.4 0/6] 3.4.86-stable review
References: <20140401032815.814334997@linuxfoundation.org>
In-reply-to: <20140401032815.814334997@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.4]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9hX90ELetggy1HdC3mrF/DZtG8eD2b
	xeVdc9gsniw8w2Qx9dQEFosFGx8xWjzqe8vuwO6xc9Zddo8TM36zeOyfuwbI/d7A7vF5k1wA
	axSXTUpqTmZZapG+XQJXxreN59kKjrJV/H66iLWBcSZrFyMnh4SAicTLqw2MELaYxIV769m6
	GLk4hASWMUrc3dzMBOH0MklcWn+PGcLZwCgx8dguFpAWXgEtiRWdX9lBbBYBVYm19+Yzg9hs
	AuoSn1/vAIsLCchJNC1ZDRYXFYiQeHV2IlSvoMSPyffAbBGBYIm1XxcygixgFljFKHH98nI2
	kISwgKFEy64prBCDrCT2b70D1sApYC0x680JsDgzkL1y0jZGCFteYvOat8wQ9coSfy6fYoL4
	TUFixY03LBMYRWYh2T0LSfssJO0LGJlXMYqVFicXFCelp1YY6xUn5haX5qXrJefnbmKERFPN
	DsZ7X20OMQpwMCrx8B44bxUsxJpYVlyZe4hRgoNZSYR3G5N1sBBvSmJlVWpRfnxRaU5q8SFG
	Jg5OqQZGhbjvPy2+Nv+9ZVQeNPdzedAr90fP50iWtYd5Gwe2mt+pimnNYtFM2f/z4IrzEbMC
	P6/etWZVcqvKhUZzlYy0DYcvMnJIupzZUXintGb+uSc7Dn6+dlEi4Uj6IY6uvgaFjM+d028l
	29xabmIc0hPPU//khEjy+v2fWv/sNTWytLfe/FZHSKxHiaU4I9FQi7moOBEAPwEwOoQCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 10:07 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.86 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Apr  3 03:28:04 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.86-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled, booted on all my test systems. No regressions in dmesg.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
