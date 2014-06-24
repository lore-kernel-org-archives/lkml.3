Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754557AbaFXTuW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:50:22 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:53481 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754412AbaFXTuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:50:18 -0400
X-AuditID: cbfec37a-b7f206d000005572-b8-53a9d6785040
Message-id: <53A9D676.3030203@samsung.com>
Date: Tue, 24 Jun 2014 13:50:14 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.4 00/26] 3.4.95-stable review
References: <20140624154619.499002156@linuxfoundation.org>
In-reply-to: <20140624154619.499002156@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.222]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hP92KayuDDf7eNraYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGddnXmEvOMZW8WNnC1sD4wzWLkYODgkBE4lvJw27GDmBTDGJC/fW
	s3UxcnEICSxjlLh67y0ThNPLJLF5+k9mCGcbo8TdjecYQVp4BbQkDk+cxgJiswioStw/sood
	xGYTUJf4/HoHmC0kICfRtGQ1M4gtKhAhcaDvGStEr6DEj8n3wHpFBIIl1n5dyAiygFlgFaPE
	9cvL2UASwgLGEn+b9rNBDLKS2HLpAthiTgFriUsbloA1MwPZKydtY4Sw5SU2r3nLDFGvLPHn
	8ikmiN+UJZ5MOc84gVFkFpLds5C0z0LSvoCReRWjWGlxckFxUnpqhaFecWJucWleul5yfu4m
	RkgsVe1gvPPV5hCjAAejEg9vxcyVwUKsiWXFlbmHGCU4mJVEeE27gUK8KYmVValF+fFFpTmp
	xYcYmTg4pRoYu6S+p3x/LzNv/WmH1kcpRowS7yTaUzerTrDt/Tbz5vYX4ZcrPx59FnIuNuLM
	qwMybxk2Z5WenLO/abLc9jPSjw4nZFmbSKydGxO1sbXr1qw43p9LJnLNcrfayW+4cu2Brda2
	k3bcSollTbN7anbr7jH122e9dhQW12zP/bVvf/LJ4MXXS5OWMiuxFGckGmoxFxUnAgDSbSNy
	gwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 09:50 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.95 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jun 26 15:46:05 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.95-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my test system. No dmesg regressions.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
