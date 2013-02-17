Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756470Ab3BQPVa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2013 10:21:30 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:39055 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756388Ab3BQPV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2013 10:21:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Jiang Liu <liuj97@gmail.com>
Subject: [PATCH 0/7] ACPI / hotplug: Common code for ACPI-based hotplug
Date: Sun, 17 Feb 2013 16:18:31 +0100
Message-ID: <3260206.bhaAobGhpZ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc7; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The following patches introduce common code for ACPI-based hotplug for non-PCI
devices and modify the container and memory hotplug ACPI drivers to use the new
code.

This is based on linux-pm.git/master and regarded as v3.10 material.

[1/7] Introduce acpi_scan_match_handler() that will be useful going forward.
[2/7] Introduce common code for ACPI-base device hotplug.
[3/7] Use the new commot hotplug code in the container driver.
[4/7] Introduce acpi_scan_handler_matching() that will be useful subsequently.
[5/7] Introduce user space interface for hotplug profiles.
[6/7] Make the container driver use the hotplug profiles user space interface.
[7/7] Make the memory hotplug driver use struct acpi_scan_handler along with
      the hotplug profiles user space interface.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
