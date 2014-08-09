Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaHIOlf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2014 10:41:35 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:14417 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751125AbaHIOld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2014 10:41:33 -0400
X-AuditID: cbfec37b-b7f826d000001cb2-11-53e6331b2679
Message-id: <53E63319.8030701@samsung.com>
Date: Sat, 09 Aug 2014 08:41:29 -0600
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
Subject: Re: [PATCH 3.14 00/39] 3.14.17-stable review
References: <20140808213354.980430919@linuxfoundation.org>
In-reply-to: <20140808213354.980430919@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.217]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9hX11p42fBBu86DCzmrF/DZtG8eD2b
	xeVdc9gsniw8w2Qx9dQEFosFGx8xWjzqe8vuwO6xc9Zddo8TM36zeOyfuwbI/d7A7vF5k1wA
	axSXTUpqTmZZapG+XQJXxt3JJ5gKjrFVzJ27jrmBcRZrFyMnh4SAicSt1a2MELaYxIV769m6
	GLk4hASWMUpc+XCHGcLpZZJY/vYQE4SzjVHi5eKjYO28AloS74/fYQKxWQRUJY4s2QZmswmo
	S3x+vYMdxBYSkJNoWrKaGcQWFYiQOND3DKpXUOLH5HssILaIQLDE2q8LGUEWMAusYpS4fnk5
	G0hCWMBU4sCzfiaIQVYSL7YuA2vmFLCW6Jh9EGwoM5C9ctI2RghbXmLzmrfMEPXKEn8un2KC
	+E1Z4v7kgywTGEVmIdk9C0n7LCTtCxiZVzGKlRYnFxQnpadWGOkVJ+YWl+al6yXn525ihERT
	9Q7Gu19tDjEKcDAq8fAmeDwNFmJNLCuuzD3EKMHBrCTCe0L9WbAQb0piZVVqUX58UWlOavEh
	RiYOTqkGRs/vAjHVb99vDZp/2+vnLo19K/b3SLctsVdIWRvIfz9VhL3thHnGswxXr1mFzZ8S
	n50KY+vNmHLMoGbutYZPL/0++t/i8OnN/q4huaK6IFk/afY2K3nne45lEwSZ8j4Gzs8vvx33
	qC9tWfCixe/fiAkxmxneuX7f4K7sNJFLy37cWME2yWHyDyWW4oxEQy3mouJEAM2XpEWEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 03:34 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.17 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Aug 10 21:33:45 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.17-rc1.gz
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
