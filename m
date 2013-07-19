Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab3GSXTj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 19:19:39 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:55121 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753103Ab3GSXTh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 19:19:37 -0400
X-AuditID: cbfec37b-b7f306d0000047de-91-51e9c987f2b8
From: Shuah Khan <shuah.kh@samsung.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [ 00/24] 3.4.54-stable review
Thread-topic: [ 00/24] 3.4.54-stable review
Thread-index: AQHOhNY0t+xpJ1oo60GsjQODeqQhIQ==
Date: Fri, 19 Jul 2013 23:19:34 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E61746937@sisaex01sj>
References: <20130719022404.015008451@linuxfoundation.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=Windows-1252
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnkeLIzCtJLcpLzFFi42I5/e+wn277yZeBBjuOWljMWb+GzaJ58Xo2
	i8u75rBZfP3pYLFg4yNGi0d9b9kd2Dx2zrrL7nFixm8Wj/1z17B7fN4kF8ASxWWTkpqTWZZa
	pG+XwJXx7s4V9oJrYhWvVn9ib2B8INTFyMkhIWAi8X3HQVYIW0ziwr31bCC2kMAyRomm13Fd
	jFxAdi+TxLW2KywQznxGiUerl4N1sAmoS3x+vYMdxBYRMJboPzsLzGYWOMYk0dFZBmILC2hJ
	3Hz7nAmiRlvi5tIvULaexM4XnYwgNouAqsSKAw1gvbwC9hI79ryHusJK4s+He2A1jEDXfT+1
	hglivrhEc+tNFoirBSSW7DnPDGGLSrx8/A/oNg4gW1Fi+2oriHI9iY9/bjNC2NoST95dYIVY
	JSjxY/I9lgmMYrOQTJ2FpGUWkpZZSFoWMLKsYhQrLU4uKE5KT60w0itOzC0uzUvXS87P3cQI
	ibzqHYx3v9ocYhTgYFTi4b2w4mWgEGtiWXFl7iFGCQ5mJRHegjSgEG9KYmVValF+fFFpTmrx
	IUYmDk6pBsZ5rBb1XV+kQ36mnJA+zOR4ZI2eBy/DES0ZjqPKSyqc2VerHODJO2foxfj2/eOJ
	ontPKvhfab0966y7wRqvmPfbPuhde/9isuaOA3VLPd2jUt4ImwUGhS61snl350wD27Gg1GeW
	5rV/9v1ec0po6nHOCpeOSPunj0tnqE9TnixorD7do8C5aLsSS3FGoqEWc1FxIgCCnWGmmgIA	AA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2013 05:17 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.54 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Jul 21 02:23:13 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.54-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>


Patches applied cleanly to 3.0.86, 3.4.54, 3.9.10, and 3.10.1

3.9.11-rc1 patch failed to build:
x64-64, mipsel, mips, powerpc, and tile: build failed with the following 
error:

    LD      ipc/built-in.o
    CC [M]  fs/cifs/inode.o
fs/cifs/inode.c: In function ‘cifs_all_info_to_fattr’:
fs/cifs/inode.c:560:4: error: implicit declaration of function
‘cifs_dbg’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[2]: *** [fs/cifs/inode.o] Error 1
make[1]: *** [fs/cifs] Error 2
make: *** [fs] Error 2
make: *** Waiting for unfinished jobs....
    CC      security/selinux/hooks.o

I have CONFIG_CIFS=m in my config and CONFIG_CIFS_DEBUG is disabled.
cifs_dbg() is not defined.

Compiled and booted on the following systems:

Samsung Series 9 900X4C Intel Corei5:
     (3.4.54-rc1, 3.9.10-rc1, 3.10.2-rc2)
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
     (3.0.87-rc1, 3.4.54-rc1, 3.9.10-rc1?, and 3.10.2-rc2)

dmesgs for all releases look good. No regressions compared to the 
previous dmesgs for each of these releases. dmesg emerg, crit, alert, 
err are clean. No regressions in warn.

Cross-compile testing:
HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
     (3.0.87-rc1, 3.4.54-rc1, 3.9.10-rc1?, and 3.10.2-rc2)

Cross-compile tests results:

alpha: defconfig passed on all
arm: defconfig passed on all
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.9.y, and 3.10.y
c6x: not applicable to 3.0.y, defconfig passed on 3.4.y, 3.9.y, and 3.10.y
mips: defconfig passed on all, except 3.9.10
mipsel: defconfig passed on all, except 3.9.10
powerpc: wii_defconfig passed on all, except 3.9.10
sh: defconfig passed on all
sparc: defconfig passed on all
tile: tilegx_defconfig passed on all, except 3.9.10

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
