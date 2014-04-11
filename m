Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485AbaDKXpk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 19:45:40 -0400
Received: from mailout2.w2.samsung.com ([211.189.100.12]:21776 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaDKXpi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 19:45:38 -0400
X-AuditID: cbfec37a-b7fc06d00000555a-66-53487ea03d2c
Message-id: <53487E9E.9090304@samsung.com>
Date: Fri, 11 Apr 2014 17:45:34 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.10 00/41] 3.10.37-stable review
References: <20140411160932.865173041@linuxfoundation.org>
In-reply-to: <20140411160932.865173041@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.215]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9hP90FdR7BBqu6LCzmrF/DZtG8eD2b
	xeVdc9gsniw8w2Qx9dQEFosFGx8xWjzqe8vuwO6xc9Zddo8TM36zeOyfuwbI/d7A7vF5k1wA
	axSXTUpqTmZZapG+XQJXxrsdy1kKTrJVPJ/3jb2BcTZrFyMnh4SAicTJjQ+YIGwxiQv31rOB
	2EICyxgl2s5VdDFyAdm9TBLnVt1mhHC2MUq0ft7D0sXIwcEroCWx9Ws0SAOLgKrE/vWfwIay
	CahLfH69gx1ikJxE05LVzCC2qECExKuzE1lAbF4BQYkfk++B2SICwRJrvy4Em88ssIpR4vrl
	5Wwg84UFTCVO74mEmGMl0T7jGiOIzSlgLTFlwmSwmcwCZhKPWtZB2fISm9e8ZYaoV5b4c/kU
	1GPKEncudzNOYBSZhWT1LCTts5C0L2BkXsUoVlqcXFCclJ5aYahXnJhbXJqXrpecn7uJERJH
	VTsY73y1OcQowMGoxMP7QcMjWIg1say4MvcQowQHs5II79ssoBBvSmJlVWpRfnxRaU5q8SFG
	Jg5OqQbGQKet+wwyDjFfWXj1h265uPnK/Q6v3y8WP1TaGs1xRdPi8xZ14x+5ti96nb14TDgr
	ORgOOlU7hcc3LvTkenpcTkzni5DmpfRlEXXveKobRc6WMO1ps1h97c+EyurEB+t37GT5oGii
	E7o+sM1og9HF6I/1i1v+83rPuiLpvOkro19+5rMX+tlKLMUZiYZazEXFiQBdaWkPgQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 10:09 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.37 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Apr 13 16:09:00 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.37-rc1.gz
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
