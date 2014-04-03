Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752775AbaDCP5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 11:57:32 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:33624 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752566AbaDCP52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 11:57:28 -0400
X-AuditID: cbfec37b-b7f8f6d000007030-76-533d84e6705d
Message-id: <533D84DC.2050604@samsung.com>
Date: Thu, 03 Apr 2014 09:57:16 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.12 00/40] 3.12.17-stable review
References: <cover.1396469191.git.jslaby@suse.cz>
In-reply-to: <cover.1396469191.git.jslaby@suse.cz>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.219]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9hX91nLbbBBjs+qlt8/r2L1eLyrjls
	Fgs2PmJ0YPY4s+AIu8fnTXIBTFFcNimpOZllqUX6dglcGUe3T2IvOMFW8Wn1T+YGxnmsXYyc
	HBICJhJtMxvZIGwxiQv31gPZXBxCAssYJdYeWcsO4fQySWzb3c0M4WxjlHj3sp0dpIVXQEti
	4Yo9TCA2i4CqxNHrN8DGsgmoS3x+vQOsRkhATqJpyWpmEFtUIELi1dmJLBC9ghI/Jt8Ds0UE
	zCUe3DkAVs8s4Cwx991jsDnCAqYS69auY4WYYyjx5eBVMJtTwEjixbd9bBD11hIrJ21jhLDl
	JTavecsMUa8s8efyKSaI15Ql3vdOZprAKDILyepZSNpnIWlfwMi8ilGstDi5oDgpPbXCSK84
	Mbe4NC9dLzk/dxMjJAqqdzDe/WpziFGAg1GJh5cj3TZYiDWxrLgy9xCjBAezkgjvsUSgEG9K
	YmVValF+fFFpTmrxIUYmDk6pBka5192/BcKqTi92rV3svt/FTCVEqdPKLdnotZTqDYYVbacC
	lny7Lu93S/bnRceMO3yzZlw3My++PWNu+omdxyL9vJ/pvu+IV217F3Oq9ZHkmarLAs/yzl64
	fEd7mZ699eL2w+1PD6rGH7BZWZ/TVPhStPVx/uGdYhxhpoG7NnC6ShvU6D7hm6fEUpyRaKjF
	XFScCABqWQEFYAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2014 02:12 PM, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.17 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Apr  4 20:06:31 2014
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	http://kernel.org/pub/linux/kernel/people/jirislaby/stable-review/patch-3.12.17-rc1.xz
> and the diffstat can be found below.
>
> thanks,
> js
>

Compiled and booted on all my test systems. No dmesg regressions.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
