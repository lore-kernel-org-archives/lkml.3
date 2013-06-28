Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab3F1TjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:39:14 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54398 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab3F1Tir (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 15:38:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiang Liu <liuj97@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E. Patrakov" <patrakov@gmail.com>
Subject: [PATCH 0/4] ACPI / dock: Cleanups and simplifications
Date: Fri, 28 Jun 2013 21:44:18 +0200
Message-ID: <1640211.P0jyS5muX2@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following patches clean up and simplify dock.c slightly.

They conflict with the Gerry's changes currently, but I'll fix them up if
everyone is comfortable with the changes.

[1/4] Remove hp_lock from struct dock_station.
[2/4] Rework find_dock_devices() (so that it doesn't worry about parents).
[3/4] Walk the list of dependent devices in reverse order on removal.
[4/4] Simplify dock_init_hotplug() and dock_release_hotplug()

Patches [1-3/4] have been tested by Alexander Patrakov on his Sony Vaio with
a docking station and he haven't seen any problems related to them.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
