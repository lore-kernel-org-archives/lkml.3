Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbaICN0o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:26:44 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60493 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932590AbaICN0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:26:42 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5407170F.2070701@roeck-us.net>
Date: Wed, 03 Sep 2014 06:26:39 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>, stable@vger.kernel.org
CC: satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 00/56] 3.12.28-stable review
References: <cover.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 02:26 AM, Jiri Slaby wrote:
> This is the start of the stable review cycle for the 3.12.28 release.
> There are 56 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Sep  5 11:17:45 CEST 2014.
> Anything received after that time might be too late.
>

Jiri,

I get a large number of build failures.

total: 135 pass: 104 fail: 31
Failed builds:
arm:s3c2410_defconfig
arm:ixp4xx_defconfig
arm:mini2440_defconfig
arm:at91_dt_defconfig
arm:s3c6400_defconfig
arm:lpc32xx_defconfig
arm:sama5_defconfig
arm:cm_x2xx_defconfig
arm:at91rm9200_defconfig
ia64:defconfig
mips:bcm47xx_defconfig
mips:bcm63xx_defconfig
mips:ath79_defconfig
mips:fuloong2e_defconfig
mips:powertv_defconfig
parisc:defconfig
powerpc:defconfig
powerpc:ppc64e_defconfig
powerpc:cell_defconfig
powerpc:maple_defconfig
powerpc:mpc85xx_defconfig
powerpc:mpc85xx_smp_defconfig
powerpc:defconfig
powerpc:ppc64e_defconfig
powerpc:cell_defconfig
powerpc:maple_defconfig
powerpc:mpc85xx_defconfig
powerpc:mpc85xx_smp_defconfig
sparc32:defconfig
sparc64:defconfig
tile:tilegx_defconfig

In file included from drivers/usb/host/ohci-hcd.c:85:0:
drivers/usb/host/ohci-dbg.c:411:20: error: conflicting types for 'ohci_dump'
drivers/usb/host/ohci-hcd.c:81:13: note: previous declaration of 'ohci_dump' was here
drivers/usb/host/ohci-hcd.c: In function 'ohci_run':
drivers/usb/host/ohci-hcd.c:757:2: error: too few arguments to function 'ohci_dump'

Guenter

