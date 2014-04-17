Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaDQX1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 19:27:17 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:52616 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaDQX1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 19:27:11 -0400
X-AuditID: cbfec37b-b7f8f6d000007030-d9-5350634dbbe0
Message-id: <5350634A.2030608@samsung.com>
Date: Thu, 17 Apr 2014 17:27:06 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
MIME-version: 1.0
To: Tejun Heo <tj@kernel.org>
Cc: gregkh@linuxfoundation.org, m.chehab@samsung.com,
        rafael.j.wysocki@intel.com, linux@roeck-us.net, toshi.kani@hp.com,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        shuahkhan@gmail.com, Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [RFC PATCH 2/2] drivers/base: add managed token devres interfaces
References: <cover.1397050852.git.shuah.kh@samsung.com>
 <5f21c7e53811aba63f86bcf3e3bfdfdd5aeedf59.1397050852.git.shuah.kh@samsung.com>
 <20140416215821.GG26632@htj.dyndns.org> <5350331C.7010602@samsung.com>
 <20140417201034.GT15326@htj.dyndns.org> <20140417202221.GU15326@htj.dyndns.org>
In-reply-to: <20140417202221.GU15326@htj.dyndns.org>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.34.3]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgkeLIzCtJLcpLzFFi42I5/e+wn65vckCwwaGjihbNi9ezWVzeNYfN
	omfDVlaLJwvPMFk8XvGW3eLrTweLX8uPMlpsu7WQxYHDY+esu+weu7btZPJYvOclk8emVZ1s
	HvvnrmH32Pm9gd3j8ya5APYoLpuU1JzMstQifbsErozF17+zFcxlrdh6Zz9bA+MEli5GTg4J
	AROJhpNb2SFsMYkL99azdTFycQgJLGOUmPb7LCuE08sksen9ckYIZwOjxJSHTawgLbwCWhIX
	d30FG8UioCrx7OhzNhCbTUBd4vPrHWBjhQTkJJqWrGYGsUUFIiRenZ3IAtErKPFj8j0wW0RA
	VuLKtIdgC5gFPjBKXN/QD5YQFvCT+PxoDzvE5sVMEl9X9IFt4AQ6/GnDVjCbWcBaYuWkbYwQ
	trzE5jVvmSE2K0v8uXyKCeI5BYn1Fw6zTmAUmYVk+Swk7bOQtC9gZF7FKFZanFxQnJSeWmGk
	V5yYW1yal66XnJ+7iRESa9U7GO9+tTnEKMDBqMTDe/Grf7AQa2JZcWXuIUYJDmYlEV5T1YBg
	Id6UxMqq1KL8+KLSnNTiQ4xMHJxSDYx5jWILJ/WcE2aat2DDhlNKGqXTZjI4qgTJ3o+XUPQ5
	Eab0I7mxWfBt2f662ReXTJn9PkdObCKnOy+rYtYir50tBV1L0yI5xLZ+451vcj/LPY/bLTBe
	SWR2+e56Z79NC4zjdi/l59+2JobzdQXfKqfWNe/O2k/Zsqm/9qPMwbzMp6d/zbjvH6DEUpyR
	aKjFXFScCAAnBUgykwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2014 02:22 PM, Tejun Heo wrote:
> On Thu, Apr 17, 2014 at 04:10:34PM -0400, Tejun Heo wrote:
Please do not implement locking
> primitive directly if at all avoidable.  Why can't it use a mutex
> embedded in the data area of a devres entry?  And if you for some
> reason have to implement it directly, at least add lockdep
> annotations.
>

Thanks. This is helpful. Yes it does simplify the code with mutex
embedded in the devres data area. I am working on a v2 patch with
that change.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
