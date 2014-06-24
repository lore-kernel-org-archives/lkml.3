Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275AbaFXTte (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:49:34 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:60194 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbaFXTtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:49:33 -0400
X-AuditID: cbfec37d-b7fbf6d000005712-ab-53a9d64b0523
Message-id: <53A9D649.7010504@samsung.com>
Date: Tue, 24 Jun 2014 13:49:29 -0600
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
Subject: Re: [PATCH 3.14 00/68] 3.14.9-stable review
References: <20140624154723.907894814@linuxfoundation.org>
In-reply-to: <20140624154723.907894814@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.222]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hP13vayuDDWYv0LOYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGZM3fWEtOMJWcWzHQuYGxhmsXYycHBICJhIP/2xkgbDFJC7cW8/W
	xcjFISSwjFHiesMTRginl0ni3sHHUM42Romnn58zgbTwCmhJ7Ox7ANbOIqAq8envDmYQm01A
	XeLz6x3sILaQgJxE05LVYHFRgQiJA33PWCF6BSV+TL4H1isiECyx9utCsAXMAquAVl9ezgaS
	EAa6b+rfqywQg6wk/kz4DTSIg4NTwFpix+kkkDCzgJnEo5Z1zBC2vMTmNW+ZIcqVJf5cPsUE
	8ZqyxJMp5xknMIrMQrJ6FpL2WUjaFzAyr2IUKy1OLihOSk+tMNErTswtLs1L10vOz93ECIml
	2h2M97/aHGIU4GBU4uGtmLkyWIg1say4MvcQowQHs5IIr2k3UIg3JbGyKrUoP76oNCe1+BAj
	EwenVANjrfvVtsKHRr233tY3uS2/xZx8IbrgZpaK38Njpnf2zGfVmMsnqLGnJoBPei3T4qs7
	Digubn/WH+EycRNLiEWe2MlT/B3FnZxmCVE3clVXnc/c6qWRWZU/KedqhODNn+xnT+zNLPx9
	v8zYO3H7WdE779uVzed4JunKrJFtC/n/4DmvmOUiP2MlluKMREMt5qLiRADwhBMDgwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 09:50 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.9 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jun 26 15:47:04 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.9-rc1.gz
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
