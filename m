Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab3ASSvz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 13:51:55 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:65375 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751572Ab3ASSvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 13:51:53 -0500
MIME-Version: 1.0
In-Reply-To: <20130119010345.885772698@linuxfoundation.org>
References: <20130119010345.885772698@linuxfoundation.org>
Date: Sat, 19 Jan 2013 11:51:52 -0700
Message-ID: <CAKocOONmw1+UMFMjhXeuZ6RpVYr58tkRM1gvcwrSS-WbReaQCQ@mail.gmail.com>
Subject: Re: [ 00/33] 3.7.4-stable review
From: Shuah Khan <shuahkhan@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 6:16 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 3.7.4 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Jan 21 01:01:55 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.7.4-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Patches applied cleanly to 3.0.y, 3.4.y, and 3.7.y.
Compiled and booted on the following systems:
HP EliteBook 6930p Intel(R) Core(TM)2 Duo CPU T9400 @ 2.53GHz
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

Cross-compile tests:
alpha: defconfig passed on all
arm: defconfig passed on all
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.7.y
c6x: not applicable to 3.0.y, defconfig passed on 3.4.y, and 3.7.y.
mips: defconfig passed on all
mipsel: defconfig passed on all
powerpc: wii_defconfig passed on all
sh: defconfig passed on all
sparc: defconfig passed on all
tile: tilegx_defconfig passed on all

-- Shuah
