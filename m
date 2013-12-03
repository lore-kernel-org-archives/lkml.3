Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab3LCVxf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 16:53:35 -0500
Received: from mailout4.w2.samsung.com ([211.189.100.14]:35663 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754670Ab3LCVxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 16:53:32 -0500
X-AuditID: cbfec37c-b7f9d6d000003434-08-529e52db58ab
Message-id: <529E52D9.4080103@samsung.com>
Date: Tue, 03 Dec 2013 14:53:29 -0700
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
Subject: Re: [PATCH 3.12 000/212] 3.12.3-stable review
References: <20131202191248.517975703@linuxfoundation.org>
In-reply-to: <20131202191248.517975703@linuxfoundation.org>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9hP93bQfOCDA5+sbCYs34Nm0Xz4vVs
	Fpd3zWGz+PrTwWLBxkeMFo/63rI7sHnsnHWX3ePEjN8sHvvnrmH3+LxJLoAlissmJTUnsyy1
	SN8ugStjw/bHjAUTeSt2/jzA2MB4lquLkZNDQsBE4urDeewQtpjEhXvr2UBsIYFljBJnvllB
	2L1MEo8fF3UxcgHZGxklNnb/YwFJ8ApoSZz4/4gZxGYRUJU4dOcQ2CA2AXWJz693sEM0y0k0
	LVkNViMqECFxdPUzVoheQYkfk++BzRERCJZY+3UhI8gCZoEVjBLHX74Eu0JYwExix5oeqEFW
	El+/N4M1cwpYS7y8dBkszgxU86hlHTOELS+xec1bZoh6ZYk/l08xdTFyAH2mKLF9tdUERpFZ
	SFbPQtI9C0n3AkbmVYxipcXJBcVJ6akVxnrFibnFpXnpesn5uZsYIRFTs4Px3lebQ4wCHIxK
	PLwJnPOChFgTy4orcw8xSnAwK4nwbvUDCvGmJFZWpRblxxeV5qQWH2Jk4uCUamBkVyjJyWA5
	ceDG0RfON2q+dp3O4ma+Zvpg5YMdfary5zQzvdJ/xu7i7X2X8dn/o5HurfunLU4duJa5fPMl
	rRLlK/8Xmi1oTtktL/jpl+O/PFt+5Q+mi+M9d01k7giqunsn3+lOmIhOTnVCg12YklSdX1V3
	/auYKsl9+l8X/T7i+zPGeJsBy2MlluKMREMt5qLiRAC1PBSqdgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 12:13 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.12.3 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Dec  4 19:11:18 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.12.3-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patch applied with warnings:

  git apply --index ../stable_tree_project/patch-3.12.3-rc1 
../stable_tree_project/patch-3.12.3-rc1:8684: space before tab in 
indent. * Anon maps don't have the execname. 
../stable_tree_project/patch-3.12.3-rc1:8685: space before tab in 
indent. */ warning: 2 lines add whitespace errors.

Problem patch:

Don Zickus <dzickus@redhat.com> perf tools: Synthesize anon MMAP records 
again

http://lkml.indiana.edu/hypermail/linux/kernel/1311.1/03602.html

boot testing - passed
dmesg regression tests - passed - dmesgs look good. No regressions 
compared to the previous dmesgs for this release. dmesg emerg, crit, 
alert, err are clean. No regressions in warn.

Test systems:
     Samsung Series 9 900X4C Intel Corei5 (3.4 and later)
     HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
     Dell OptiPlex 790 Intel(R) Core(TM) i5-2400

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
