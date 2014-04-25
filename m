Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614AbaDYRDZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 13:03:25 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:32865 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821AbaDYRDW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 13:03:22 -0400
X-AuditID: cbfec37d-b7f966d000005e7e-a9-535a955a9f6e
Message-id: <535A9557.4040805@samsung.com>
Date: Fri, 25 Apr 2014 11:03:19 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.10 00/23] 3.10.38-stable review
References: <20140424214825.933835556@linuxfoundation.org>
In-reply-to: <20140424214825.933835556@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.8]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrLLMWRmVeSWpSXmKPExsVy+t9hX92oqVHBBlu6eSzmrF/DZtG8eD2b
	xeVdc9gsniw8w2Qx9dQEFosFGx8xWjzqe8vuwO6xc9Zddo8TM36zeOyfuwbI/d7A7vF5k1wA
	axSXTUpqTmZZapG+XQJXxu4zi5gLtrBVXP1wm6mBsYe1i5GTQ0LAROJE02N2CFtM4sK99Wxd
	jFwcQgLLGCV62/rAEkICvUwS21ocIBIbGCX2ts8HSnBw8ApoSRz+lw5SwyKgKjHhRD/YUDYB
	dYnPr3dA9cpJNC1ZzQxiiwpESNxrPAxWwysgKPFj8j0WEFtEIFhi7deFjCDzmQVWMUpcv7yc
	DWS+sICpxIqVURBzrCRedP0Bm8kpYC2x/OYZsDnMQPbKSdsYIWx5ic1r3jJD1CtL/Ll8iglk
	jISAgsTXHocJjCKzkGyehaR7FpLuBYzMqxjFSouTC4qT0lMrTPSKE3OLS/PS9ZLzczcxQqKo
	dgfj/a82hxgFOBiVeHh35EQFC7EmlhVX5h5ilOBgVhLh5egBCvGmJFZWpRblxxeV5qQWH2Jk
	4uCUamB0Y5TgP/B4urk7B+tSsRdG0em5n2Z9Db7YJ2I2Y9Iq4++LdvYUGKaovw9IutK0sWMF
	n4Sz586w0hWGNxewn9fas6Xh5rSP916ZOqa0M881SDpeMbun9s8Zn1uPT0jJymWafHY6Nelx
	lLjJ3bROkVUfJ+hv27dptdCq8PrZ9iW1bSxLvk0XPbFeiaU4I9FQi7moOBEAMRtPUIACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 03:48 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.38 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Apr 26 21:48:09 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.38-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted. No dmesg regressions.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
