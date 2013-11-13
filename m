Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750992Ab3KMXOk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 18:14:40 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62114 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752002Ab3KMXOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 18:14:24 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Jarkko Nikula <jarkko.nikula@linux.intel.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: [PATCH 0/2] ACPI: Additional changes on top of "ACPI / driver core: Store a device pointer in struct acpi_dev_node"
Date: Thu, 14 Nov 2013 00:25:18 +0100
Message-ID: <1803808.ghCmmaO2Cj@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <3268437.YsusHvklcv@vostro.rjw.lan>
References: <3268437.YsusHvklcv@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Everybody,

The following two patches make changes that in my opinion are worth making on
top of https://patchwork.kernel.org/patch/3167391/ .  The first one simply
replaces DEVICE_ACPI_HANDLE with ACPI_HANDLE everywhere (as the former is now
a simple alias of the latter) and the second one adds ACPI device reference
counting to acpi_bind_one()/acpi_unbind_one() to help catch device removal
ordering issues that would cause the kernel to crash.

Thanks,
Rafael

