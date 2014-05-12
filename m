Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751566AbaELVxs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:53:48 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:13953 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033AbaELVxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:53:46 -0400
X-AuditID: cbfec37d-b7f966d000005e7e-2b-537142e8a461
Message-id: <537142E6.5080408@samsung.com>
Date: Mon, 12 May 2014 15:53:42 -0600
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
Subject: Re: [PATCH 3.14 00/83] 3.14.4-stable review
References: <20140511191907.024339448@linuxfoundation.org>
In-reply-to: <20140511191907.024339448@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.3]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9hX90XToXBBs/e2FjMWb+GzaJ58Xo2
	i8u75rBZPFl4hsli6qkJLBYLNj5itHjU95bdgd1j56y77B4nZvxm8dg/dw2Q+72B3ePzJrkA
	1igum5TUnMyy1CJ9uwSujLcb+pkLjrNVHLn8lrmBcSZrFyMnh4SAicS0x6cYIWwxiQv31rN1
	MXJxCAksY5R49vUGM4TTyyQxe3UvWJWQwAZGiWM7mboYOTh4BbQkFu3OBQmzCKhKPN9ykR3E
	ZhNQl/j8egc7RLmcRNOS1cwg5aICERKPLwiBhHkFBCV+TL7HAmKLCARLrP26kBFkFbPAKkaJ
	65eXs4EkhIGO293SADXHSqLj7kSwozkFrCUmbv8LZjMLmEk8alnHDGHLS2xe85YZol5Z4s/l
	U0wQjylIrL9wmHUCo8gsJLtnIWmfhaR9ASPzKkax0uLkguKk9NQKE73ixNzi0rx0veT83E2M
	kDiq3cF4/6vNIUYBDkYlHt6EnwXBQqyJZcWVuYcYJTiYlUR45TQLg4V4UxIrq1KL8uOLSnNS
	iw8xMnFwSjUwnn9rE/S/75/7pzuJ/6ZYPPN9xszvslJ2ytF1bZbuz/SLK1YucfrIum3eTJWF
	v77eLZ26vHT9c37lXzcU3h4Oayw/nMIWmW91/rm8hPMOU92PUusXFHPy7L56NdBR4058TODe
	Y8nGAkXNf5KDHxx+GfZzSe6LjbzBXe63U9RUzpSHlC4oXLTjjhJLcUaioRZzUXEiACuRUSyB	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 01:19 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.4 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue May 13 19:18:44 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.4-rc1.gz
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
