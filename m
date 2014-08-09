Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751939AbaHIOnH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 10:43:07 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:14450 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751642AbaHIOnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 10:43:04 -0400
X-AuditID: cbfec37d-b7f676d000000907-38-53e63378067e
Message-id: <53E63375.2060400@samsung.com>
Date: Sat, 09 Aug 2014 08:43:01 -0600
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
Subject: Re: [PATCH 3.16 00/17] 3.16.1-stable review
References: <20140808213457.511493898@linuxfoundation.org>
In-reply-to: <20140808213457.511493898@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.217]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9hX90K42fBBlcncVrMWb+GzaJ58Xo2
	i8u75rBZPFl4hsli6qkJLBYLNj5itHjU95bdgd1j56y77B4nZvxm8dg/dw2Q+72B3ePzJrkA
	1igum5TUnMyy1CJ9uwSujB+XHjIVHGGrWNHwjr2BcQZrFyMHh4SAicTkSa5djJxAppjEhXvr
	2boYuTiEBJYxSjz50sEOkhAS6GWSOLxcCCKxjVGi6+oeJpAEr4CWRNviLywgg1gEVCUm7wkB
	CbMJqEt8fr0DqldOomnJamYQW1QgQuJA3zNWiFZBiR+T77GA2CICwRJrvy5kBJnPLLCKUeL6
	5eVsIAlhoOOa/h5mhRhkJfH88TKwBk4Ba4nWDy/AapiB7JWTtjFC2PISm9e8ZYaoV5b4c/kU
	E8RnyhL3Jx9kmcAoMgvJ7llI2mchaV/AyLyKUay0OLmgOCk9tcJErzgxt7g0L10vOT93EyMk
	jmp3MN7/anOIUYCDUYmHd4XN02Ah1sSy4srcQ4wSHMxKIrwn1J8FC/GmJFZWpRblxxeV5qQW
	H2Jk4uCUamCc26Z7+1/ilp8nQz6GXlOr2261wil6XQZ7+cNU9qAlJj+kTc5e3v918VWT5zkV
	rzM5J54/e0nGs1V5WYqgYmzlp3R3Ccm1dpWTdXxFfSccyMt9HL2kh5snSfpB/5nb09ZGh516
	5pFs+nOD47T3AYceGDzK89S52ql/bcE+VYE5U11d+17Hlf1QYinOSDTUYi4qTgQAgJTya4EC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 03:35 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.16.1 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Aug 10 21:34:49 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.16.1-rc1.gz
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
