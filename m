Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756980AbaDVPsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:48:36 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:35681 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756904AbaDVPsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:48:32 -0400
X-AuditID: cbfec37a-b7fd76d000006048-fb-53568f4e5fd2
Message-id: <53568F4C.2080800@samsung.com>
Date: Tue, 22 Apr 2014 09:48:28 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.13 00/32] 3.13.11-stable review
References: <20140421021133.865086647@linuxfoundation.org>
In-reply-to: <20140421021133.865086647@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.4]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hX13//rBgg9fHmS3mrF/DZtG8eD2b
	xeVdc9gsniw8w2Qx9dQEFosFGx8xWjzqe8vuwO6xc9Zddo8TM36zeOyfuwbI/d7A7vF5k1wA
	axSXTUpqTmZZapG+XQJXxtvXz1gLOjgq1m3YxNrAuImti5GTQ0LAROLuzdesELaYxIV764Hi
	XBxCAssYJR5d2cYK4fQySXxa+BrK2cAo0ftwGlgLr4CWxI7WiUwgNouAqsSSHc+YQWw2AXWJ
	z693sIPYQgJyEk1LVoPFRQUiJF6dncgC0Sso8WPyPTBbRCBYYu3XhYwgC5gFVjFKXL+8HOw+
	YQFTibf/O9kgBllJ3O2cDLSMg4NTwFri7cVQkDAzkLly0jZGCFteYvOat8wQ5coSfy6fYoJ4
	TUFixY03LBMYRWYhWT0LSfssJO0LGJlXMYqVFicXFCelp1YY6hUn5haX5qXrJefnbmKExFLV
	DsY7X20OMQpwMCrx8EoYhAYLsSaWFVfmHmKU4GBWEuHdmxwWLMSbklhZlVqUH19UmpNafIiR
	iYNTqoHR6mDvPb7UWu/F80yObH8+8eOpx4yurt89yhrniYjzrljx5evpbymGadFXl8eqh9nx
	XHDoy7nWzCBb8iHhu9v1Eim2h6fOPnv8al65f8H7b19f3GVaKex7eP9DjlWCz5Svv+m+XF55
	5az/guQ3226H+57j4/t+wThHdpsHW4aDi3WeSdPGvXGflViKMxINtZiLihMBG+V06YMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2014 08:13 PM, Greg Kroah-Hartman wrote:
> ----------------
>
> Note, this is the LAST 3.13.y kernel I will be releasing.  It will be
> end-of-life after this release, please move to 3.14.y at this time.
>
> ----------------
>
> This is the start of the stable review cycle for the 3.13.11 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Apr 23 02:10:46 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.11-rc1.gz
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
