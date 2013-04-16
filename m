Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965144Ab3DPRpY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 13:45:24 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34450 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964879Ab3DPRpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 13:45:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: linux-next: manual merge of the pm tree with the pci tree
Date: Tue, 16 Apr 2013 19:53:11 +0200
Message-ID: <2351812.ay6x6qW83M@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0-rc6+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130416124611.3dd55ea49fc6724e0994ed8e@canb.auug.org.au>
References: <20130416124611.3dd55ea49fc6724e0994ed8e@canb.auug.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 16, 2013 12:46:11 PM Stephen Rothwell wrote:
> Hi Rafael,
> 
> Today's linux-next merge of the pm tree got a conflict in
> drivers/acpi/scan.c between commit 5c0b04e3d913 ("PCI/ACPI: Handle PCI
> slot devices when creating/destroying PCI buses") from the pci tree and
> commit 0a34764411aa ("ACPI / scan: Make memory hotplug driver use struct
> acpi_scan_handler") from the pm tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

The fix look correct, thanks a lot for taking care of this!

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
