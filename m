Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279AbaAVMYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 07:24:51 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:59775 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359AbaAVMYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 07:24:50 -0500
MIME-Version: 1.0
In-Reply-To: <CA+V-a8vcvTRpP-cE6SKd1KgWgzSbOXvSNW+5Jh8wqOfr1za4SQ@mail.gmail.com>
References: <CA+V-a8vcvTRpP-cE6SKd1KgWgzSbOXvSNW+5Jh8wqOfr1za4SQ@mail.gmail.com>
From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Wed, 22 Jan 2014 17:54:29 +0530
Message-ID: <CA+V-a8uy6wM8nS993VeezJGOaoqM5GRsJE7FrKe7=bhD6nZhXw@mail.gmail.com>
Subject: Re: Kconfig errors
To: Russell King <rmk+kernel@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>
Cc: dlos <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

On Fri, Jan 17, 2014 at 1:07 PM, Prabhakar Lad
<prabhakar.csengg@gmail.com> wrote:
> Hi,
>
> On Linux-next branch I see following errors for davinci_all_defconfig
> & da8xx_omapl_defconfig configs,
>
> arch/arm/Kconfig:1966:error: recursive dependency detected!
> arch/arm/Kconfig:1966:    symbol ZBOOT_ROM depends on AUTO_ZRELADDR
> arch/arm/Kconfig:2154:    symbol AUTO_ZRELADDR is selected by ZBOOT_ROM
> #
> # configuration written to .config
> #
>
I am seeing this errors on linux-next, with your recent patch,
"[PATCH] Fix select-induced Kconfig warning for ZBOOT_ROM"
and strangely I see that AUTO_ZRELADDR doesnt select ZBOOT_ROM
but still an error.

Note: For the davinci configs CONFIG_AUTO_ZRELADDR is not set and
CONFIG_ZBOOT_ROM_TEXT=0x0, CONFIG_ZBOOT_ROM_BSS=0x0

Regards,
--Prabhakar Lad
