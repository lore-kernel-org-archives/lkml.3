Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab3BRMXe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 07:23:34 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39374 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751313Ab3BRMXc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 07:23:32 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: Re: linux-next: manual merge of the pm tree with the pci tree
Date: Mon, 18 Feb 2013 13:30:07 +0100
Message-ID: <4213948.yH271Q6ZRX@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130218121105.e728f240b75b73821ff8058d@canb.auug.org.au>
References: <20130218121105.e728f240b75b73821ff8058d@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Monday, February 18, 2013 12:11:05 PM Stephen Rothwell wrote:
> Hi Rafael,
> 
> Today's linux-next merge of the pm tree got a conflict in
> drivers/acpi/internal.h between commits 668192b67820 ("PCI: acpiphp: Move
> host bridge hotplug to pci_root.c") and ab1a2e038ff2 ("ACPI / PCI: Make
> pci_slot built-in only, not a module") from the pci tree and commit
> 00c43b968250 ("ACPI / PCI: Make PCI root driver use struct
> acpi_scan_handler") from the pm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks for the notice and the fix.

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
