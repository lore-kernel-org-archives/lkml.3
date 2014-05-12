Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaELVyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:54:12 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:13978 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaELVyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:54:10 -0400
X-AuditID: cbfec37a-b7fd76d000006048-27-537143026578
Message-id: <537142FE.3010407@samsung.com>
Date: Mon, 12 May 2014 15:54:06 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.5.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, stable@vger.kernel.org,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH 3.10 00/48] 3.10.40-stable review
References: <20140511191948.079900414@linuxfoundation.org>
In-reply-to: <20140511191948.079900414@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.3]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrPLMWRmVeSWpSXmKPExsVy+t9hX10m58Jgg7czuSzmrF/DZtG8eD2b
	xeVdc9gsniw8w2Qx9dQEFosFGx8xWjzqe8vuwO6xc9Zddo8TM36zeOyfuwbI/d7A7vF5k1wA
	axSXTUpqTmZZapG+XQJXxsQNSQXH2CpablxhbGCcxdrFyMkhIWAicbD9MJQtJnHh3nq2LkYu
	DiGBZYwSe6+cYodwepkkVn1/xArhbGCU6Lq0AayFV0BLYuqWc8wgNouAqkTnvx0sIDabgLrE
	59c72EFsIQE5iaYlq4FqODhEBSIkHl8QgmgVlPgx+R5YuYhAsMTarwsZQeYzC6xilLh+eTkb
	SEJYwFRiys5HLBBzrCSePXjBCGJzClhLbOqaDnYDs4CZxKOWdcwQtrzE5jVvmSHqlSX+XD7F
	BPGagsT6C4dZJzCKzEKyexaS9llI2hcwMq9iFCstTi4oTkpPrTDUK07MLS7NS9dLzs/dxAiJ
	pKodjHe+2hxiFOBgVOLhPcFZGCzEmlhWXJl7iFGCg1lJhFdOEyjEm5JYWZValB9fVJqTWnyI
	kYmDU6qBUWgL3/dtc8wWFd2t/NXwzivnfmJRSfGWeM65sz/us7I55bXf5o/by/tf9qheP7Fw
	8umFh1Zcf7161X6bms6uVf7pd3euqPm58sVHh8Zdin916k/f6TnqsaNuxvt1StrdD/i3KDU/
	uNVo4Gd7MqDz5CKxi5wZXa4pUjesWN4lr1v62Xlf+dM7uzOUWIozEg21mIuKEwF2RtT5ggIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 01:19 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.40 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue May 13 19:19:30 UTC 2014.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.40-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Compiled and booted on my test systems. No dmesg regressions.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
