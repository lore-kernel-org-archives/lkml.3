Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752621Ab3KYACc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 19:02:32 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63915 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752142Ab3KYABq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 19:01:46 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH 0/4] ACPI / bind: Simplify child devices lookup
Date: Mon, 25 Nov 2013 01:09:30 +0100
Message-ID: <2610478.KxPMyuOMok@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following series of four patches (on top of current linux-pm.git/bleeding-edge)
rework child device lookup in drivers/acpi/glue.c and related things:

[1/4] ACPI / bind: Simplify child device lookup
[2/4] PCI/ ACPI: Use acpi_find_child_device() for child device lookup
[3/4] ACPI / bind: Redefine acpi_get_child()
[4/4] ACPI / bind: Redefine acpi_preset_companion()

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
