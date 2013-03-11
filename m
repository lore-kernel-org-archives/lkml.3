Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3CKQiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:38:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:12992 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753605Ab3CKQiw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:38:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,824,1355126400"; 
   d="scan'208";a="276518998"
Message-ID: <1363019977.3348.53.camel@sauron.fi.intel.com>
Subject: Re: UBI. How are critical these messages?
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: "Velykokhatko, Sergey" <Sergey.Velykokhatko@mcc-med.de>
Cc: Richard Genoud <richard.genoud@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ricard Wanderlof <ricard.wanderlof@axis.com>
Date: Mon, 11 Mar 2013 18:39:37 +0200
In-Reply-To: <BAF0C2081321BA469F9ADF648F97D9B04C78FA60DB@MCC023.weinmann.com>
References: <BAF0C2081321BA469F9ADF648F97D9B04C78FA6069@MCC023.weinmann.com>
	 <CAN8TOE9YJBvUE9GDW3krZB-Js6gUkqY23gYNLS4gFX0e2NDNZw@mail.gmail.com>
	 <BAF0C2081321BA469F9ADF648F97D9B04C78FA6071@MCC023.weinmann.com>
	 <CACQ1gAg0rE+X+uxRWbrPKhmdS1T0MG00cwwBbzWM+VwU4zaXmw@mail.gmail.com>
	 <BAF0C2081321BA469F9ADF648F97D9B04C78FA607C@MCC023.weinmann.com>
	 <CACQ1gAg=L7ru5J4C7OQN0r-c2VN3baKX1qqty8Z0ObS5Wk48yg@mail.gmail.com>
	 <BAF0C2081321BA469F9ADF648F97D9B04C78FA607E@MCC023.weinmann.com>
	 <CACQ1gAhJzy5tGSuejc3GqaqRxtHvkABOY-tODzedveeRXddvxQ@mail.gmail.com>
	 <1362989331.5101.41.camel@sauron.fi.intel.com>
	 <BAF0C2081321BA469F9ADF648F97D9B04C78FA60DB@MCC023.weinmann.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-03-11 at 17:13 +0100, Velykokhatko, Sergey wrote:
> Mar  8 12:38:45 192 kern.notice kernel: [    9.906000] UBI: attaching mtd5 to ubi1
> Mar  8 12:38:45 192 kern.err kernel: [   10.359000] ecc unrecoverable error
> Mar  8 12:38:45 192 kern.warn kernel: [   10.363000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 1110:0, read only 64 bytes, retry
> Mar  8 12:38:45 192 kern.err kernel: [   10.374000] ecc unrecoverable error
> Mar  8 12:38:45 192 kern.warn kernel: [   10.378000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 1110:0, read only 64 bytes, retry
> Mar  8 12:38:45 192 kern.err kernel: [   10.390000] ecc unrecoverable error
> Mar  8 12:38:45 192 kern.warn kernel: [   10.393000] UBI warning: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 1110:0, read only 64 bytes, retry
> Mar  8 12:38:45 192 kern.err kernel: [   10.405000] ecc unrecoverable error
> Mar  8 12:38:45 192 kern.err kernel: [   10.408000] UBI error: ubi_io_read: error -74 (ECC error) while reading 64 bytes from PEB 1110:0, read 64 bytes
> Mar  8 12:38:45 192 kern.warn kernel: [   10.418000] Backtrace:
> Mar  8 12:38:45 192 kern.warn kernel: [   10.421000] [<c000c614>] (dump_backtrace+0x0/0x114) from [<c0315e80>] (dump_stack+0x20/0x24)
> Mar  8 12:38:45 192 kern.warn kernel: [   10.429000]  r6:c3ac2000 r5:00000040 r4:ffffffb6 r3:c0460e34
> Mar  8 12:38:45 192 kern.warn kernel: [   10.435000] [<c0315e60>] (dump_stack+0x0/0x24) from [<c021042c>] (ubi_io_read+0x1e8/0x2b4)
> Mar  8 12:38:45 192 kern.warn kernel: [   10.443000] [<c0210244>] (ubi_io_read+0x0/0x2b4) from [<c021077c>] (ubi_io_read_ec_hdr+0x7c/0x22c)
> Mar  8 12:38:45 192 kern.warn kernel: [   10.452000] [<c0210700>] (ubi_io_read_ec_hdr+0x0/0x22c) from [<c0215330>] (ubi_attach+0x118/0x13c4)
> Mar  8 12:38:45 192 kern.warn kernel: [   10.461000] [<c0215218>] (ubi_attach+0x0/0x13c4) from [<c020a8c0>] (ubi_attach_mtd_dev+0x5a8/0xbd8)
> Mar  8 12:38:45 192 kern.warn kernel: [   10.470000] [<c020a318>] (ubi_attach_mtd_dev+0x0/0xbd8) from [<c020b18c>] (ctrl_cdev_ioctl+0xe0/0x194)
> Mar  8 12:38:45 192 kern.warn kernel: [   10.479000] [<c020b0ac>] (ctrl_cdev_ioctl+0x0/0x194) from [<c00d5a40>] (vfs_ioctl+0x38/0x4c)
> Mar  8 12:38:45 192 kern.warn kernel: [   10.488000]  r7:40186f40 r6:00000000 r5:c38880a0 r4:be880bd8
> Mar  8 12:38:45 192 kern.warn kernel: [   10.494000] [<c00d5a08>] (vfs_ioctl+0x0/0x4c) from [<c00d6608>] (do_vfs_ioctl+0x55c/0x5c4)
> Mar  8 12:38:45 192 kern.warn kernel: [   10.502000] [<c00d60ac>] (do_vfs_ioctl+0x0/0x5c4) from [<c00d66b8>] (sys_ioctl+0x48/0x70)
> Mar  8 12:38:45 192 kern.warn kernel: [   10.510000] [<c00d6670>] (sys_ioctl+0x0/0x70) from [<c0009480>] (ret_fast_syscall+0x0/0x44)
> Mar  8 12:38:45 192 kern.warn kernel: [   10.518000]  r8:c00096e4 r7:00000036 r6:0000c8e0 r5:be880bd8 r4:00000003

These look like a broken driver, not an UBI/UBIFS problem. Try to run
MTD tests and validate your driver in the modern kernel first. The MTD
tests are kernel module, they work by insmoding. You should find some
info on the MTD website.

-- 
Best Regards,
Artem Bityutskiy

