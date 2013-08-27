Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab3H0BCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 21:02:45 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59185 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751661Ab3H0BCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 21:02:44 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: [ 0/9] 3.0.94-stable review
Date: Mon, 26 Aug 2013 18:04:51 -0700
Message-Id: <20130827010251.636183797@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.0.94 release.
There are 9 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu Aug 29 01:02:44 UTC 2013.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.94-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.0.94-rc1

Martin Peschke <mpeschke@linux.vnet.ibm.com>
    SCSI: zfcp: fix schedule-inside-lock in scsi_device list loops

Martin Peschke <mpeschke@linux.vnet.ibm.com>
    SCSI: zfcp: fix lock imbalance by reworking request queue locking

Terry Suereth <terry.suereth@gmail.com>
    libata: apply behavioral quirks to sil3826 PMP

Dan Carpenter <dan.carpenter@oracle.com>
    Hostap: copying wrong data prism2_ioctl_giwaplist()

Vyacheslav Dubeyko <slava@dubeyko.com>
    nilfs2: fix issue with counting number of bio requests for BIO_EOPNOTSUPP error detection

Vyacheslav Dubeyko <slava@dubeyko.com>
    nilfs2: remove double bio_put() in nilfs_end_bio_write() for BIO_EOPNOTSUPP error

Wladislav Wiebe <wladislav.kw@gmail.com>
    of: fdt: fix memory initialization for expanded DT

David Vrabel <david.vrabel@citrix.com>
    xen/events: initialize local per-cpu mask for all possible events

Jussi Kivilinna <jussi.kivilinna@iki.fi>
    zd1201: do not use stack as URB transfer_buffer


-------------

Diffstat:

 Makefile                                   |  4 +--
 drivers/ata/libata-pmp.c                   | 12 +++----
 drivers/net/wireless/hostap/hostap_ioctl.c |  4 +--
 drivers/net/wireless/zd1201.c              |  4 ++-
 drivers/of/fdt.c                           |  2 ++
 drivers/s390/scsi/zfcp_erp.c               | 29 +++++++++++----
 drivers/s390/scsi/zfcp_qdio.c              |  8 ++---
 drivers/xen/events.c                       |  2 +-
 fs/nilfs2/segbuf.c                         |  5 ++-
 include/linux/wait.h                       | 57 ++++++++++++++++++++++++++++++
 10 files changed, 99 insertions(+), 28 deletions(-)


