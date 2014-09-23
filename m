Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaIWGMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 02:12:31 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:41028 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496AbaIWGM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 02:12:29 -0400
Message-ID: <54210F45.1010903@huawei.com>
Date: Tue, 23 Sep 2014 14:12:21 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
CC: Zefan Li <lizf@kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux@roeck-us.net>
Subject: Re: [PATCH 3.4 00/45] 3.4.104-rc1 review
References: <1411439259-30224-1-git-send-email-lizf@kernel.org> <87vbofc4xc.wl%satoru.takeuchi@gmail.com>
In-Reply-To: <87vbofc4xc.wl%satoru.takeuchi@gmail.com>
Content-Type: text/plain; charset="ISO-8859-2"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/9/23 12:54, Satoru Takeuchi wrote:
> Hi Li,
> 
> At Tue, 23 Sep 2014 10:27:39 +0800,
> Zefan Li wrote:
>>
>> From: Zefan Li <lizefan@huawei.com>
>>
>> This is the start of the stable review cycle for the 3.4.104 release.
>> There are 45 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu Sep 25 02:03:31 UTC 2014.
>> Anything received after that time might be too late.
> 
> This kernel passed my test.
> 
>  - Test Cases:
>    - Build this kernel.
>    - Boot this kernel.
>    - Build the latest mainline kernel with this kernel.
> 
>  - Test Tool:
>    https://github.com/satoru-takeuchi/test-linux-stable
> 
>  - Test Result (kernel .config, ktest config and test log):
>    http://satoru-takeuchi.org/test-linux-stable/results/<version>-<test datetime>.tar.xz
> 
>  - Build Environment:
>    - OS: Debian Jessy x86_64
>    - CPU: Intel(R) Core(TM) i5-2400 CPU @ 3.10GHz x 4
>    - memory: 8GB
> 
>  - Test Target Environment:
>    - Debian Jessy x86_64 (KVM guest on the Build Environment)
>    - # of vCPU: 2
>    - memory: 2GB
> 

Thanks for testing! This is my first time doing stable release, and luckily
I haven't broken the build or boot. :)

