Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932134Ab3LSUq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:46:58 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:50258 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932094Ab3LSUqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:46:55 -0500
X-AuditID: cbfec37b-b7f216d000006a8d-98-52b35b3ec212
Message-id: <52B35B36.4080501@samsung.com>
Date: Thu, 19 Dec 2013 13:46:46 -0700
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
Subject: Re: [PATCH 3.4 00/31] 3.4.75-stable review
References: <20131218210522.790152625@linuxfoundation.org>
In-reply-to: <20131218210522.790152625@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9hX1276M1BBk9u8FrMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJVx7/tGxoILnBVzFy9nb2A8xd7FyMkhIWAicevrXyhbTOLCvfVsILaQwDJGicl92V2M
	XEB2L5PEilXdTBDORkaJpt6DLCBVvAJaEm/+PgTrZhFQlTj99SdYN5uAusTn1zvYISbJSTQt
	Wc0MYosKREgcXf2MFaJXUOLH5Htgc0QEgiXWfl3ICLKAWWAFo8Txly+BBnFwCAsYS8x6XwEx
	x0ri/tvNjCA2p4C1xMnjvWBzmIHslZO2MULY8hKb17xlhqhXlvhz+RQTyBgJAUWJ7autJjCK
	zEKyeRaS7llIuhcwMq9iFCstTi4oTkpPrTDSK07MLS7NS9dLzs/dxAiJmOodjHe/2hxiFOBg
	VOLhrTTbHCTEmlhWXJl7iFGCg1lJhDfGBCjEm5JYWZValB9fVJqTWnyIkYmDU6qBceKyeyWr
	8r48XZi56sNVf5W7ykJ3hcu2v724bHO7TN4Ozrj+yqTWwMBM8aAV/xkFGCZfVkrfI7T5WKWS
	xTXWPffXtEzlXBizq+rO5anX+ac69JzZkHc68+zFL/P2O1sHuST/6iy5cX6TIRvjKemljUf4
	uuYzBrcEnG9fXLPrmd/bZf+XLHq3LlaJpTgj0VCLuag4EQD1u2SZdgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 02:08 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.75 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Dec 20 21:05:11 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.75-rc1.gz
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
