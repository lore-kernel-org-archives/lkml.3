Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753855Ab3ERX17 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 May 2013 19:27:59 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:34481 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622Ab3ERX1M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 May 2013 19:27:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Toshi Kani <toshi.kani@hp.com>, Wen Congyang <wency@cn.fujitsu.com>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiang Liu <liuj97@gmail.com>,
        Vasilis Liaskovitis <vasilis.liaskovitis@profitbricks.com>,
        linux-mm@kvack.org
Subject: [PATCH 0/5] ACPI / scan / memhotplug: ACPI hotplug rework followup changes
Date: Sun, 19 May 2013 01:29:43 +0200
Message-ID: <2250271.rGYN6WlBxf@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series contains changes that are possible on top of the linux-pm.git
tree's acpi-hotplug branch.  They touch ACPI, driver core and the core memory
hotplug code and the majority of them are about removing code that's not
necessary any more.

Please review and let me know if there's anything wrong with any of them.

[1/5] Drop the struct acpi_device's removal_type field that's not used any more.
[2/5] Pass processor object handle to acpi_bind_one()
[3/5] Replace offline_memory_block() with device_offline().
[4/5] Add second pass of companion offlining to acpi_scan_hot_remove().
[5/5] Drop ACPI memory hotplug code that's not necessary any more.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
