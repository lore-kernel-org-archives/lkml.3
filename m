Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3KKR4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:56:38 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:55603 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754167Ab3KKR42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:56:28 -0500
X-AuditID: cbfec37d-b7f0e6d00000657c-c2-52811a4b8135
Message-id: <52811A42.800@samsung.com>
Date: Mon, 11 Nov 2013 10:56:18 -0700
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
Subject: Re: [PATCH 3.10 00/74] 3.10.19-stable review
References: <20131109065113.502217951@linuxfoundation.org>
In-reply-to: <20131109065113.502217951@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t9hX11vqcYgg5/r+S3mrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4MpYfvkIS8FCjop3h76wNjDuZOti5OSQEDCReLq+kxHCFpO4cG89UJyLQ0hgGaPE7Yvr
	mSCcXiaJlcu7GCGcjYwSh750AJVxcPAKqEkc3u8D0s0ioCpxc2Mr2CQ2AXWJz693sIPYQgJy
	Ek1LVjOD2KICERJHVz9jBbF5BQQlfky+xwJiiwgES6z9uhBsPrPACkaJ4y9fgp0nLGAqcWnp
	NjaIQVYSy+cdYAKxOQWsJT5tmQI2iFnATOJRyzpmCFteYvOat8wQ9coSfy6fYgK5U0JAUWL7
	aqsJjCKzkKyehaR7FpLuBYzMqxjFSouTC4qT0lMrTPSKE3OLS/PS9ZLzczcxQmKmdgfj/a82
	hxgFOBiVeHh3cDUGCbEmlhVX5h5ilOBgVhLhdeMFCvGmJFZWpRblxxeV5qQWH2Jk4uCUamC0
	WyPE62xnuSNlauLZnX2Zi45dTctdniKZ/WH5FefpuR4WN7bo7tjy7HZHTczOL0/evA/QfP03
	5BDT0ltC1pUGF3hmhks5ddrFXDhnfM1NLOag/OYTtV+u9HWw+C+alxP+5krUJe1r1wymtM26
	aPqYq+Bb9Ev/D99OmrlXFEkvN34V5PlW0ZxBiaU4I9FQi7moOBEAWPQVIncCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 11:51 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.19 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Nov 11 06:50:58 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.19-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.10.19:

Patch applied cleanly    yes
Compile test        passed
Boot test        passed
dmesg regression test    passed

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

-- Shuah
-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
