Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab3GHNZS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 09:25:18 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34452 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752035Ab3GHNZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 09:25:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 0/3] ACPI / hotplug / PCI: Rework of events handling
Date: Mon, 08 Jul 2013 15:27:22 +0200
Message-ID: <5361579.8un1t1TCfk@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1468174.eo7i60DZFT@vostro.rjw.lan>
References: <1468174.eo7i60DZFT@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Yesterday I started looking into reworking acpiphp and the following is what
I have at the moment, on top of 3.10 with my 3.11 material merged and the
cleanups I posted yesterday:

https://patchwork.kernel.org/patch/2824650/
https://patchwork.kernel.org/patch/2824649/

Eventually, I'm going to rebase all that on top of the bleeding-edge branch
of my tree.

[1/3] Fix error code path in register_slot().
[2/3] Introduce hotplug context objects for ACPI device objects corresponding
      to PCI hotplug devices.
[3/3] Unified notify handler for hotplug events.

This hasn't been tested yet and I'm sending it just to let you know what
direction it is going into and to get some early feedback, if any.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
