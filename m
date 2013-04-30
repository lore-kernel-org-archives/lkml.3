Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761358Ab3D3W07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 18:26:59 -0400
Received: from havoc.gtf.org ([69.61.125.42]:43273 "EHLO havoc.gtf.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760097Ab3D3W0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 18:26:55 -0400
Date: Tue, 30 Apr 2013 18:26:54 -0400
From: Jeff Garzik <jeff@garzik.org>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [git patches] libata updates
Message-ID: <20130430222654.GA16716@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Summary:

1) More ACPI fixes, cleanups

2) Minor cleanups for sata_highbank, pata_at32, pata_octeon_cf,
   sata_rcar

3) pata_legacy: small bug found in opti chipset code (untested fix,
   due to ancient h/w)

4) sata_fsl: RX water mark config knob, some h/w needs it

5) pata_imx: cleanups, DeviceTree support

6) SCSI<->ATA translator: properly export translator version,
   not device firmware version


Please pull 2cc1144a31f76d4a9fb48bec5d6ba1359f980813 from
git://git.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git tags/upstream-linus


to receive the following updates:

Aaron Lu (2):
      libata-acpi: remove redundent code for power resource handling
      [libata] acpi: make ata_ap_acpi_handle not block

Alexandru Gheorghiu (1):
      pata_octeon_cf: Use resource_size function

Baruch Even (1):
      [libata] SCSI: really use SATL version in VPD

Dan Carpenter (1):
      pata_legacy: bogus clock in opti82c46x_set_piomode()

Jingoo Han (2):
      pata_at32: use module_platform_driver_probe()
      sata_highbank: make ahci_highbank_pm_ops static

Lv Zheng (1):
      ACPI/libata: Restore libata.noacpi support

Qiang Liu (1):
      fsl/sata: create a sysfs entry for rx water mark

Robert Richter (1):
      sata_highbank: Rename proc_name to the module name

Sachin Kamat (1):
      sata_rcar: Convert to devm_ioremap_resource()

Sascha Hauer (4):
      pata_imx: Use devm_clk_get
      pata_imx: cleanup error path
      pata_imx: use void __iomem * for regs
      pata_imx: add devicetree support

