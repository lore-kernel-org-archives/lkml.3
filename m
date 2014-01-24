Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaAXPTk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 10:19:40 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:23825 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710AbaAXPTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 10:19:39 -0500
X-AuditID: cbfec37d-b7ff46d000005528-e3-52e28489d350
Message-id: <52E28487.5060204@samsung.com>
Date: Fri, 24 Jan 2014 08:19:35 -0700
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
Subject: Re: [PATCH 3.12 00/27] 3.12.9-stable review
References: <20140123190648.720195687@linuxfoundation.org>
In-reply-to: <20140123190648.720195687@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.10]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9hX93OlkdBBsf/GlvMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJWxaOFctoLD7BVn2y8wNjD+Ze1i5OSQEDCRuDnpF5QtJnHh3nq2LkYuDiGBZYwSnxbt
	ZYJwepkk3m65BuVsYpToWHuDBaSFV0BLom/dNuYuRg4OFgFViZ9tLiBhNgF1ic+vd7CD2EIC
	chJNS1Yzg9iiAhESr85OhGoVlPgx+R6YLSIQLLH260JGkPnMAisYJY6/fMkGkhAGOu/k+U9Q
	g6wkNnReYgLZxSlgLfGh3w4kzCxgJvGoZR0zhC0vsXnNW2aIcmWJP5dPgZVLCChKvHhoNYFR
	ZBaSzbOQdM9C0r2AkXkVo1hpcXJBcVJ6aoWJXnFibnFpXrpecn7uJkZIxNTuYLz/1eYQowAH
	oxIP74fgh0FCrIllxZW5hxglOJiVRHilqh8FCfGmJFZWpRblxxeV5qQWH2Jk4uCUamDsiTvF
	95lb4m6120St2gRD1c4XsWtidu3bFL7mltijNyKz9Tc+WPtucrC32k6uTyFJ9cd2ey5tMF5x
	grk5zYh3rf7vqWUGtlkunqdrrhkUKCRn2k0rN5FM0tF5kcZskiLF9XP/1Vnz+CVD00Kv30zg
	zE//970lMI87Zc3Wn183yT3kvrBz1VUlluKMREMt5qLiRADT2S3ndgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 12:06 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.9 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Jan 25 19:06:36 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.9-rc1.gz
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
