Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754AbaGPNBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:01:32 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:42170 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932770AbaGPNB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:01:29 -0400
X-AuditID: cbfec7f4-b7fac6d000006cfe-9f-53c677a76105
Message-id: <53C67783.4090407@samsung.com>
Date: Wed, 16 Jul 2014 15:00:51 +0200
From: Tomasz Figa <t.figa@samsung.com>
Organization: Samsung R&D Institute Poland
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@kernel.org>,
        =?UTF-8?B?SGVpa28gU3TDvGJuZXI=?= <heiko@sntech.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: Re: [PATCH 18/19] ARM: SAMSUNG: Remove remaining legacy code
References: <1404496099-26708-1-git-send-email-t.figa@samsung.com>
 <1404496099-26708-19-git-send-email-t.figa@samsung.com>
 <1405506268.4408.28.camel@x220>
In-reply-to: <1405506268.4408.28.camel@x220>
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t/xK7rLy48FG7T8sbb4O+kYu8XUh0/Y
	LP4/es1q0bvgKpvFpsfXWC0u75rDZjHj/D4mi7VH7rJbnLr+mc1i0a0zzBardv1hdOD2+P1r
	EqPHzll32T02repk89i8pN7jyokmVo++LasYPbZfm8fssXH7EyaPz5vkAjijuGxSUnMyy1KL
	9O0SuDIOPU8r2MtS8ezyZKYGxgPMXYycHBICJhJtb5+xQdhiEhfurQeyuTiEBJYyShybvpsd
	JCEk8JlRYu8KHRCbV0BL4vqBy2DNLAKqEmuOHWABsdkE1CQ+NzwCG8QPVLOm6TpQnINDVCBC
	4vEFIYhWQYkfk++BlYsIKEu0br7HDrKLWeAfk0TTst2sIAlhAVeJLeeuMkMcMY9R4veri2Ad
	nAI6Ep3H5oAtZhZQl5g0bxGULS+xec1b5gmMgrOQLJmFpGwWkrIFjMyrGEVTS5MLipPScw31
	ihNzi0vz0vWS83M3MUJi6csOxsXHrA4xCnAwKvHwMsw+GizEmlhWXJl7iFGCg1lJhNfB/1iw
	EG9KYmVValF+fFFpTmrxIUYmDk6pBsby2EOnmLT3G3nNCbkSZ8gbdi/gTGbZhhntLxjnb0t1
	PRvrfX3Wcj+2vI5NhTNuLFN2U72Znsrf9jbu/xtuKdb2ipeXPUtuLRDd2sge4TrpyIUnNdFb
	fp9SV0l5G5hZ/EZ+2k8hDlWOO0sdNsxgvzrHg1kxXXZx+OUt39I14l4s9/jWU9vlz6nEUpyR
	aKjFXFScCAD6CoEegwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.07.2014 12:24, Paul Bolle wrote:
> On Fri, 2014-07-04 at 19:48 +0200, Tomasz Figa wrote:

[snip]

>> -config S5P_GPIO_DRVSTR
>> -	bool
>> -	help
>> -	  Internal configuration to get and set correct GPIO driver strength
>> -	  helper
>> -
> 
> This one is used (as a macro) in drivers/gpio/gpio-samsung.c. Is a patch
> that touches that macro queued somewhere?

The code you mention should be removed as well as it's no longer needed.
Will include in a follow-up series. Thanks for reporting this and
remaining missed parts.

Best regards,
Tomasz
