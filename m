Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753949AbaA0RSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:18:42 -0500
Received: from mailout3.w2.samsung.com ([211.189.100.13]:30932 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473AbaA0RSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:18:40 -0500
X-AuditID: cbfec37a-b7ef66d000004f2b-42-52e694efead5
Message-id: <52E694E5.6080808@samsung.com>
Date: Mon, 27 Jan 2014 10:18:29 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.4 00/12] 3.4.78-stable review
References: <20140126030451.934281002@linuxfoundation.org>
In-reply-to: <20140126030451.934281002@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.3]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrELMWRmVeSWpSXmKPExsVy+t9hX933U54FGax9oGAxZ/0aNovmxevZ
	LC7vmsNm8fWng8WCjY8YLR71vWV3YPPYOesuu8eJGb9ZPPbPXcPu8XmTXABLFJdNSmpOZllq
	kb5dAlfGpr6bLAVH2SuatjSyNTD+Ze1i5OCQEDCRuPrTqouRE8gUk7hwbz1bFyMXh5DAMkaJ
	bXvmsoEkhAR6mSRmXkqESGxglFjR0swMkuAV0JL4uGEdC8ggFgFViQWP2EHCbALqEp9f72CH
	6JWTaFqyGqxcVCBC4tXZiSwQrYISPybfA7NFBIIl1n5dyAgyn1lgBaPE8Zcv2UBmCgsYS/zr
	yYKYYyXR19IDVs8pYC1x+stmsNuYgeyVk7YxQtjyEpvXvGWGqFeW+HP5FBPEYwoS6y8cZp3A
	KDILyepZSNpnIWlfwMi8ilGstDi5oDgpPbXCUK84Mbe4NC9dLzk/dxMjJF6qdjDe+WpziFGA
	g1GJh/dB97MgIdbEsuLK3EOMEhzMSiK8t0BCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGFm3b83c
	67Tj2V6OzAlT5rtPWLuIYYHh66eB7Pn1jDw/0+2jRX6t0xI0qnTXm7LuPYv45J1f9d/Ov3o2
	VS1gqXRf/VuhpJUPYqw/KIdrXZNKm/R4bft2h3uvSiYqFW6U4hNsiOzdNb3rtL1Eg+/0C+uY
	pmelpOg+cT6bI+yfx/ar9PLC23u/dSqxFGckGmoxFxUnAgAvajCGdQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2014 08:05 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.78 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue Jan 28 03:04:41 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.78-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patch testing - passed
Compile testing - passed
Boot testing - passed
dmesg regression testing - passed - no regressions in emerg, crit, 
alert, err are clean. No regressions in warn.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
