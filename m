Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933025AbaICVbX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:31:23 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51317 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756519AbaICVbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:31:22 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/6] ACPICA: 20140828 Release
Date: Wed, 03 Sep 2014 23:50:42 +0200
Message-ID: <1966694.0lc65JeaWh@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <cover.1409617516.git.lv.zheng@intel.com>
References: <cover.1409617516.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 02, 2014 08:26:59 AM Lv Zheng wrote:
> The 20140828 ACPICA kernel-resident subsystem updates are linuxized based
> on the pm/linux-next branch to form this patchset.
> 
> The patchset has passed the following build/boot tests.
> Build tests are performed as follows:
> 1. i386 + default + COFNIG_ACPI=y
> 2. i386 + allyes + CONFIG_ACPI=y
> 3. i386 + default + COFNIG_ACPI=n
> 4. i386 + allyes + CONFIG_ACPI=n
> 5. x86_64 + default + COFNIG_ACPI=y
> 6. x86_64 + allyes + CONFIG_ACPI=y
> 7. x86_64 + default + COFNIG_ACPI=n
> 8. x86_64 + allyes + CONFIG_ACPI=n
> Boot tests are performed as follows:
> 1. i386 + default + COFNIG_ACPI=y
> 2. x86_64 + default + COFNIG_ACPI=y
> Where:
> 1. i386: machine named as "Dell Inspiron Mini 1010"
> 2. x86_64: machine named as "HP Compaq 8200 Elite SFF PC"
> 3. default: kernel configuration with following items enabled:
>    All hardware drivers related to the machines of i386/x86_64
>    All drivers/acpi configurations
>    All platform drivers
> 
> The divergences checking result:
> Before applying (20140724 Release):
>   848 lines
> After applying (20140828 Release):
>   710 lines
> 
> Bob Moore (3):
>   ACPICA: Add _PSx names to the METHOD_NAME list.
>   ACPICA: Disassembler: Fix for gpio_int interrupt polarity flags.
>   ACPICA: Update version to 20140828.
> 
> Hanjun Guo (2):
>   ACPICA: ACPI 5.1/Disassembler: Add GICC affinity subtable to SRAT
>     table.
>   ACPICA: Headers: Add GTDT flag definitions for the timer subtable.
> 
> Mika Westerberg (1):
>   ACPICA: ACPI 5.1: Add support for runtime validation of _DSD package.
> 
>  drivers/acpi/acpica/nsprepkg.c |   39 +++++++++++++++++++++++++++++++++++++++
>  drivers/acpi/acpica/utresrc.c  |    4 +++-
>  include/acpi/acnames.h         |    4 ++++
>  include/acpi/acpixf.h          |    2 +-
>  include/acpi/actbl1.h          |   19 +++++++++++++++++--
>  include/acpi/actbl3.h          |    9 +++++++--
>  6 files changed, 71 insertions(+), 6 deletions(-)

Patch series queued up for 3.18 except for [5/6] that has already been queued
up for 3.17-rc4.  Thanks!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
