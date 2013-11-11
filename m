Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078Ab3KKR6n (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:58:43 -0500
Received: from mailout2.w2.samsung.com ([211.189.100.12]:32103 "EHLO
	usmailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab3KKR6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:58:36 -0500
X-AuditID: cbfec37a-b7fb76d000006e93-33-52811acab325
Message-id: <52811AC8.4060804@samsung.com>
Date: Mon, 11 Nov 2013 10:58:32 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.4 00/26] 3.4.69-stable review
References: <20131109065050.089866597@linuxfoundation.org>
In-reply-to: <20131109065050.089866597@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsVy+t9hP93TUo1BBnOOsVrMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJVx7OBUtoL5HBVXFlxkbWDcytbFyMkhIWAicWPZD1YIW0ziwr31QHEuDiGBZYwS09pX
	s0A4vUwSTUemQDkbGSX2Lu9hAWnhFdCSOHL1FzOIzSKgKnFi9UGwsWwC6hKfX+9gB7GFBOQk
	mpasBqsRFYiQOLr6GStEr6DEj8n3wOaICARLrP26kBFkAbPACkaJ4y9fgg0SFjCW+P/kCjPE
	ICuJP7tPgjVwClhLHP9/mQnEZhYwk3jUso4ZwpaX2LzmLVS9ssSfy6eAajiAflOU2L7aagKj
	yCwkq2ch6Z6FpHsBI/MqRrHS4uSC4qT01ApDveLE3OLSvHS95PzcTYyQqKnawXjnq80hRgEO
	RiUe3h1cjUFCrIllxZW5hxglOJiVRHjdeIFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGIW7LlqF
	9qrnOJpe2bHfUKNs+r3+fRuV3R2d1OzNhTgZrqx4nRf9TcMme+ki16w3+9y6lNOuMd6sXG7S
	nHbQecPxdguLwAdX22vE9tyz9LsXemua6sWqXZ6PHXddY7l2xCGaKzxZ4JbX3RSJhYlC1c+M
	7bam7v10fdE/vdBHuz89sZK86yR7R4mlOCPRUIu5qDgRAN1yTUB4AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 11:51 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.69 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Nov 11 06:50:22 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.69-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.4.69

Patch applied cleanly    yes
Compile test        passed
Boot test        passed
dmesg regression test    passed

dmesgs look good. No regressions compared to the previous dmesgs for 
this release. dmesg emerg, crit, alert, err are clean. No regressions in 
warn.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
