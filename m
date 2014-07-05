Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760554AbaGEFpp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 01:45:45 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63225 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbaGEFpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 01:45:44 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53B79106.2070102@roeck-us.net>
Date: Fri, 04 Jul 2014 22:45:42 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.14 00/59] 3.14.11-stable review
References: <20140704221539.544876024@linuxfoundation.org>
In-Reply-To: <20140704221539.544876024@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2014 03:18 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.14.11 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Jul  6 22:15:27 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 144 pass: 130 skipped: 4 fail: 10
Failed builds:
	alpha:allmodconfig
	i386:allyesconfig
	i386:allmodconfig
	powerpc:allmodconfig (binutils 2.23)
	powerpc:allmodconfig (binutils 2.24)
	sparc64:allmodconfig
	unicore32:defconfig
	x86_64:allyesconfig
	x86_64:allmodconfig
	xtensa:allmodconfig

Qemu test for x86 failed.

Build error is the same as seen with 3.14.

sound/pci/hda/patch_sigmatel.c: In function 'stac92hd95_fixup_hp_led':
sound/pci/hda/patch_sigmatel.c:4143:3: error: implicit declaration of function 'codec_dbg' [-Werror=implicit-function-declaration]

Guenter

