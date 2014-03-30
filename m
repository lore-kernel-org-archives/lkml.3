Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaC3B0Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 21:26:25 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:49692 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752879AbaC3B0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 21:26:23 -0400
X-AuditID: cbfec37b-b7f8f6d000007030-a4-533772be307a
Message-id: <533772BC.8030504@samsung.com>
Date: Sat, 29 Mar 2014 19:26:20 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/13] 3.4.85-stable review
References: <20140328173053.049244535@linuxfoundation.org>
In-reply-to: <20140328173053.049244535@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.220]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hP919RebBBre79C3mrF/DZtG8eD2b
	xeVdc9gsniw8w2Qx9dQEFosFGx8xWjzqe8vuwO6xc9Zddo8TM36zeOyfuwbI/d7A7vF5k1wA
	axSXTUpqTmZZapG+XQJXxpwPugUn2Sq6Dy9kaWCcw9rFyMkhIWAi8eXzMyYIW0ziwr31bF2M
	XBxCAssYJaa8aWWEcHqZJBZ8uMYK4WxjlLi3+hoLSAuvgJbE7p5dYO0sAqoSC2d2soPYbALq
	Ep9f7wCzhQTkJJqWrGYGsUUFIiRenZ0I1Sso8WPyPTBbRCBYYu3XhWDbmAVaGSUeP5wKNlRY
	wFji6d4nbBCDrCTuLd4LNohTwFriyKGVYM3MQPbKSdsYIWx5ic1r3jJD1CtL/Ll8Cuo3ZYm5
	Lc/YJzCKzEKyexaS9llI2hcwMq9iFCstTi4oTkpPrTDSK07MLS7NS9dLzs/dxAiJpeodjHe/
	2hxiFOBgVOLhZbA0DxZiTSwrrsw9xCjBwawkwrtPDyjEm5JYWZValB9fVJqTWnyIkYmDU6qB
	MfuK9ZYr1Rfn7Hu/24bh0tQOfa3Jp84qBdavmnboxb3DtWr33Wo89SOvy3V+PLfcvD/f3jlU
	XTm78epZh2UZKQkcPSveCd3akbbsxcL9y5v8Odr5VpyLsr6Uoe8T7PnxpvIdqzPp7Ax8V4N3
	nkx4ar8i1W5F01nTNfXV2UfdTiUyB7eb7S4+osRSnJFoqMVcVJwIAI6pQ2mDAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2014 11:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.85 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Mar 30 17:30:36 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.85-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled, and booted on my test systems. No regressions in dmesg.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
