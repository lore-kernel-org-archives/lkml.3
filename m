Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab3GXOx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:53:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50843 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab3GXOxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:53:54 -0400
Date: Wed, 24 Jul 2013 07:55:06 -0700
From: "gregkh@linuxfoundation.org >> \"Kroah-Hartman, Greg\"" 
	<gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: Shuah Khan <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [ 000/103] 3.10.3-stable review
Message-ID: <20130724145506.GC15095@kroah.com>
References: <20130723220418.532514378@linuxfoundation.org>
 <CAKocOOPO61YUj5kTL7k1HuEeDdB_x=sxWga007nBSiLD4Px5Mg@mail.gmail.com>
 <B8EFE96D1287C24090BAD9D858E15E61748BEA@sisaex01sj>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E61748BEA@sisaex01sj>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 24, 2013 at 01:40:56PM +0000, Shuah Khan wrote:
> Note: When I did a git reset --hard on 3.10.2-rc2 patch,
> drivers/acpi/acpi_cmos_rtc.c was left as an untracked file.
> I had to remove it before git pull succeeded for 3.10.2.

Yes, that's because 3.10.2 added a new file to the tree, so this is to
be expected.

> Compiled and booted on the following systems:
> 
> Samsung Series 9 900X4C Intel Corei5:
> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics:
> 
> dmesgs for all releases look good. No regressions compared to the 
> previous dmesgs for each of these releases. dmesg emerg, crit, alert, 
> err are clean. No regressions in warn.
> 
> Cross-compile testing:
> HP Compaq dc7700 SFF desktop: x86-64 Intel Core-i2:
> 
> Cross-compile tests results:
> 
> alpha: defconfig passed
> arm: defconfig passed
> arm64: defconfig passed
> c6x: defconfig passed
> mips: defconfig passed
> mipsel: defconfig passed
> powerpc: wii_defconfig
> sh: defconfig passed
> sparc: defconfig passed
> tile: tilegx_defconfig passed

Thanks for testing all of this and letting me know, it's much
appreciated.

greg k-h
