Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943Ab3BZArX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 19:47:23 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39407 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab3BZArW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 19:47:22 -0500
MIME-Version: 1.0
In-Reply-To: <20130225221636.018756060@linuxfoundation.org>
References: <20130225221636.018756060@linuxfoundation.org>
Date: Mon, 25 Feb 2013 17:47:20 -0700
Message-ID: <CAKocOONFH1QfY2SW9wiqkdm1yLTipVKU_ggWPm7N1mvZiriDhQ@mail.gmail.com>
Subject: Re: [ 00/58] 3.7.10-stable review
From: Shuah Khan <shuahkhan@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 3:18 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> ----------------------------------------------------------------
> NOTE:
>         This is going to be the LAST 3.7.x kernel release.  After this,
>         the 3.7 series is end-of-life, please start moving to 3.8 or
>         newer at this point in time.
> ----------------------------------------------------------------
>
> This is the start of the stable review cycle for the 3.7.10 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Feb 27 22:14:28 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.7.10-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

3.7.10-rc1 patch applied cleanlt to 3.7.9
Compiled and booted on the following systems:
HP EliteBook 6930p Intel(R) Core(TM)2 Duo CPU T9400 @ 2.53GHz
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

dmesg looked good on both systems.

Cross-compile tests results:

alpha: defconfig passed
arm: defconfig passed
arm64: defconfig passed
c6x: defconfig passed
mips: defconfig passed
mipsel: defconfig passed
powerpc: wii_defconfig passed
sh: defconfig passed
sparc: defconfig passed
tile: tilegx_defconfig passed

-- Shuah
