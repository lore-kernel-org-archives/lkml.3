Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754289Ab3H0UmE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 16:42:04 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:30626 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab3H0UmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 16:42:02 -0400
X-AuditID: cbfec37a-b7fb76d000006e93-c2-521d0f182850
Message-id: <521D0F16.3020301@samsung.com>
Date: Tue, 27 Aug 2013 14:41:58 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/74] 3.10.10-stable review
References: <20130827010424.535365435@linuxfoundation.org>
In-reply-to: <20130827010424.535365435@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9hP10JftkggyWT9S3mrF/DZtG8eD2b
	xeVdc9gsvv50sFiw8RGjxaO+t+wObB47Z91l9zgx4zeLx/65a9g9Pm+SC2CJ4rJJSc3JLEst
	0rdL4Mo41TCTvaCRp2L1g2lMDYw3OLsYOTkkBEwkri78ygZhi0lcuLceyObiEBJYxijxp+My
	M4TTyyTx8OkEqMxmRonG3f8YQVp4BbQk/q89wQpiswioSixfsYkFxGYTUJf4/HoHO4gtJCAn
	0bRkNTOILSoQIbFyyQNWiF5BiR+T74HViwgYS/SfnQVWzyxwjFFiYbNJFyMHh7CAtsTZJUkg
	ppCAlcS6RVwgFZwC1hKHek8xQVSbSTxqWccMYctLbF7zlhliq7LEn8sgNRxAjylKbF9tNYFR
	ZBaSvbOQdM9C0r2AkXkVo1hpcXJBcVJ6aoWhXnFibnFpXrpecn7uJkZIvFTtYLzz1eYQowAH
	oxIPr8VmmSAh1sSy4srcQ4wSHMxKIrwl/4FCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGOeL+f0r
	y7tbfMdr3fv1yxxOXVVnrRNgKtGPMuCc3vLRSusT65HSZY855Cu2Xd/Um+Ayibl4yrNChmPK
	+eIrF2TaP156dGflpsS3PHJf7HQfJtyqn/K8TMr+8D2vFd8kerc0cIn8M5k2uXDejsvKLVU3
	Hqy7v2vGI8vr+yPmyNxbeHNFir/c0gVKLMUZiYZazEXFiQB7UJcxdQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/2013 07:07 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.10 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Aug 29 01:03:56 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.10-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.10.10
--------
3.10.10-rc1 applied cleanly to 3.10.9

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

Cross-compile testing: HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:

Cross-compile tests results:

alpha: defconfig passed
arm: defconfig passed
arm64: defconfig passed
blackfin: defconfig passed
c6x: defconfig passed
mips: defconfig passed
mipsel: defconfig passed
powerpc: wii_defconfig passed
sh: defconfig passed
sparc: defconfig passed
tile: tilegx_defconfig passed

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
