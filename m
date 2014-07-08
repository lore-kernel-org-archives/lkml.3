Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420AbaGHTaO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 15:30:14 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:8827 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbaGHTaI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 15:30:08 -0400
X-AuditID: cbfec37a-b7f206d000005572-d2-53bc46be4f89
Message-id: <53BC46BB.5090509@samsung.com>
Date: Tue, 08 Jul 2014 13:30:03 -0600
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
Subject: Re: [PATCH 3.4 00/44] 3.4.98-stable review
References: <20140707235858.652771077@linuxfoundation.org>
In-reply-to: <20140707235858.652771077@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.209]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9hP919bnuCDWbOULWYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGc9nbGMsOMZWcWfvfaYGxumsXYycHBICJhInL79hgrDFJC7cW8/W
	xcjFISSwjFHi37EfTBBOL5PE7GMroTLbGCWaV25hBGnhFdCSWPz9DpjNIqAq0Xn/IdgoNgF1
	ic+vd7CD2EICchJNS1Yzg9iiAhESB/qesUL0Ckr8mHyPBcQWEQiWWPt1ISPIAmaBVYwS1y8v
	B9rGwSEsYCxxZp0wxBwriX9PzzCChDkFrCX+XK8HCTMLmEk8alnHDGHLS2xe85YZolxZ4s/l
	U1CfKUtMbLzNMoFRZBaSzbOQtM9C0r6AkXkVo1hpcXJBcVJ6aoWhXnFibnFpXrpecn7uJkZI
	JFXtYLzz1eYQowAHoxIPryLPnmAh1sSy4srcQ4wSHMxKIrzLBYFCvCmJlVWpRfnxRaU5qcWH
	GJk4OKUaGCUlDpTsC1iecfF9rnn4mkfxxzI1siS4S9d7/D6t2H3IUHyN0TqLpXfsrRQcQ1YL
	6a2yO23GurdXsdVkJ0+7wuKVDd1OwsIzsidWVgRdZw/QyzdVX1vx5NGkK1UBkrybH5fMWBn3
	0mGlc7nrtX8PqxMSm0PjAqKz3nj5ZHTJVLUah8zqum+lxFKckWioxVxUnAgAjNlozoICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/07/2014 06:06 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.98 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jul  9 23:58:50 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.98-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my test system. No demsg regressions.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
