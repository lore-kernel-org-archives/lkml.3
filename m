Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbaIWGOt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:14:49 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:42297 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751578AbaIWGOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:14:48 -0400
Message-ID: <54210FD3.5000906@huawei.com>
Date: Tue, 23 Sep 2014 14:14:43 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Zefan Li <lizf@kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <satoru.takeuchi@gmail.com>
Subject: Re: [PATCH 3.4 00/45] 3.4.104-rc1 review
References: <1411439259-30224-1-git-send-email-lizf@kernel.org> <5420FDFB.8040203@roeck-us.net>
In-Reply-To: <5420FDFB.8040203@roeck-us.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/23 12:58, Guenter Roeck wrote:
> On 09/22/2014 07:27 PM, Zefan Li wrote:
>> From: Zefan Li <lizefan@huawei.com>
>>
>> This is the start of the stable review cycle for the 3.4.104 release.
>> There are 45 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu Sep 25 02:03:31 UTC 2014.
>> Anything received after that time might be too late.
>>
> 
> Build results:
>     total: 119 pass: 116 fail: 3
> Failed builds:
>     score:defconfig
>     sparc64:allmodconfig
>     xtensa:allmodconfig
> 
> Qemu test results:
>     total: 18 pass: 17 fail: 1
> Failed tests:
>     arm:arm_versatile_defconfig
> 
> This is an improvement over the previous release, where we had six build
> failures.

Thanks for digging out the fixes to those build failures.

> The failing qemu test is a recent addition which is expected
> to fail for the 3.4 kernel. The failure is due to Versatile SCSI driver
> and interrupt handling problems; those were fixed in later kernels but
> would be difficult to back-port.
> 

Thanks for testing! This is my first time doing stable release, and luckily
I haven't broken the build or boot. :)

