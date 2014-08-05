Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbaHEXI0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 19:08:26 -0400
Received: from mailout3.w2.samsung.com ([211.189.100.13]:32343 "EHLO
	usmailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026AbaHEXIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 19:08:24 -0400
X-AuditID: cbfec37b-b7f826d000001cb2-4b-53e163e6ba7d
Message-id: <53E163E4.4050608@samsung.com>
Date: Tue, 05 Aug 2014 17:08:20 -0600
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
Subject: Re: [PATCH 3.10 00/27] 3.10.52-stable review
References: <20140805181344.268039690@linuxfoundation.org>
In-reply-to: <20140805181344.268039690@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.6]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9hP93nyQ+DDeZfY7OYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGddnTmUseMxWcf3+FcYGxo2sXYycHBICJhKdSw6zQ9hiEhfurWfr
	YuTiEBJYxiix7PAWRginl0liwpKJTBDOBkaJ4zdnM4G08ApoSVzasRSonYODRUBVorexBCTM
	JqAu8fn1DrCpQgJyEk1LVjOD2KICERIH+p6xQrQKSvyYfI8FxBYRCJZY+3Uh2DJmgVWMEtcv
	L2cDSQgLmEosv3sMbL6QgJXE7RUcIGFOAWuJc83tYCcwA9krJ21jhLDlJTavecsMsVdZ4s/l
	U0wQnylIPLrayj6BUWQWktWzkLTPQtK+gJF5FaNYaXFyQXFSemqFkV5xYm5xaV66XnJ+7iZG
	SCRV72C8+9XmEKMAB6MSD2+G6cNgIdbEsuLK3EOMEhzMSiK8W+KBQrwpiZVVqUX58UWlOanF
	hxiZODilGhjjhfhbk5gnMdo8PWopNLX10uSuf/XrIievelfWKXj9ziOuQM+PtsK5z9a86+c5
	KjNfz7db/6/gvKtvVQKO/2NQez+ZLamKUai04ntEl7JD0akHCnZ31h7bOvnPzqWTtDsPnoy4
	k2j6duE9l6mFB9sWZGyQmrR101KuM6rfXj34zeYhrrHFmv+iEktxRqKhFnNRcSIAQV0ySIIC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2014 12:13 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.52 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Aug  7 18:13:37 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.52-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my test system. No dmesg regressions
compared to previous 3.10.51

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
