Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768AbaHIOlM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 10:41:12 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:48048 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaHIOlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 10:41:08 -0400
X-AuditID: cbfec37d-b7f676d000000907-c0-53e633029732
Message-id: <53E632F9.6000504@samsung.com>
Date: Sat, 09 Aug 2014 08:40:57 -0600
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
Subject: Re: [PATCH 3.4 00/23] 3.4.103-stable review
References: <20140808213315.769217722@linuxfoundation.org>
In-reply-to: <20140808213315.769217722@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.217]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9hP10m42fBBoe/KVrMWb+GzaJ58Xo2
	i8u75rBZPFl4hsli6qkJLBYLNj5itHjU95bdgd1j56y77B4nZvxm8dg/dw2Q+72B3ePzJrkA
	1igum5TUnMyy1CJ9uwSujKvtJ5gKTrBV7F/6mLWBcRZrFyMnh4SAicS6dS+gbDGJC/fWs3Ux
	cnEICSxjlPh8diorhNPLJHF36SEWCGcbo8SsdSdYQFp4BbQkpvd1MoPYLAKqEvdmzgez2QTU
	JT6/3sEOYgsJyEk0LVkNFhcViJA40PeMFaJXUOLH5Htgc0QEgiXWfl3ICLKAWWAVo8T1y8vZ
	QBLCQPdt+DSDGWKQlcTnfT1gNqeAtcSLi71MIDYzkL1y0jZGCFteYvOat1D1yhJ/Lp9igvhN
	WeL+5IMsExhFZiHZPQtJ+ywk7QsYmVcxipUWJxcUJ6WnVpjoFSfmFpfmpesl5+duYoREU+0O
	xvtfbQ4xCnAwKvHwrrB5GizEmlhWXJl7iFGCg1lJhPeE+rNgId6UxMqq1KL8+KLSnNTiQ4xM
	HJxSDYwVd4yrLyUf3vm2XLekWpw7fFkMl1F3ofmNwz5hDrfapyzewnvd6YGk/6vybwej9S9d
	bsj7wCVUUL9vUVAy1w2B4KqHlbo9J55lmCwuOnMjPO7j+kBTy27BqNk/drO5d7OkSV9RuWEy
	MWEST5tXWIKGRlF77q7/tYtccvr8F6en/Lf712/7SomlOCPRUIu5qDgRAL5pqluEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 03:34 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.103 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Aug 10 21:33:01 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.103-rc1.gz
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
