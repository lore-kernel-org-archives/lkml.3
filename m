Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757736AbaEFOze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 10:55:34 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:63914 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754404AbaEFOzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 10:55:31 -0400
X-AuditID: cbfec37c-b7f796d000005f99-1e-5368f7e24172
Message-id: <5368F7DF.3040108@samsung.com>
Date: Tue, 06 May 2014 08:55:27 -0600
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
Subject: Re: [PATCH 3.10 00/86] 3.10.39-stable review
References: <20140504154140.444932005@linuxfoundation.org>
In-reply-to: <20140504154140.444932005@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.247]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t9hX91H3zOCDSZd0LOYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGXN6pjMVnGar6Ds9l7mBcRZrFyMHh4SAicT0DrcuRk4gU0ziwr31
	bCC2kMAyRomuT1pdjFxAdi+TxLvtv9ghEtsYJeZ9cQGxeQW0JPq79zOD2CwCqhIzW+aBNbMJ
	qEt8fr0Dql5OomnJamaQXaICERKPLwhBtApK/Jh8jwXEFhEIllj7dSEjyC5mgVWMEtcvLweb
	IyxgKtEwCWavlcTLXRPA4pwC1hIz/h9mArGZBcwkHrWsY4aw5SU2r3nLDFGvLPHn8ikmiMeU
	JTbuuc02gVFkFpLds5C0z0LSvoCReRWjWGlxckFxUnpqhbFecWJucWleul5yfu4mRkgU1exg
	vPfV5hCjAAejEg+vwpr0YCHWxLLiytxDjBIczEoivA1fMoKFeFMSK6tSi/Lji0pzUosPMTJx
	cEo1MAYufsOS8G7b8uM1tzwZd12VuL/9+KUYF02t94q513lnNm9PeLG+wWD+yw/LVtlKL7c5
	djCTtVYipPtNe1BKu2RkNqdEyItXOqfuuL+aKO8jIfZcQutnyCvHWVxvLO8rzltYfPxvV2tW
	U+NabSXO/kyp+SsW3ZqtOeGQsHfN25WxH4yn61xfXqbEUpyRaKjFXFScCADEL/pSgAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2014 09:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.39 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue May  6 15:41:13 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.39-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>


Compiled and booted on my test systems. No dmesg regressions.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
