Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720AbaDAVH1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:07:27 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:12913 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751618AbaDAVHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:07:24 -0400
X-AuditID: cbfec37d-b7f616d0000059df-5a-533b2a8bb9aa
Message-id: <533B2A88.2010604@samsung.com>
Date: Tue, 01 Apr 2014 15:07:20 -0600
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
Subject: Re: [PATCH 3.10 0/9] 3.10.36-stable review
References: <20140401040754.479538406@linuxfoundation.org>
In-reply-to: <20140401040754.479538406@linuxfoundation.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.4]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrILMWRmVeSWpSXmKPExsVy+t9hP91uLetgg49r5SzmrF/DZtG8eD2b
	xeVdc9gsniw8w2Qx9dQEFosFGx8xWjzqe8vuwO6xc9Zddo8TM36zeOyfuwbI/d7A7vF5k1wA
	axSXTUpqTmZZapG+XQJXxtsd/5kKTrFV9H/5wtLAOIe1i5GTQ0LARGLCnf9QtpjEhXvr2boY
	uTiEBJYxSnzoXwrl9DJJLNvxE8rZwChx/FwXWAuvgJbEzeYHzCA2i4CqxOPuF2BxNgF1ic+v
	d7CD2EICchJNS1aD1YgKREi8OjuRBaJXUOLH5HtgtohAsMTarwsZQRYwC6xilLh+eTkbSEJY
	wFji6Y2vUIOsJE6+PQhmcwpYS7S1rwJrZgayV07axghhy0tsXvOWGaJeWeLP5VNMEL8pSKy4
	8YZlAqPILCS7ZyFpn4WkfQEj8ypGsdLi5ILipPTUChO94sTc4tK8dL3k/NxNjJBoqt3BeP+r
	zSFGAQ5GJR7eA+etgoVYE8uKK3MPMUpwMCuJ8G5jsg4W4k1JrKxKLcqPLyrNSS0+xMjEwSnV
	wCguds1EJ3mHR8WTcN3XFm2f8hSWpDK6LxJ7fr34hNuVQz59tpfv81k8kMzu9LA3uLnb+C9X
	hD+TSv4EvqfnE7XXp+fGfzFy1GYw2q30skGVZ7JOYXpd3+WNGxMK5l1T/sby6dOTnpl/Cm3X
	3yq8x6W1bMaMjQ/4l8l6qQcuu/ZAxzbPY8GTMCWW4oxEQy3mouJEAPjsSDiEAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 10:08 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.36 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Apr  3 04:07:29 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.36-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled, booted on all my test systems. No regressions in dmesg.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
