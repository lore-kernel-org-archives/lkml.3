Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab3GTBuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 21:50:23 -0400
Received: from nm41.bullet.mail.bf1.yahoo.com ([216.109.114.57]:44387 "EHLO
	nm41.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752772Ab3GTBuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 21:50:22 -0400
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jul 2013 21:50:21 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 690490.93193.bm@omp1027.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=qxJVWzP6jH2CISQQVMW559I+vinFGj+/oR9rKhFlthkact3M/w7S1rickdKGadg5/SYgu7e2Brnf0vBh1FDj+xkILbWJJNg3BvtFLnzleO+XHfT976JmNhvxPfr4Y/8fzbg3vWeepkFrWDgmNHVoTMhV4pw6tgITOkOsXnTPTPo=;
X-YMail-OSG: XZKbaJoVM1nWBdVOkOfcmTDhlQyK.lUdAvfjbJvRrNFnurb
 qc3y5X58d6rC5xylzct.omtVlVB6wiOb2566Cq19zQWgSPeI0P5BWWrVQZDt
 nlvPRHpQuzjx5mMvyVd44.58XFRctD8nFu9kTqxgmL_3Qcb8SP8fFVdVjIZX
 J.yb9G.I0DlwpirbzTGtqA0tF6EmKHPYO3M.Vw9g8JWNa6HIJcfZ4STiAmTu
 HCUVHMlzw2d_ngdn_CRrYIvdzMuLe9CbRgUPs6v2oVCka1WBK0bNXztHEsbx
 OeHjm1bTjRnSjwsHWNsv.kjyq5imVEKfETyp9DOlYK5EIezwt_fCoD3K2R0r
 UB7vJeRta40E0_HGnjrXJTgY9D7YjMd2zSnKCbw_RTlVswlNmfDfqDW8sFUx
 x8lS78Rd2HoIj8o8FzIgBUqewM.vvS9ciXzyNsCNzqp97FyGC5CBH_0w.i1b
 hOI0WVD_0d4y9bbZHZTNnh15cvRelOydS9XR.UcIaYN8jtVtJ.IbAOwagDBw
 JsRq0lNJAXe9oKTT0clq1a4Q_EDuIlSBQRIq5oFB2zeuXIk30SScN
X-Rocket-MIMEInfo: 002.001,VHdvIGh1bmtzIGZhaWwgZm9yIG1lIHBhdGNoaW5nIHNvdXJjZSBmcm9tIGxpbnV4LTMuMTAudGFyLnh6IGFzIHNob3duOgoKcGF0Y2hpbmcgZmlsZSBEb2N1bWVudGF0aW9uL3BhcmlzYy9yZWdpc3RlcnMKcGF0Y2hpbmcgZmlsZSBNYWtlZmlsZQpIdW5rICMxIEZBSUxFRCBhdCAxLgoxIG91dCBvZiAxIGh1bmsgRkFJTEVEIC0tIHNhdmluZyByZWplY3RzIHRvIGZpbGUgTWFrZWZpbGUucmVqCnBhdGNoaW5nIGZpbGUgYXJjaC9hcm0vYm9vdC9kdHMvaW14MjMuZHRzaQpwYXRjaGluZyBmaWxlIGFyY2gvYXJtL2IBMAEBAQE-
X-Mailer: YahooMailWebService/0.8.149.560
Message-ID: <1374284610.69280.YahooMailNeo@web140002.mail.bf1.yahoo.com>
Date: Fri, 19 Jul 2013 18:43:30 -0700 (PDT)
From: John <da_audiophile@yahoo.com>
Reply-To: John <da_audiophile@yahoo.com>
Subject: Re: [ 00/72] 3.10.2-stable review
To: lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="813071025-2017460223-1374284610=:69280"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--813071025-2017460223-1374284610=:69280
Content-Type: text/plain; charset=us-ascii

Two hunks fail for me patching source from linux-3.10.tar.xz as shown:

patching file Documentation/parisc/registers
patching file Makefile
Hunk #1 FAILED at 1.
1 out of 1 hunk FAILED -- saving rejects to file Makefile.rej
patching file arch/arm/boot/dts/imx23.dtsi
patching file arch/arm/boot/dts/imx28.dtsi
patching file arch/arm/boot/dts/imx6dl.dtsi
patching file arch/arm/boot/dts/imx6q.dtsi
patching file arch/arm/include/asm/mmu_context.h
patching file arch/arm/kernel/perf_event.c
patching file arch/arm/kernel/smp_tlb.c
patching file arch/arm/kernel/smp_twd.c
patching file arch/arm/mach-shmobile/setup-emev2.c
patching file arch/arm/mach-shmobile/setup-r8a73a4.c
patching file arch/arm/mm/context.c
patching file arch/arm/mm/init.c
patching file arch/c6x/mm/init.c
patching file arch/parisc/include/asm/special_insns.h
patching file arch/parisc/include/asm/tlbflush.h
patching file arch/parisc/kernel/cache.c
patching file arch/parisc/lib/memcpy.c
patching file arch/x86/boot/compressed/eboot.c
patching file arch/x86/xen/time.c
patching file drivers/acpi/Makefile
patching file drivers/acpi/acpi_cmos_rtc.c
patching file drivers/acpi/acpica/hwxfsleep.c
patching file drivers/acpi/device_pm.c
patching file drivers/acpi/ec.c
patching file drivers/acpi/internal.h
patching file drivers/acpi/scan.c
patching file drivers/ata/ahci.c
patching file drivers/ata/libahci.c
patching file drivers/block/nbd.c
Hunk #3 succeeded at 745 (offset -1 lines).
patching file drivers/dma/pl330.c
patching file drivers/hid/hid-apple.c
patching file drivers/hid/hid-core.c
patching file drivers/hid/hid-ids.h
patching file drivers/hv/ring_buffer.c
patching file drivers/hv/vmbus_drv.c
patching file drivers/input/mouse/bcm5974.c
patching file drivers/net/wireless/iwlwifi/pcie/tx.c
patching file drivers/net/wireless/rtlwifi/rtl8192cu/rf.c
patching file drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
patching file drivers/net/wireless/rtlwifi/rtl8723ae/sw.c
patching file drivers/parisc/lba_pci.c
patching file drivers/pci/iov.c
patching file drivers/pci/probe.c
patching file drivers/pci/quirks.c
patching file drivers/pci/xen-pcifront.c
patching file drivers/pcmcia/at91_cf.c
patching file drivers/rtc/rtc-rv3029c2.c
patching file drivers/tty/serial/pch_uart.c
patching file drivers/usb/gadget/f_mass_storage.c
patching file drivers/usb/host/ehci-omap.c
patching file drivers/usb/host/xhci-mem.c
patching file drivers/usb/host/xhci-plat.c
patching file drivers/usb/serial/option.c
patching file drivers/usb/serial/qcserial.c
patching file fs/btrfs/ctree.c
patching file fs/btrfs/send.c
patching file fs/cifs/cifs_unicode.h
patching file fs/cifs/cifsencrypt.c
patching file fs/cifs/file.c
patching file fs/cifs/inode.c
patching file fs/ext3/namei.c
patching file fs/ext4/balloc.c
patching file fs/ext4/extents.c
patching file fs/ext4/file.c
patching file fs/ext4/inline.c
patching file fs/ext4/inode.c
patching file fs/ext4/mballoc.c
patching file fs/ext4/namei.c
patching file fs/ext4/resize.c
patching file fs/ext4/super.c
patching file fs/jbd2/journal.c
patching file fs/jbd2/transaction.c
patching file fs/ocfs2/xattr.c
patching file fs/ubifs/super.c
patching file include/linux/cgroup.h
patching file include/linux/nbd.h
patching file kernel/cgroup.c
patching file kernel/irq/manage.c
patching file kernel/timer.c
patching file mm/memcontrol.c
Hunk #1 FAILED at 6296.
1 out of 1 hunk FAILED -- saving rejects to file mm/memcontrol.c.rej
patching file mm/page_alloc.c
patching file mm/slab.c
--813071025-2017460223-1374284610=:69280
Content-Type: text/x-reject; name="Makefile.rej"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="Makefile.rej"

LS0tIE1ha2VmaWxlCisrKyBNYWtlZmlsZQpAQCAtMSw3ICsxLDcgQEAKIFZF
UlNJT04gPSAzCiBQQVRDSExFVkVMID0gMTAKLVNVQkxFVkVMID0gMQotRVhU
UkFWRVJTSU9OID0KK1NVQkxFVkVMID0gMgorRVhUUkFWRVJTSU9OID0gLXJj
MgogTkFNRSA9IFVuaWN5Y2xpbmcgR29yaWxsYQogCiAjICpET0NVTUVOVEFU
SU9OKgo=

--813071025-2017460223-1374284610=:69280
Content-Type: text/x-reject; name="memcontrol.c.rej"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="memcontrol.c.rej"

LS0tIG1tL21lbWNvbnRyb2wuYworKysgbW0vbWVtY29udHJvbC5jCkBAIC02
Mjk2LDE0ICs2Mjk2LDYgQEAKIAogCWVycm9yID0gbWVtY2dfaW5pdF9rbWVt
KG1lbWNnLCAmbWVtX2Nncm91cF9zdWJzeXMpOwogCW11dGV4X3VubG9jaygm
bWVtY2dfY3JlYXRlX211dGV4KTsKLQlpZiAoZXJyb3IpIHsKLQkJLyoKLQkJ
ICogV2UgY2FsbCBwdXQgbm93IGJlY2F1c2Ugb3VyIChhbmQgcGFyZW50J3Mp
IHJlZmNudHMKLQkJICogYXJlIGFscmVhZHkgaW4gcGxhY2UuIG1lbV9jZ3Jv
dXBfcHV0KCkgd2lsbCBpbnRlcm5hbGx5Ci0JCSAqIGNhbGwgX19tZW1fY2dy
b3VwX2ZyZWUsIHNvIHJldHVybiBkaXJlY3RseQotCQkgKi8KLQkJbWVtX2Nn
cm91cF9wdXQobWVtY2cpOwotCX0KIAlyZXR1cm4gZXJyb3I7CiB9CiAK

--813071025-2017460223-1374284610=:69280--
