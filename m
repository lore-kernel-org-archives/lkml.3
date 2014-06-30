Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbaF3QRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:17:52 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:38384 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755322AbaF3QRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:17:50 -0400
X-AuditID: cbfec37b-b7fbe6d000006742-43-53b18dad7023
Message-id: <53B18DAB.8050403@samsung.com>
Date: Mon, 30 Jun 2014 10:17:47 -0600
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
Subject: Re: [PATCH 3.10 00/77] 3.10.46-stable review
References: <20140628174521.691276402@linuxfoundation.org>
In-reply-to: <20140628174521.691276402@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.211]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrALMWRmVeSWpSXmKPExsVy+t9hP911vRuDDbYcZraYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGS86TzAWnGCrOLJ1PlMD4yzWLkZODgkBE4nmg7sYIWwxiQv31rN1
	MXJxCAksY5Q4vGUTC4TTyyQx8fs8ZghnG6PE7f/TmUBaeAW0JL5NfM8MYrMIqEr83nyJHcRm
	E1CX+Px6B5gtJCAn0bRkNViNqECExIG+Z6wQvYISPybfYwGxRQSCJdZ+XcgIsoBZYBWjxPXL
	y9lAEsICphK3370HSnAADbKS+Ls+BCTMKWAt8evGfrD5zED2yknbGCFseYnNa94yQ+xVlvhz
	+RQTxGvKEs937mSfwCgyC8nqWUjaZyFpX8DIvIpRrLQ4uaA4KT21wkivODG3uDQvXS85P3cT
	IySWqncw3v1qc4hRgINRiYdXoWFjsBBrYllxZe4hRgkOZiUR3ps+QCHelMTKqtSi/Pii0pzU
	4kOMTBycUg2M7q/fH5PUkNcIk1HjXzyV20fagsvAewZTJ8srk4Z9kmeVVV23WulL8c8olk8/
	1pqaGxj89sSJ9SImVcrv4iRsEgUCZh3vr/SO43z6+c1xfr/AqOYduzO3/nh2/2TKtO9FCf35
	u+cfW220ceHhjPwrF+p6qh8qcIcdNrS0vHiOPesa7+pu9jwlluKMREMt5qLiRADVHRrOgwIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2014 11:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.46 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Jun 30 17:45:02 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.46-rc1.gz
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
