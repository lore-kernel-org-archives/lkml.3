Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbaBTADd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:03:33 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:36969 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbaBTADb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:03:31 -0500
X-AuditID: cbfec37a-b7ef66d000004f2b-e7-530546513c27
Message-id: <53054648.3090400@samsung.com>
Date: Wed, 19 Feb 2014 17:03:20 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, lizefan@huawei.com,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.4 00/24] 3.4.81-stable review
References: <20140218224550.221535225@linuxfoundation.org>
In-reply-to: <20140218224550.221535225@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.5]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDLMWRmVeSWpSXmKPExsVy+t9hX91AN9Zgg30T5SzmrF/DZtG8eD2b
	xeVdc9gsJnX0slt8/elgsWDjI0aLR31v2R3YPXbOusvu0XLkLavHiRm/WTz2z13D7vF5k1wA
	axSXTUpqTmZZapG+XQJXxu5Tj1gLXrFXvLqv28A4k62LkZNDQsBEYuq9tywQtpjEhXvrweJC
	AssYJR5OjoKwe5kkXi8T6mLkArI3MErM/r+evYuRg4NXQEui4T4HSA2LgKrEzXuXweawCahL
	fH69gx2iV06iaclqZhBbVCBC4tXZiWA1vAKCEj8m3wOzRQSCJdZ+XcgIMp9ZYA+jxINrm8ES
	wgLGEsv7P7JCDLKSaGreAhbnFLCWmP/jBdihzED2yknbGCFseYnNa94yQ9QrS/y5fIoJ4jEF
	iRsLl7FOYBSZhWT3LCTts5C0L2BkXsUoVlqcXFCclJ5aYahXnJhbXJqXrpecn7uJERJDVTsY
	73y1OcQowMGoxMMbcZ0lWIg1say4MvcQowQHs5IIbzQba7AQb0piZVVqUX58UWlOavEhRiYO
	TqkGxqg7L7bq/lLyPWTeyrFhzf3XFUZNT6oM3z84cCd6srlSK1PRi5/zZU/7ha5bYmegfapp
	qnLUgkMBH6OUWnn4SvVCSzZvVuoKy5qss9vp6FPOi9oPEncXnLQwDrnhV++9K++FwL0l18wM
	5BPfsuhvqo/5aZNy6t+vROYNT46uPnCp7jXjwQfO3kosxRmJhlrMRcWJAKy2sNl/AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2014 03:46 PM, Greg Kroah-Hartman wrote:
> Many thanks to Li Zefan for digging up a bunch of these patches, that
> work is much appreciated.
>
> This is the start of the stable review cycle for the 3.4.81 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Feb 20 22:45:38 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.81-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compile tests and boot tests passed. No dmesg regressions: emerg, crit, 
alert, err are clean. No regressions in warn.

-- Shuah


-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
