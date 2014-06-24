Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800AbaFXTsw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 15:48:52 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:41796 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750762AbaFXTsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 15:48:50 -0400
X-AuditID: cbfec37b-b7fbe6d000006742-86-53a9d620a8e9
Message-id: <53A9D61E.1040702@samsung.com>
Date: Tue, 24 Jun 2014 13:48:46 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.6.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.10 00/52] 3.10.45-stable review
References: <20140624154713.428945460@linuxfoundation.org>
In-reply-to: <20140624154713.428945460@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.134.222]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrHLMWRmVeSWpSXmKPExsVy+t9hX12FayuDDSZNNLGYs34Nm0Xz4vVs
	Fpd3zWGzeLLwDJPF1FMTWCwWbHzEaPGo7y27A7vHzll32T1OzPjN4rF/7hog93sDu8fnTXIB
	rFFcNimpOZllqUX6dglcGQtvGRUcY6u49GcOcwPjLNYuRk4OCQETifeX/rNA2GISF+6tZ+ti
	5OIQEljGKDHr+CVWCKeXSWL6lXlQzjZGiW3fPwGVcXDwCmhJ7J4N1s0ioCqx+fgUJhCbTUBd
	4vPrHewgtpCAnETTktXMILaoQITEgb5nYJt5BQQlfky+B9YrIhAssfbrQkaQ+cwCqxglZh7/
	C5YQFjCVWPbsIAvILiEBK4lzG4NBwpwC1hITj2wCm88sYCbxqGUdM4QtL7F5zVtmiL3KEn8u
	n2KC+ExZ4smU84wTGEVmIVk9C0n7LCTtCxiZVzGKlRYnFxQnpadWGOkVJ+YWl+al6yXn525i
	hMRR9Q7Gu19tDjEKcDAq8fBemL0yWIg1say4MvcQowQHs5IIr2k3UIg3JbGyKrUoP76oNCe1
	+BAjEwenVAMjs3P06rq+GRPfBGVKV2R+m/XuytRPe1R1Ug9uzPi4/MrMRvNqJt14hQXdNwNU
	xUOVPtavvnDn3uQnr0ILfTa+j3aU+ZNZ+zZ10p+zm+Of1pwMj7tzZZcK2yWLjVzzKhvcGvr3
	fvB93aAiLBi0oMfGWSd1XkXw3zMv3dJUbwXaPPp+5Jgt1zM5JZbijERDLeai4kQAa2iS74EC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24/2014 09:50 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.45 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jun 26 15:46:59 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.45-rc1.gz
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
