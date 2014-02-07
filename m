Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751651AbaBGBE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 20:04:57 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55536 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750706AbaBGBE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 20:04:56 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bastien Traverse <bastien.traverse@gmail.com>
Cc: Peter Wu <lekensteyn@gmail.com>, linux-kernel@vger.kernel.org,
        francis.moro@gmail.com, linux-pm@vger.kernel.org
Subject: Re: 3.12: ethernet controller missing after resuming from suspend to RAM
Date: Fri, 07 Feb 2014 02:19:27 +0100
Message-ID: <2087423.Qy7HQIx1X6@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <52F41DB8.3080802@gmail.com>
References: <52F2CC7B.80406@gmail.com> <55671594.HynIX0trOC@vostro.rjw.lan> <52F41DB8.3080802@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 07, 2014 12:41:44 AM Bastien Traverse wrote:

[...]

> [  200.934601] ACPI: Waking up from system sleep state S3
> [  200.993469] xhci_hcd 0000:00:14.0: System wakeup disabled by ACPI
> [  201.006819] ehci-pci 0000:00:1a.0: System wakeup disabled by ACPI
> [  201.033495] ehci-pci 0000:00:1d.0: System wakeup disabled by ACPI
> [  201.087040] PM: noirq resume of devices complete after 118.140 msecs
> [  201.087233] PM: early resume of devices complete after 0.169 msecs
> [  201.087270] i915 0000:00:02.0: setting latency timer to 64
> [  201.087272] xhci_hcd 0000:00:14.0: setting latency timer to 64
> [  201.087456] ehci-pci 0000:00:1a.0: setting latency timer to 64
> [  201.087597] snd_hda_intel 0000:00:1b.0: irq 43 for MSI/MSI-X
> [  201.090717] ahci 0000:00:1f.2: setting latency timer to 64
> [  201.090802] ehci-pci 0000:00:1d.0: setting latency timer to 64
> [  201.090889] r8169 0000:03:00.2: System wakeup disabled by ACPI

The device appears to be alive here.

> [  201.430358] ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  201.437019] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
> [  201.509645] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
> succeeded
> [  201.509647] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
> LOCK) filtered out
> [  201.509649] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
> CONFIGURATION OVERLAY) filtered out
> [  201.509919] ata5.00: supports DRM functions and may not be fully
> accessible
> [  201.516754] ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
> succeeded
> [  201.516756] ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
> LOCK) filtered out
> [  201.516757] ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
> CONFIGURATION OVERLAY) filtered out
> [  201.516998] ata5.00: supports DRM functions and may not be fully
> accessible
> [  201.523170] ata5.00: configured for UDMA/133
> [  201.528884] ata3.00: configured for UDMA/100
> [  201.533818] sd 4:0:0:0: [sdb] Starting disk
> [  202.197508] [drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp on
> [  203.695165] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
> [  203.701879] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
> succeeded
> [  203.701883] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
> LOCK) filtered out
> [  203.701885] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
> CONFIGURATION OVERLAY) filtered out
> [  203.715038] ata1.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES)
> succeeded
> [  203.715042] ata1.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE
> LOCK) filtered out
> [  203.715044] ata1.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE
> CONFIGURATION OVERLAY) filtered out
> [  203.721440] ata1.00: configured for UDMA/133
> [  203.731960] sd 0:0:0:0: [sda] Starting disk
> [  203.757734] PM: resume of devices complete after 2668.846 msecs
> [  203.758038] PM: Finishing wakeup.
> [  203.758039] Restarting tasks ... done.
> [  203.758936] video LNXVIDEO:00: Restoring backlight state
> [  203.784008] iwlwifi 0000:02:00.0: L1 Disabled; Enabling L0S
> [  203.792083] iwlwifi 0000:02:00.0: Radio type=0x2-0x0-0x0
> [  203.856125] IPv6: ADDRCONF(NETDEV_UP): wlp2s0: link is not ready
> [  203.928106] r8169 0000:03:00.2 enp3s0f2: link down

And here.

> [  203.928145] IPv6: ADDRCONF(NETDEV_UP): enp3s0f2: link is not ready
> [  204.999379] wlp2s0: authenticate with [MAC_STRIPPED]
> [  205.003235] wlp2s0: send auth to [MAC_STRIPPED] (try 1/3)
> [  205.005976] wlp2s0: authenticated
> [  205.009250] wlp2s0: associate with [MAC_STRIPPED] (try 1/3)
> [  205.019312] wlp2s0: RX AssocResp from [MAC_STRIPPED] (capab=0x411
> status=0 aid=4)
> [  205.043032] wlp2s0: associated
> [  205.043069] IPv6: ADDRCONF(NETDEV_CHANGE): wlp2s0: link becomes ready

And there's no comments indicating any hotplug-related activity.

> Here's the diff between before/after lspci -nnvt:
> 9,10c9
> <            +-1c.3-[03]--+-00.0  Realtek Semiconductor Co., Ltd. Device
> [10ec:5289]
> <            |            \-00.2  Realtek Semiconductor Co., Ltd.
> RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller [10ec:8168]
> ---
> >            +-1c.3-[03]--
> 
> Please tell me if you need the lspci log in complete form or how to tune
> the diff command.

Please send the output of lspci -vv right before suspend and right after
the subsequent resume as attachments.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
