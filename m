Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815AbaDKXqQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 19:46:16 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:58602 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645AbaDKXqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 19:46:15 -0400
X-AuditID: cbfec37d-b7f616d0000059df-d7-53487ec61ffa
Message-id: <53487EC2.3000001@samsung.com>
Date: Fri, 11 Apr 2014 17:46:10 -0600
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
Subject: Re: [PATCH 3.13 00/65] 3.13.10-stable review
References: <20140411160957.714773410@linuxfoundation.org>
In-reply-to: <20140411160957.714773410@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.215]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9hP91jdR7BBvvucFrMWb+GzaJ58Xo2
	i8u75rBZPFl4hsli6qkJLBYLNj5itHjU95bdgd1j56y77B4nZvxm8dg/dw2Q+72B3ePzJrkA
	1igum5TUnMyy1CJ9uwSujEmnP7MWtHBW3Pj/lK2BcRJ7FyMnh4SAicSalZtYIWwxiQv31rN1
	MXJxCAksY5Q4fWANO4TTyyQx78RMVghnG6PExdYFLCAtvAJaEtNfn2QGsVkEVCUWHbnEBGKz
	CahLfH69A2yFkICcRNOS1WA1ogIREq/OToTqFZT4MfkemC0iECyx9utCRpAFzAKrGCWuX17O
	BpIQFjCVmPdoHxvEICuJVyvngQ3iFLCWaN67CyzOLGAm8ahlHTOELS+xec1bZoh6ZYk/l08x
	QfymLHHncjfjBEaRWUh2z0LSPgtJ+wJG5lWMYqXFyQXFSempFSZ6xYm5xaV56XrJ+bmbGCHR
	VLuD8f5Xm0OMAhyMSjy8HzQ8goVYE8uKK3MPMUpwMCuJ8L7NAgrxpiRWVqUW5ccXleakFh9i
	ZOLglGpg1HjjNevizxsfHvWfKiwWLZA5a/fL/L2r4rPw0kNRCQsuZF/L31tiqX7l4bTjq5Re
	yQZ+kwjP2DPnro5/o0JzSETt1tBFkvvi1f1+ePx/di/rMf/d9xKuz59nxP0M3sVxacqreW+K
	PQ/VOzvO0Jtu6538MexmzzVvcabGzSZef9tn5175N/+eiBJLcUaioRZzUXEiAFeMHm+EAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 10:10 AM, Greg Kroah-Hartman wrote:
> ------------------------
> NOTE
>
> This is probably going to be the last 3.13.y kernel release.  There
> _might_ be one more after this, but given my travel schedule for the
> next few weeks, don't count on it.  Please move to the 3.14 kernel tree
> as soon as possible.
>
> ------------------------
>
> This is the start of the stable review cycle for the 3.13.10 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Apr 13 16:09:42 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.13.10-rc1.gz
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
