Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaAXPSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:18:54 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:18987 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472AbaAXPSw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:18:52 -0500
X-AuditID: cbfec37a-b7ef66d000004f2b-fa-52e2845a3922
Message-id: <52E28451.7070306@samsung.com>
Date: Fri, 24 Jan 2014 08:18:41 -0700
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
Subject: Re: [PATCH 3.10 00/23] 3.10.28-stable review
References: <20140123183859.635713053@linuxfoundation.org>
In-reply-to: <20140123183859.635713053@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.10]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hP92olkdBBssXGVjMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJVxcN9atoLj7BVHb75jbWD8z9rFyMkhIWAi0dS9hh3CFpO4cG89WxcjF4eQwDJGiZYj
	l5ggnF4miXXf3rBAOJsYJZ4sWMQE0sIroCXx+/M+MJtFQFVi+ptfYKPYBNQlPr/eAWYLCchJ
	NC1ZzQxiiwpESLw6O5EFoldQ4sfke2C2iECwxNqvCxlBFjALrGCUOP7yJRtIQljAVOLqrF3M
	EIOsJDZtfQNmcwpYS3z7f5ARxGYWMJN41LKOGcKWl9i85i1UvbLEn8ungI7jAPpNUeLFQ6sJ
	jCKzkKyehaR7FpLuBYzMqxjFSouTC4qT0lMrDPWKE3OLS/PS9ZLzczcxQqKmagfjna82hxgF
	OBiVeHg/BD8MEmJNLCuuzD3EKMHBrCTCK1X9KEiINyWxsiq1KD++qDQntfgQIxMHp1QDI9/Z
	26vt2CSm+azrX3F08eOt1ycsmZJiMP/ho5+vm74/65Va33F3ymIjub/2zw9+fqT7uHrR/bBM
	oXAVpldrXQ7IN1sKm3SGBEZumfnY+Tf/s1LZvw8Xeqv6TKzb8+ZflI7yn5UTlnOHOHu/s1yw
	7/7G3guX5R2Zs2dY62Qoi8ypmBujw5TWf1KJpTgj0VCLuag4EQAk9pqWeAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 11:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.28 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Jan 25 18:38:43 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.28-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patch testing - passed
Compile testing - passed
Boot testing - passed
dmesg regression testing - passed - no regressions in emerg, crit, 
alert, err are clean. No regressions in warn.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
