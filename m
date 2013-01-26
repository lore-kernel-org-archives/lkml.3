Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab3AZWiT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 17:38:19 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:56741 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754692Ab3AZWhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 17:37:48 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 0/2] ACPI / scan: Additional changes
Date: Sat, 26 Jan 2013 23:39:04 +0100
Message-ID: <1581701.fnbebHrKch@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

The following patches make two more changes to the ACPI namespace scanning
code that I think are more-or-less useful:

[1/2] Introduce lock to prevent acpi_bus_scan() from running in parallel with
      acpi_bus_trim() to avoid removing device nodes while we're setting
      them up.
[2/2] Change the scanning of fixed device nodes to work along the lines of
      acpi_bus_scan().

Patch [1/2] should apply on top of the acpi-scan branch, but [2/2] needs the
entire linux-pm.git/linux-next branch.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
