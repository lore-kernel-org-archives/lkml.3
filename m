Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761418Ab3BNBKa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 20:10:30 -0500
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:60255 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753065Ab3BNBK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 20:10:28 -0500
Date: Thu, 14 Feb 2013 02:10:27 +0100
From: Andreas Mohr <andi@lisas.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pci@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI / ACPI: Report _OSC control mask returned on failure
 to get control
Message-ID: <20130214011027.GA430@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104300021.38386.rjw@sisk.pl>
X-Priority: none
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

to provide an example case, on Aspire One AOA110 v0.3310, 3.8-rc7 prints:

[    0.515599] ACPI Error: [CAPB] Namespace lookup failure,
AE_ALREADY_EXISTS (2
0121018/dsfield-211)
[    0.515629] ACPI Error: Method parse/execution failed
[\_SB_.PCI0._OSC] (Node f5449680), AE_ALREADY_EXISTS
(20121018/psparse-537)
[    0.515672] ACPI: Marking method _OSC as Serialized because of
AE_ALREADY_EXISTS error
[    0.516081] ACPI Error: [CAPB] Namespace lookup failure,
AE_ALREADY_EXISTS (20121018/dsfield-211)
[    0.516107] ACPI Error: Method parse/execution failed
[\_SB_.PCI0._OSC] (Node f5449680), AE_ALREADY_EXISTS
(20121018/psparse-537)
[    0.516168] pci_root PNP0A08:00: ACPI _OSC support notification
failed, disabling PCIe ASPM
[    0.516179] pci_root PNP0A08:00: Unable to request _OSC control (_OSC
support mask: 0x08)

HTH,

Andreas Mohr
