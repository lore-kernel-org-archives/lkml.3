Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750859AbaEAEFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 00:05:16 -0400
Received: from mail-ig0-f177.google.com ([209.85.213.177]:54696 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaEAEFO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 00:05:14 -0400
Message-ID: <5361C7F9.5060405@gmail.com>
Date: Thu, 01 May 2014 12:05:13 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
CC: Guan Xuetao <gxt@mprc.pku.edu.cn>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] unicore32: About toolchain issues and source code.
References: <53604E82.1040407@gmail.com> <20140430184804.GA5733@roeck-us.net>
In-Reply-To: <20140430184804.GA5733@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/2014 02:48 AM, Guenter Roeck wrote:
> On Wed, Apr 30, 2014 at 09:14:42AM +0800, Chen Gang wrote:
>> Hello Maintainers:
>>
>>   - Toolchain information:
>>
>>     root@gchen:/upstream/toolchain/binutils/gas# /upstream/toolchain/unicore32/pi3dian14-beyondmind/prebuilt/linux-x86/toolchain/uc4-1.0-beta-hard-RHELAS4/bin/unicore32-linux-gcc -v
>>     Using built-in specs.
>>     Target: unicore32-linux
>>     Configured with: /home/ghb/trunk/gcc-4.4.2/configure --target=unicore32-linux --prefix=/usr/unicore/gnu-toolchain-unicore/uc4-1.0-beta-hard-RHELAS4 --enable-clocale=gnu --enable-shared --enable-threads=posix --enable-__cxa_atexit --enable-languages=c,c++,fortran --disable-multilib --disable-libstdcxx-pch --with-headers=/usr/unicore/gnu-toolchain-unicore/uc4-1.0-beta-hard-RHELAS4/unicore32-linux/include --with-pkgversion=UC4_1.0-beta_20100415
>>     Thread model: posix
>>     gcc version 4.4.2 (UC4_1.0-beta_20100415) 
> 
> That is an old version of the toolchain. Latest version I can find is 1.0.5.
> Google for "unicore32 toolchain" or pick it up from
> 	http://mprc.pku.edu.cn/~guanxuetao/linux/uc4-1.0.5-hard.tgz
> 
> Having said that, I don't find a single kernel version (3.2 and later)
> which builds unicore32:defconfig. Wonder if that architecture is still
> supported (or if there is some secret to get it compiled.
> 
> Build results are at http://server.roeck-us.net:8010/builders.
> 
> Guenter
> 

Thank you very much!

I will try it.

Thanks.
-- 
Chen Gang

Open, share and attitude like air, water and life which God blessed
