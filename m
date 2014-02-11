Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753377AbaBKAEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 19:04:42 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:55629 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752932AbaBKAEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 19:04:31 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PCI <linux-pci@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 0/2] ACPI / hotplug / PCI: Work along with PCIe native hotplug
Date: Tue, 11 Feb 2014 01:17:13 +0100
Message-ID: <1461050.jQppMgDSvA@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Patch [2/2] in this series makes ACPIPHP add its hotplug contexts to devices
that should be handler by PCIeHP (the changelog explains why that should be
safe now).  Patch [1/2] is just a function rename.

Both are on top of the current linux-next branch of linux-pm.git.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
