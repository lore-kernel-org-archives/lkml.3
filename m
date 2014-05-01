Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbaEAMbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 08:31:25 -0400
Received: from mx11.pku.edu.cn ([162.105.129.174]:45893 "EHLO mail.pku.edu.cn"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750845AbaEAMbY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 08:31:24 -0400
X-Spam-Flag: NO
X-Spam-Score: -310.599
References: <53604E82.1040407@gmail.com> <20140430184804.GA5733@roeck-us.net>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20140430184804.GA5733@roeck-us.net>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <919EE9ED-E879-42A1-A374-6550B7B63A24@pku.edu.cn>
Cc: Chen Gang <gang.chen.5i5j@gmail.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Mailer: iPhone Mail (11D167)
From: "GUAN, Xuetao" <gxt@pku.edu.cn>
Subject: Re: [Suggestion] unicore32: About toolchain issues and source code.
Date: Thu, 1 May 2014 20:31:13 +0800
To: Guenter Roeck <linux@roeck-us.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, please use 1.0.5 version.
I'll check and fix these problems in this month.

Thanks Chen & Guenter.

Sent from my iPhone

> On May 1, 2014, at 2:48 AM, Guenter Roeck <linux@roeck-us.net> wrote:
> 
>> On Wed, Apr 30, 2014 at 09:14:42AM +0800, Chen Gang wrote:
>> Hello Maintainers:
>> 
>>  - Toolchain information:
>> 
>>    root@gchen:/upstream/toolchain/binutils/gas# /upstream/toolchain/unicore32/pi3dian14-beyondmind/prebuilt/linux-x86/toolchain/uc4-1.0-beta-hard-RHELAS4/bin/unicore32-linux-gcc -v
>>    Using built-in specs.
>>    Target: unicore32-linux
>>    Configured with: /home/ghb/trunk/gcc-4.4.2/configure --target=unicore32-linux --prefix=/usr/unicore/gnu-toolchain-unicore/uc4-1.0-beta-hard-RHELAS4 --enable-clocale=gnu --enable-shared --enable-threads=posix --enable-__cxa_atexit --enable-languages=c,c++,fortran --disable-multilib --disable-libstdcxx-pch --with-headers=/usr/unicore/gnu-toolchain-unicore/uc4-1.0-beta-hard-RHELAS4/unicore32-linux/include --with-pkgversion=UC4_1.0-beta_20100415
>>    Thread model: posix
>>    gcc version 4.4.2 (UC4_1.0-beta_20100415)
> 
> That is an old version of the toolchain. Latest version I can find is 1.0.5.
> Google for "unicore32 toolchain" or pick it up from
>    http://mprc.pku.edu.cn/~guanxuetao/linux/uc4-1.0.5-hard.tgz
> 
> Having said that, I don't find a single kernel version (3.2 and later)
> which builds unicore32:defconfig. Wonder if that architecture is still
> supported (or if there is some secret to get it compiled.
> 
> Build results are at http://server.roeck-us.net:8010/builders.
> 
> Guenter
