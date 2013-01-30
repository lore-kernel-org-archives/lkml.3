Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab3A3V6R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 16:58:17 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:34421 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757075Ab3A3V6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:58:00 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Toshi Kani <toshi.kani@hp.com>
Subject: [PATCH 0/2] ACPI / scan: Fix and cleanup related to acpi_bus_get_device()
Date: Wed, 30 Jan 2013 23:02:06 +0100
Message-ID: <1451967.YMyGeCCNtu@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc5; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

One fix and one cleanup related to acpi_bus_get_device() follow:

[1/2] Fix acpi_bus_get_device() check in acpi_match_device()
[2/2] Clean up acpi_bus_get_parent()

On top of linux-pm/linux-next.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
