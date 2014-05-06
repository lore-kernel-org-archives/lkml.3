Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757129AbaEFOAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 10:00:30 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:61122 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaEFOA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 10:00:28 -0400
X-AuditID: cbfec37a-b7fd76d000006048-11-5368eafa32c1
Message-id: <5368EAF0.5010800@samsung.com>
Date: Tue, 06 May 2014 08:00:16 -0600
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
Subject: Re: [PATCH 3.4 00/43] 3.4.89-stable review
References: <20140504154224.211508175@linuxfoundation.org>
In-reply-to: <20140504154224.211508175@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.247]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9hX91frzKCDfbPMLCYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGTvefGErOM5WsWzZS6YGxhmsXYycHBICJhLrXx9khLDFJC7cW8/W
	xcjFISSwjFFi++xVUE4vk8TpjplsIFVCAtsYJc5cKehi5ODgFdCSmL/OHSTMIqAq8f/RE2YQ
	m01AXeLz6x3sEOVyEk1LVjODlIsKREg8viAEEuYVEJT4MfkeC4gtIhAssfbrQkaQVcwCqxgl
	rl9eDrZKWMBYonXWLGaIOVYSNxdMZwKxOQWsJT42XQJ7gFnATOJRyzpmCFteYvOat1D1yhJ/
	Lp9ignhMWWLjnttsExhFZiHZPQtJ+ywk7QsYmVcxipUWJxcUJ6WnVhjqFSfmFpfmpesl5+du
	YoTEUdUOxjtfbQ4xCnAwKvHwil9PDxZiTSwrrsw9xCjBwawkwit+PyNYiDclsbIqtSg/vqg0
	J7X4ECMTB6dUA6PVGYaLv9465RysPPd9iQivZfT1672sCcev89f0ypvbKPSWJu59G6r2wGD2
	kc1Hjq5cNfvGkxOL58dVvlLb3Xh7yqe3xR9nasY+Of7dbet2P+eVAlPZ10bKbo0s4ji8t2qW
	8uLqObfSSxNWLS1dwfSTW7L8Zf30q9KHXW2rJnrpPPO7suCK1uNQJZbijERDLeai4kQAAVZs
	LYECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/2014 09:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.89 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue May  6 15:42:07 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.89-rc1.gz
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
