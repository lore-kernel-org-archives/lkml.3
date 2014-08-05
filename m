Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753634AbaHEXHM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:07:12 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:60526 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbaHEXHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:07:05 -0400
X-AuditID: cbfec37a-b7f216d000000635-e7-53e1639795e2
Message-id: <53E16394.7090400@samsung.com>
Date: Tue, 05 Aug 2014 17:07:00 -0600
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
Subject: Re: [PATCH 3.15 00/42] 3.15.9-stable review
References: <20140805181321.018370988@linuxfoundation.org>
In-reply-to: <20140805181321.018370988@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.6]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9hX93pyQ+DDQ6/k7SYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGY2TD7EUPGCrmHpGsYFxHWsXIyeHhICJxLXznxkhbDGJC/fWs4HY
	QgLLGCWaOkO7GLmA7F4miVnLJzFCOBsYJR4eu8QOUsUroCVxcd5WJhCbRUBV4uPsD2A2m4C6
	xOfXO9ghJslJNC1ZzQxiiwpESBzoe8YK0Sso8WPyPRYQW0QgWGLt14VgC5gFVjFKXL+8HOwM
	YaDzJveeZ4UYZCVxfesnsDingLXE0p7FYM3MQPbKSdsYIWx5ic1r3jJD1CtL/Ll8igniNQWJ
	R1db2ScwisxCsnsWkvZZSNoXMDKvYhQrLU4uKE5KT60w1CtOzC0uzUvXS87P3cQIiaSqHYx3
	vtocYhTgYFTi4c0wfRgsxJpYVlyZe4hRgoNZSYR3SzxQiDclsbIqtSg/vqg0J7X4ECMTB6dU
	AyOr9daJB4JrTxlXTjFl14jQ6r+uFPnjooNV4sdzvXH9Oknb79qf2l744avWtZ33173dMv/X
	D6MzUyepOSgpzdtivv/6jFMnrF9UPmzYGcH2VcXynkeQkvC92QkVzWWGup9Pr3ewUTnVz7pl
	xaxr0+4udQ/m4+0Q/sS4jNX3d+VL58c9Ck+KphgpsRRnJBpqMRcVJwIA9D5k2YICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 12:13 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.15.9 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Aug  7 18:13:05 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.15.9-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my test system. No dmesg regressions
compared to previous 3.15.8

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
