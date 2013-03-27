Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753342Ab3C0ScJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 14:32:09 -0400
Received: from mail-la0-f54.google.com ([209.85.215.54]:56191 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3C0ScH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 14:32:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130326225839.554028294@linuxfoundation.org>
References: <20130326225839.554028294@linuxfoundation.org>
Date: Wed, 27 Mar 2013 12:32:03 -0600
Message-ID: <CAKocOOM+a6fo7uHr1szAj-U7_dkxW4zZDvkhGebQbq99VhNCrg@mail.gmail.com>
Subject: Re: [ 00/49] 3.0.71-stable review
From: Shuah Khan <shuahkhan@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 26, 2013 at 5:00 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 3.0.71 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Mar 28 22:57:54 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.71-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
Patches applied cleanly to 3.0.70, 3.4.37, and 3.8.4

Compiled and booted on the following systems:

HP EliteBook 6930p Intel(R) Core(TM)2 Duo CPU T9400 @ 2.53GHz
HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics

dmesgs for all releases look good. No regressions compared to the previous
dmesgs for each of these releases.

Cross-compile tests results:

alpha: defconfig passed on all
arm: defconfig passed on all
arm64: not applicable to 3.0.y, 3.4.y. defconfig passed on 3.8.y
c6x: not applicable to 3.0.y, defconfig passed on 3.4.y, and 3.8.y.
powerpc: wii_defconfig passed on all
sh: defconfig passed on all
sparc: defconfig passed on all
tile: tilegx_defconfig passed on all

Known issue since 3.0.70, 3.4.37 and 3.8.4

kernel/signal.c: In function ‘flush_signal_handlers’:
kernel/signal.c:441:9: error: ‘struct sigaction’ has no member named
‘sa_restorer’
make[1]: *** [kernel/signal.o] Error 1
make: *** [kernel] Error 2

mips: defconfig failed
mipsel: defconfig failed

-- Shuah
