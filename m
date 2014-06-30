Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755818AbaF3QRQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:17:16 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:38352 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755715AbaF3QRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:17:13 -0400
X-AuditID: cbfec37a-b7f206d000005572-ee-53b18d87a9f5
Message-id: <53B18D84.6000805@samsung.com>
Date: Mon, 30 Jun 2014 10:17:08 -0600
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
Subject: Re: [PATCH 3.4 00/43] 3.4.96-stable review
References: <20140628174449.788784511@linuxfoundation.org>
In-reply-to: <20140628174449.788784511@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.211]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9hP9323o3BBrOmalvMWb+GzaJ58Xo2
	i8u75rBZPFl4hsli6qkJLBYLNj5itHjU95bdgd1j56y77B4nZvxm8dg/dw2Q+72B3ePzJrkA
	1igum5TUnMyy1CJ9uwSujF/rZjMVHGOrWLXiIksD4wzWLkZODgkBE4kv3T1QtpjEhXvr2boY
	uTiEBJYxSpzrnQDl9DJJvH+ykx3C2cYocWLPKyaQFl4BLYkdL3cygtgsAqoSzZ/3MYPYbALq
	Ep9f72AHsYUE5CSalqwGi4sKREgc6HvGCtErKPFj8j0WEFtEIFhi7deFjCALmAVWMUpcv7yc
	DSQhLGAscezBETaIQVYSEyd+AFvMKWAtMXt3O9hQZiB75aRtjBC2vMTmNW+ZIeqVJf5cPsUE
	8ZuyxPOdO9knMIrMQrJ7FpL2WUjaFzAyr2IUKy1OLihOSk+tMNQrTswtLs1L10vOz93ECImm
	qh2Md77aHGIU4GBU4uFVaNgYLMSaWFZcmXuIUYKDWUmE96YPUIg3JbGyKrUoP76oNCe1+BAj
	EwenVAMj25TPkrJ7nSV+BkS8ydh9JmLZjUn9c+7NOXRoS+dh7tR3nKd9fr+25rQN0GeesuVh
	+IwLEQEshr+YOFbUsZ/Z9iTmo8b6fguJS0HXI3f1dAUceOkff3blkX37Sh+df3ZCg9nCe1d1
	3+xL4nvT/iUqLY3oznX4whHUeGTL//qH8Ub7mvVEgn5ZKrEUZyQaajEXFScCAKEGfumEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2014 11:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.96 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Jun 30 17:44:34 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.96-rc1.gz
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
