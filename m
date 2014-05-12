Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaELVyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:54:50 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:50723 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaELVys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:54:48 -0400
X-AuditID: cbfec37b-b7fc26d0000070ab-5e-53714327e14f
Message-id: <53714324.9@samsung.com>
Date: Mon, 12 May 2014 15:54:44 -0600
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
Subject: Re: [PATCH 3.4 00/22] 3.4.90-stable review
References: <20140511192103.733723493@linuxfoundation.org>
In-reply-to: <20140511192103.733723493@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.3]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9hP11158Jgg3OXRC3mrF/DZtG8eD2b
	xeVdc9gsniw8w2Qx9dQEFosFGx8xWjzqe8vuwO6xc9Zddo8TM36zeOyfuwbI/d7A7vF5k1wA
	axSXTUpqTmZZapG+XQJXxvYvV1kKDrNVrH+V3cA4k7WLkZNDQsBE4vzxLywQtpjEhXvr2boY
	uTiEBJYxShzsnMIO4fQySUy7/YUJwtnAKDGx/RM7SAuvgIpEb98FMJtFQFXi9JTLTCA2m4C6
	xOfXO8DiQgJyEk1LVjN3MXJwiApESDy+IATRKijxY/I9sM0iAsESa78uZASZzyywilHi+uXl
	bCAJYQFjiZmP54D1CglYSTyZUwgS5hSwllj/5xYziM0sYCbxqGUdlC0vsXnNW2aItcoSfy6f
	YoL4TEFi/YXDrBMYRWYhWT0LSfssJO0LGJlXMYqVFicXFCelp1YY6RUn5haX5qXrJefnbmKE
	xFH1Dsa7X20OMQpwMCrx8P58URAsxJpYVlyZe4hRgoNZSYTXwakwWIg3JbGyKrUoP76oNCe1
	+BAjEwenVAPj9A9ukr8WL5aYzJtR4baGpS5uYr7zzfVVr5suSE0xvctY4mroNnG+ccHC31sy
	hd52cO3NVZhxu+bcrjxm2RAXA9Xr79k2JUfUWrYU9v/jjHgvdOUzy6rp3cc/JZxetObW9q8l
	ga4NTPpPjlscXif1vSHw2qlIxzWrtu02PSu6oejR11qutPLdSizFGYmGWsxFxYkA8jdv+IEC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 01:21 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.90 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue May 13 19:20:50 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.90-rc1.gz
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
