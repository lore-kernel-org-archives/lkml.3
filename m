Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab3BCXlx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 18:41:53 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:60237 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753942Ab3BCXl1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 18:41:27 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] ACPI scan handler for memory hotplug and container simplification
Date: Mon, 04 Feb 2013 00:45:06 +0100
Message-ID: <3164478.OcagzIMET0@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <4311642.nDd2RCVeDc@vostro.rjw.lan>
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <4311642.nDd2RCVeDc@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

Patch [1/2] in this series makes the ACPI memory hotplug driver use struct
acpi_scan_handler instead of struct acpi_driver and changes the driver to
non-modular (as a consequence).

Patch [2/2] is a bit funny, though.  I though I'd make the container driver
use struct acpi_scan_handler instead of struct acpi_driver too, but then I
noticed that its struct acpi_driver and everything it does is just plain
garbage without any use whatsoever, so the patch simply drops that stuff.

Both on top of linux-pm.git/bleeding-edge.  Unfortunately, I don't have the
hardware to test those things, so if anyone can test them, I'll appreciate it
a lot.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
