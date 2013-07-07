Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3GGXJh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 19:09:37 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:33705 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab3GGXJf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 19:09:35 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 0/2] PCI / ACPI cleanups
Date: Mon, 08 Jul 2013 01:15:31 +0200
Message-ID: <1468174.eo7i60DZFT@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These two patches clean up the ACPI part of the PCI core and ACPIPHP.

[1/2] Make bus registration and unregistration symmetric.
[2/2] Consolidate acpiphp_enumerate_slots().

They are on top of 3.10 plus my 3.11 queue (should apply on plain 3.10),
but if they look good, I'll add them to the previous ACPI dock cleanups.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
