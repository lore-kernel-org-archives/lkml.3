Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932613AbaGETHA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jul 2014 15:07:00 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36002 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756147AbaGETG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jul 2014 15:06:59 -0400
Date: Sat, 5 Jul 2014 12:11:19 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/46] 3.10.47-stable review
Message-ID: <20140705191119.GC30203@kroah.com>
References: <20140704221602.280733370@linuxfoundation.org>
 <53B7908C.2050800@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53B7908C.2050800@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 04, 2014 at 10:43:40PM -0700, Guenter Roeck wrote:
> On 07/04/2014 03:19 PM, Greg Kroah-Hartman wrote:
> >This is the start of the stable review cycle for the 3.10.47 release.
> >There are 46 patches in this series, all will be posted as a response
> >to this one.  If anyone has any issues with these being applied, please
> >let me know.
> >
> >Responses should be made by Sun Jul  6 22:15:52 UTC 2014.
> >Anything received after that time might be too late.
> >
> 
> Build results:
> 	total: 144 pass: 125 skipped: 6 fail: 13
> Failed builds:
> 	alpha:allmodconfig
> 	i386:defconfig
> 	i386:allyesconfig
> 	i386:allmodconfig
> 	powerpc:allmodconfig (binutils 2.23)
> 	powerpc:allmodconfig (binutils 2.24)
> 	score:defconfig
> 	sparc64:allmodconfig
> 	unicore32:defconfig
> 	x86_64:defconfig
> 	x86_64:allyesconfig
> 	x86_64:allmodconfig
> 	xtensa:allmodconfig
> 
> Qemu test for x86 failed with a build error.
> 
> This is not as expected. New build error is always the same as far as I can see:
> 
> sound/pci/hda/patch_sigmatel.c: In function 'stac92hd95_fixup_hp_led':
> sound/pci/hda/patch_sigmatel.c:3578:3: error: implicit declaration of function 'codec_dbg' [-Werror=implicit-function-declaration]

Should now be fixed, thanks.

greg k-h
