Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935963Ab3BOMpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 07:45:24 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38272 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935912Ab3BOMpQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 07:45:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <jiang.liu@huawei.com>
Subject: Re: linux-next: manual merge of the pm tree with the pci tree
Date: Fri, 15 Feb 2013 13:51:46 +0100
Message-ID: <1673630.BcVjZeif4m@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130215122313.19a651c33ef3bb60c0f3d827@canb.auug.org.au>
References: <20130215122313.19a651c33ef3bb60c0f3d827@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 15, 2013 12:23:13 PM Stephen Rothwell wrote:
> Hi Rafael,
> 
> Today's linux-next merge of the pm tree got conflicts in
> drivers/acpi/scan.c and drivers/pci/hotplug/acpiphp_glue.c between
> commits 668192b67820 ("PCI: acpiphp: Move host bridge hotplug to
> pci_root.c") and be6d2867b4f6 ("PCI: acpiphp: Remove dead code for PCI
> host bridge hotplug") from the pci tree and commit 3757b94802fb ("ACPI /
> hotplug: Fix concurrency issues and memory leaks") from the pm tree.
> 
> I fixed it up (thanks to Yinghai Lu for the resolution - see below) and
> can carry the fix as necessary (no action is required).

Thanks Stephen!


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
