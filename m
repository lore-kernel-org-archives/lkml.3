Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932554AbaGQNYF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 09:24:05 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:33413 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaGQNYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 09:24:02 -0400
X-AuditID: cbfec37b-b7fbe6d000006742-59-53c7ce7088ea
Message-id: <53C7CE67.5040500@samsung.com>
Date: Thu, 17 Jul 2014 07:23:51 -0600
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
Subject: Re: [PATCH 3.14 00/66] 3.14.13-stable review
References: <20140715231702.156040999@linuxfoundation.org>
In-reply-to: <20140715231702.156040999@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.242]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9hX92Cc8eDDdbv57SYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGTPnPGQtuMRWsfrqJtYGxsWsXYycHBICJhKTH3xlhrDFJC7cW8/W
	xcjFISSwjFFi8fZdUE4vk8SU7bPYIZxtjBKfmnqYQFp4BbQkFp96CjaKRUBV4t/vjWCj2ATU
	JT6/3sEOYgsJyEk0LVkNFhcViJA40PeMFaJXUOLH5HssILaIQLDE2q8LGUEWMAusYpS4fnk5
	G0hCWMBUYtevbcwQg6wkHu35yAhicwpYS3xe9xCshlnATOJRyzpmCFteYvOat1D1yhJ/Lp9i
	gvhNWWLfgzmMExhFZiHZPQtJ+ywk7QsYmVcxipUWJxcUJ6WnVhjpFSfmFpfmpesl5+duYoRE
	U/UOxrtfbQ4xCnAwKvHwKsw4FizEmlhWXJl7iFGCg1lJhHdb1/FgId6UxMqq1KL8+KLSnNTi
	Q4xMHJxSDYxLD+zYO2Vn0MOw2x7XuwQU1DML13ca87ZYJipOO8piucm4/lCrHltkxnU2afk5
	k7cKHH/nUBM61eFoXnR0yKnLJ6/cqPnye+ZdWW7LZM+eQ+/sL51usTe2YP0Y3pdllv1/dvgv
	1WTGredrXOZq3uUJYm/NPivRIDVXbhefTknHKZMI9rasHUosxRmJhlrMRcWJAGv04JiEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2014 05:16 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.13 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jul 17 23:16:50 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.13-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

rc1 and rc2 compiled and booted on my test system. No dmesg regressions.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
