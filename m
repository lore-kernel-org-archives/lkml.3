Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088AbaANTbf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:31:35 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:64792 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991AbaANTbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:31:15 -0500
X-AuditID: cbfec37c-b7f0d6d0000057bc-39-52d5908251f5
Message-id: <52D5907F.7010508@samsung.com>
Date: Tue, 14 Jan 2014 12:31:11 -0700
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
Subject: Re: [PATCH 3.12 00/77] 3.12.8-stable review
References: <20140114002752.497010554@linuxfoundation.org>
In-reply-to: <20140114002752.497010554@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.5]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hX92mCVeDDNqnyVjMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJXRd2gLa8FnzorO3qWsDYwf2bsYOTkkBEwkbnX9ZoKwxSQu3FvP1sXIxSEksIxRou3H
	cXYIp5dJYvnvZUwQzgZGiaNrOpi7GDk4eAW0JP7PVwLpZhFQlVh19QHYJDYBdYnPr3eAbRAS
	kJNoWrKaGcQWFYiQeHV2IguIzSsgKPFj8j0wW0QgWGLt14WMIPOZBVYwShx/+ZINJCEMdN7H
	rZNYIQZZSbx5d4YJZC+ngLXE549qIGFmATOJRy3rmCFseYnNa94yQ5QrS/y5fArqMwWJGwuX
	sU5gFJmFZPUsJO2zkLQvYGRexShWWpxcUJyUnlphrFecmFtcmpeul5yfu4kREjM1OxjvfbU5
	xCjAwajEw/sj/GqQEGtiWXFl7iFGCQ5mJRFe+XqgEG9KYmVValF+fFFpTmrxIUYmDk6pBka/
	aWVvlT4FfpCaJGzCUuHy4BT3/mXq/D+mmwnnbRK7ZfiwedoaUfNJMauyF5055bS4lfm5r25L
	0asXc56Vh6d8C3RrvVMZcjtXUGnpFr12lcQJhswL+t8dN5weUzJTp7hXIOIjz0NOD/b7h1m3
	no5kSKrybXluqSMcIzKNY2vQYhOWK1MVpZVYijMSDbWYi4oTAQiaOmF3AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2014 05:27 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.8 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jan 16 00:27:35 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.8-rc1.gz
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
