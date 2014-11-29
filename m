Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaK2FzG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 00:55:06 -0500
Received: from szxga03-in.huawei.com ([119.145.14.66]:23641 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbaK2FzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 00:55:04 -0500
Message-ID: <54795FA7.2010408@huawei.com>
Date: Sat, 29 Nov 2014 13:54:47 +0800
From: Zefan Li <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: <lizf@kernel.org>, <stable@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <satoru.takeuchi@gmail.com>
Subject: Re: [PATCH 3.4 00/91] 3.4.105-rc1 review
References: <1417077368-9217-1-git-send-email-lizf@kernel.org> <54778649.8000408@roeck-us.net>
In-Reply-To: <54778649.8000408@roeck-us.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020203.54795FB4.00E4,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 41a8d2195ac32ae1fbcc3926314ad01f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Build results:
>     total: 119 pass: 114 fail: 5
> Failed builds:
>     arm:s3c6400_defconfig
>     arm:nhk8815_defconfig
>     score:defconfig
>     sparc64:allmodconfig
>     xtensa:allmodconfig
> 
> Qemu test results:
>     total: 23 pass: 22 fail: 1
> Failed tests:
>     arm:arm_versatile_defconfig
> 
> The arm build failures are due to
> 
> Inconsistent kallsyms data
> This is a bug - please report about it
> Try make KALLSYMS_EXTRA_PASS=1 as a workaround
> make: *** [vmlinux] Error 1
> 
> This seems to be toolchain related. I switched from the cross toolchain
> provided with yocto 1.4.2 to the toolchain provided with yocto 1.7.
> This seems to fix the problem. Just mentioning it here in case someone
> uses an older toolchain.
> 
> Details are available at http://server.roeck-us.net:8010/builders.
> 

Thanks for testing!

