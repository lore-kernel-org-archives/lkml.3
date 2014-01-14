Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaANTak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:30:40 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:9528 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaANTaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:30:39 -0500
X-AuditID: cbfec37c-b7f0d6d0000057bc-12-52d5905dc4fa
Message-id: <52D5905B.1010103@samsung.com>
Date: Tue, 14 Jan 2014 12:30:35 -0700
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
Subject: Re: [PATCH 3.10 00/62] 3.10.27-stable review
References: <20140114002710.464561569@linuxfoundation.org>
In-reply-to: <20140114002710.464561569@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.5]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hP93YCVeDDNre2FjMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJWx6MYbxoLvnBVHbzUxNTB+Zu9i5OSQEDCR2PFyKRuELSZx4d56IJuLQ0hgGaPEoolb
	GSGcXiaJrv9HWEGqhAQ2MErM6CsAsXkFtCQeL7jDCGKzCKhKLNxzDMxmE1CX+Px6BztEvZxE
	05LVzCC2qECExKuzE1kgegUlfky+B2aLCARLrP26EGwZs8AKRonjL1+CnSQsYCpxe8sHFohB
	VhIrJ/0FW8ApYC0x895JsBpmATOJRy3rmCFseYnNa94yQ9QrS/y5fIoJ4jUFiRsLl7FOYBSZ
	hWT3LCTts5C0L2BkXsUoVlqcXFCclJ5aYaxXnJhbXJqXrpecn7uJERI1NTsY7321OcQowMGo
	xMP7I/xqkBBrYllxZe4hRgkOZiURXvl6oBBvSmJlVWpRfnxRaU5q8SFGJg5OqQbGhM0Gzsc4
	jHbvqaxr1Nz2mP28U8Dz7fGR/KZ/Tm2oevuxe2Z/1/m1yhuDHKvtcrs1pRlyuR7uP9YVbpl0
	bi3bddH49TL3dRbt2GvXnbPi6LoA63NGf+s+3ZWPCS7cdf3QvDXifDOWFDXrx5fmmfcUWKUn
	bDrZ8HG+tjNTkuX6rSn6VscfTahUYinOSDTUYi4qTgQAVKvHYngCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 05:26 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.27 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jan 16 00:26:56 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.27-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patch testing - passed
Compile testing - passed
Boot testing - passed
dmesg regression testing - passed

Test systems

Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
Dell OptiPlex 790 Intel(R) Core(TM) i5-2400

Detailed test status

Patches applied cleanly

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
