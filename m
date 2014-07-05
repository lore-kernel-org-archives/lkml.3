Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760357AbaGEFno (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 01:43:44 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56798 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaGEFnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 01:43:42 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53B7908C.2050800@roeck-us.net>
Date: Fri, 04 Jul 2014 22:43:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/46] 3.10.47-stable review
References: <20140704221602.280733370@linuxfoundation.org>
In-Reply-To: <20140704221602.280733370@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2014 03:19 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.47 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Jul  6 22:15:52 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 144 pass: 125 skipped: 6 fail: 13
Failed builds:
	alpha:allmodconfig
	i386:defconfig
	i386:allyesconfig
	i386:allmodconfig
	powerpc:allmodconfig (binutils 2.23)
	powerpc:allmodconfig (binutils 2.24)
	score:defconfig
	sparc64:allmodconfig
	unicore32:defconfig
	x86_64:defconfig
	x86_64:allyesconfig
	x86_64:allmodconfig
	xtensa:allmodconfig

Qemu test for x86 failed with a build error.

This is not as expected. New build error is always the same as far as I can see:

sound/pci/hda/patch_sigmatel.c: In function 'stac92hd95_fixup_hp_led':
sound/pci/hda/patch_sigmatel.c:3578:3: error: implicit declaration of function 'codec_dbg' [-Werror=implicit-function-declaration]

Guenter

