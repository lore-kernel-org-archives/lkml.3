Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab3KDALE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Nov 2013 19:11:04 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52034 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752021Ab3KDAKE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Nov 2013 19:10:04 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 0/3] ACPI scan and hotplug fixes for 3.14
Date: Mon, 04 Nov 2013 01:17:12 +0100
Message-ID: <5839747.7HXXGHmMBd@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following three patches fix some issues that we have in the common ACPI
hotplug infrastructure.

If anyone sees any problems with them, please let me know.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
