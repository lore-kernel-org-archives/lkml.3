Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756384AbaGSX1O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 19:27:14 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62265 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756322AbaGSX1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 19:27:10 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Hanjun Guo <hanjun.guo@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Graeme Gregory <graeme.gregory@linaro.org>,
        Tony Luck <tony.luck@intel.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v3 0/3] Clean up ACPI core to prepare for running ACPI on ARM64
Date: Sun, 20 Jul 2014 01:45:29 +0200
Message-ID: <12808483.rIsXFzJSCT@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1405677774-16787-1-git-send-email-hanjun.guo@linaro.org>
References: <1405677774-16787-1-git-send-email-hanjun.guo@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, July 18, 2014 06:02:51 PM Hanjun Guo wrote:
> This patch set have no function change for x86 and ia64 and
> just do some clean up to prepare for running ACPI on ARM64.
> 
> This patch set is splited out from the patch set [1]
> "[PATCH v4 00/13] Enable ACPI on ARM64 in Kconfig" and hope it
> can be merged first before ARM64 ACPI core patches.
> 
> [1]: https://lkml.org/lkml/2014/6/26/627
> 
> update from v2:
> Don not select ACPI_LEGACY_TABLES_LOOKUP on IA64 which
> is catched by Peter.
> 
> update from v1:
> 1. Drop "Make EC debugfs depend on X86 || IA64 in Kconfig";
> 2. Rename ACPI_SCAN_BIOS_NOT_EFI to ACPI_LEGACY_TABLES_LOOKUP
>    suggested by Rafael;
> 3. Rename ARCH_HAS_ACPI_PDC to ARCH_MIGHT_HAVE_ACPI_PDC suggested by Rafael;
> 4. Remove the help for ARCH_MIGHT_HAVE_ACPI_PDC because it can't be selected;
> 5. Rename acpi_arch_is_smp() to acpi_has_cpu_in_madt() to be more
>    explicit and easy understanding.
> 
> Graeme Gregory (2):
>   ACPI: ARM64 does not have a BIOS add config for BIOS table scan.
>   ACPI: Don't use acpi_lapic in ACPI core code
> 
> Hanjun Guo (1):
>   ACPI / processor: Introduce ARCH_HAS_ACPI_PDC

Series queued up for 3.17 with minor changes of patch subjects.  Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
