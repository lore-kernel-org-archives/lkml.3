Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbaFLXR0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:17:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37035 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaFLXRY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:17:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.15 00/12] 3.15.1-stable review
Date: Thu, 12 Jun 2014 16:21:02 -0700
Message-Id: <20140612232044.886466924@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.15.1 release.
There are 12 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jun 14 23:20:28 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.15.1-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.15.1-rc1

Andreas Schrägle <ajs124.ajs124@gmail.com>
    ahci: add PCI ID for Marvell 88SE91A0 SATA Controller

Jérôme Carretero <cJ-ko@zougloub.eu>
    ahci: Add Device ID for HighPoint RocketRaid 642L

Alessandro Miceli <angelofsky1980@gmail.com>
    rtl28xxu: add [1b80:d3af] Sveon STV27

Alessandro Miceli <angelofsky1980@gmail.com>
    rtl28xxu: add [1b80:d39d] Sveon STV20

Brian Healy <healybrian@gmail.com>
    rtl28xxu: add 1b80:d395 Peak DVB-T USB

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: read H_CSR after asserting reset

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: drop harmful wait optimization

Tomas Winkler <tomas.winkler@intel.com>
    mei: me: fix hw ready reset flow

Alexei Starovoitov <ast@plumgrid.com>
    PCI/MSI: Fix memory leak in free_msi_irqs()

Andy Lutomirski <luto@amacapital.net>
    auditsc: audit_krule mask accesses need bounds checking

Al Viro <viro@zeniv.linux.org.uk>
    lock_parent: don't step on stale ->d_parent of all-but-freed one

Andy Lutomirski <luto@amacapital.net>
    fs,userns: Change inode_capable to capable_wrt_inode_uidgid


-------------

Diffstat:

 Makefile                                |  4 ++--
 drivers/ata/ahci.c                      |  4 ++++
 drivers/media/dvb-core/dvb-usb-ids.h    |  2 ++
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c |  6 ++++++
 drivers/misc/mei/hw-me.c                | 25 +++++++++++++++++++------
 drivers/pci/msi.c                       |  2 +-
 fs/attr.c                               |  8 ++++----
 fs/dcache.c                             |  4 +++-
 fs/inode.c                              | 10 +++++++---
 fs/namei.c                              | 11 ++++++-----
 fs/xfs/xfs_ioctl.c                      |  2 +-
 include/linux/capability.h              |  2 +-
 kernel/auditsc.c                        | 27 ++++++++++++++++++---------
 kernel/capability.c                     | 20 ++++++++------------
 14 files changed, 82 insertions(+), 45 deletions(-)


