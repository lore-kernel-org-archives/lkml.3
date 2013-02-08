Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947052Ab3BHU2M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 15:28:12 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:52738 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946949Ab3BHU2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 15:28:08 -0500
MIME-Version: 1.0
In-Reply-To: <20130208004627.112511141@linuxfoundation.org>
References: <20130208004627.112511141@linuxfoundation.org>
Date: Fri, 8 Feb 2013 13:28:06 -0700
Message-ID: <CAKocOOP6iwYK4_FhVc+XT6SJcGCn83UiGJDwJfEVxD8idESktg@mail.gmail.com>
Subject: Re: [ 00/16] 3.0.63-stable review
From: Shuah Khan <shuahkhan@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 5:57 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 3.0.63 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Feb 10 00:43:19 UTC 2013.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.63-rc1.gz
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Patches applied cleanly to 3.0.62, 3.4.29, and 3.7.6.
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
