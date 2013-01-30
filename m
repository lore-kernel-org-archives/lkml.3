Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab3A3Mmk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 07:42:40 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60981 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751153Ab3A3Mmi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 07:42:38 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: linux-next: manual merge of the pm tree with the pci tree
Date: Wed, 30 Jan 2013 13:48:47 +0100
Message-ID: <5316945.RWkDAdU9QW@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130130193551.075bfa10acd39aec315a7787@canb.auug.org.au>
References: <20130130193551.075bfa10acd39aec315a7787@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday, January 30, 2013 07:35:51 PM Stephen Rothwell wrote:
> Hi Rafael,
> 
> Today's linux-next merge of the pm tree got a conflict in
> drivers/acpi/internal.h between commit 668192b67820 ("PCI: acpiphp: Move
> host bridge hotplug to pci_root.c") from the pci tree and commit
> 2c545601d933 ("ACPI / PCI: Make PCI root driver use struct
> acpi_scan_handler") from the pm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thanks for resolving the conflict, that's the right fix.

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
