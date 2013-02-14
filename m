Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934336Ab3BNMAh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:00:37 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38084 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757462Ab3BNMAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:00:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Andreas Mohr <andi@lisas.de>
Cc: linux-pci@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI / ACPI: Report _OSC control mask returned on failure to get control
Date: Thu, 14 Feb 2013 13:07:02 +0100
Message-ID: <7634687.RmnPKEe4lz@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130214011027.GA430@rhlx01.hs-esslingen.de>
References: <20130214011027.GA430@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, February 14, 2013 02:10:27 AM Andreas Mohr wrote:
> Hi,
> 
> to provide an example case, on Aspire One AOA110 v0.3310, 3.8-rc7 prints:
> 
> [    0.515599] ACPI Error: [CAPB] Namespace lookup failure,
> AE_ALREADY_EXISTS (2
> 0121018/dsfield-211)
> [    0.515629] ACPI Error: Method parse/execution failed
> [\_SB_.PCI0._OSC] (Node f5449680), AE_ALREADY_EXISTS
> (20121018/psparse-537)
> [    0.515672] ACPI: Marking method _OSC as Serialized because of
> AE_ALREADY_EXISTS error
> [    0.516081] ACPI Error: [CAPB] Namespace lookup failure,
> AE_ALREADY_EXISTS (20121018/dsfield-211)
> [    0.516107] ACPI Error: Method parse/execution failed
> [\_SB_.PCI0._OSC] (Node f5449680), AE_ALREADY_EXISTS
> (20121018/psparse-537)
> [    0.516168] pci_root PNP0A08:00: ACPI _OSC support notification
> failed, disabling PCIe ASPM
> [    0.516179] pci_root PNP0A08:00: Unable to request _OSC control (_OSC
> support mask: 0x08)
> 
> HTH,

Unfortunately, it doesn't, because I've lost track of the whole thread in the
meantime.  Care to give a pointer?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
