Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751173AbaLCCDO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 21:03:14 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:53929 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750840AbaLCCDM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 21:03:12 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Lv Zheng <lv.zheng@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Lv Zheng <zetalog@gmail.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/6] ACPICA: 20141107 Release
Date: Wed, 03 Dec 2014 03:24:37 +0100
Message-ID: <1627799.tSWF0zJxfk@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <cover.1416899966.git.lv.zheng@intel.com>
References: <cover.1416899966.git.lv.zheng@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 27, 2014 02:25:53 PM Lv Zheng wrote:
> The 20141107 ACPICA kernel-resident subsystem updates are linuxized based
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
> Before applying (20140926 Release):
>   852 lines
> After applying (20141107 Release):
>   852 lines
> 
> Bob Moore (6):
>   ACPICA: iASL: Add support for to_PLD macro.
>   ACPICA: acpiexec: Add option to specify an object initialization
>     file.
>   ACPICA: Disassembler: Add support for C-style operators and
>     expressions.
>   ACPICA: Disassembler: Update for C-style expressions.
>   ACPICA: Disassembler: Emit correct string for 0 stop bits.
>   ACPICA: Update version to 20141107.
> 
>  drivers/acpi/acpica/acglobal.h |    1 +
>  drivers/acpi/acpica/aclocal.h  |    3 +++
>  drivers/acpi/acpica/utresrc.c  |    2 +-
>  drivers/acpi/acpica/utxface.c  |    4 +++-
>  drivers/acpi/acpica/utxfinit.c |   11 +++++++++++
>  include/acpi/acbuffer.h        |   14 +++++++++++---
>  include/acpi/acpixf.h          |    2 +-
>  7 files changed, 31 insertions(+), 6 deletions(-)

All queued up for 3.19-rc1, thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
