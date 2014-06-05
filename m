Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752AbaFER4V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 13:56:21 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:33903 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaFER4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 13:56:19 -0400
X-AuditID: cbfec37a-b7f206d000005572-bf-5390af4261a2
Message-id: <5390AF40.4030804@samsung.com>
Date: Thu, 05 Jun 2014 11:56:16 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.4 000/214] 3.4.92-stable review
References: <20140605041639.638675216@linuxfoundation.org>
In-reply-to: <20140605041639.638675216@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.6]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9hP12n9ROCDU7MkbaYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGbualjAXnGSr6P10nb2BcTZrFyMnh4SAicStR+eZIWwxiQv31rN1
	MXJxCAksY5To7X7PCOH0Mkl0vpnKDOFsYJT48mwLO0gLr4CWxLMNy5i6GDk4WARUJY68LgQJ
	swmoS3x+vQOsREhATqJpyWpmkBJRgQiJxxeEIDoFJX5MvscCYosIBEus/boQbBezwCpGieuX
	l7OBJIQFTCW+fl3GBjHHSmLTqu9gl3IKWEuseLkFrJlZwEziUcs6ZghbXmLzmrfMEPXKEn8u
	n2KC+ExB4tHVVvYJjCKzkOyehaR9FpL2BYzMqxjFSouTC4qT0lMrDPWKE3OLS/PS9ZLzczcx
	QiKpagfjna82hxgFOBiVeHgD+icEC7EmlhVX5h5ilOBgVhLh5VkBFOJNSaysSi3Kjy8qzUkt
	PsTIxMEp1cDYGn/l66MkNZ253iv690SdkHyp8oj/794ULWU35yL93Kua7FtNG99tyJxSd3XW
	/mATv6Vnntv6L/Y8EFzkt6PGbI4hm8XG5bVHspSiQu6f59v4WOM680SpEzuv7bJlfXDN6FbM
	oux/BhdTpjIxNWQ4rfS48nCd6dfcWzkibxKv5iTseeLT22qpxFKckWioxVxUnAgAlfSb9IIC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 10:16 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.92 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Jun  7 04:15:47 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.92-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my test system with no dmesg regressions.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
