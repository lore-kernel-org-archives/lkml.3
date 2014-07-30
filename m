Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754716AbaG3BtM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 21:49:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657AbaG3BtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:09 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 00/10] 3.4.101-stable review
Date: Tue, 29 Jul 2014 18:48:31 -0700
Message-Id: <20140730014807.477761030@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
User-Agent: quilt/0.63-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.101 release.
There are 10 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri Aug  1 01:47:50 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.101-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.101-rc1

Catalin Marinas <catalin.marinas@arm.com>
    mm: kmemleak: avoid false negatives on vmalloc'ed objects

Xi Wang <xi.wang@gmail.com>
    introduce SIZE_MAX

Martin Schwidefsky <schwidefsky@de.ibm.com>
    s390/ptrace: fix PSW mask check

Linus Torvalds <torvalds@linux-foundation.org>
    Fix gcc-4.9.0 miscompilation of load_balance() in scheduler

Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
    mm: hugetlb: fix copy_hugetlb_page_range()

Sven Wegener <sven.wegener@stealer.net>
    x86_32, entry: Store badsys error code in %eax

Romain Degez <romain.degez@gmail.com>
    ahci: add support for the Promise FastTrak TX8660 SATA HBA (ahci mode)

Tejun Heo <tj@kernel.org>
    libata: introduce ata_host->n_tags to avoid oops on SAS controllers

Kevin Hao <haokexin@gmail.com>
    libata: support the ata host which implements a queue depth less than 32

Christoph Hellwig <hch@lst.de>
    block: don't assume last put of shared tags is for the host


-------------

Diffstat:

 Makefile                   |  6 ++++--
 arch/s390/kernel/ptrace.c  |  9 +++++++--
 arch/x86/kernel/entry_32.S |  9 +++++----
 block/blk-tag.c            | 33 +++++++--------------------------
 drivers/ata/ahci.c         |  1 +
 drivers/ata/libata-core.c  | 12 ++++++++++--
 fs/ceph/snap.c             |  2 +-
 include/drm/drm_mem_util.h |  4 ++--
 include/linux/kernel.h     |  1 +
 include/linux/libata.h     |  1 +
 include/linux/slab.h       |  2 +-
 mm/hugetlb.c               |  1 +
 mm/kmemleak.c              |  4 +++-
 mm/vmalloc.c               | 14 ++++++++++----
 14 files changed, 54 insertions(+), 45 deletions(-)


