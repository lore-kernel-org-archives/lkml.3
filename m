Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761AbaFLXSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:18:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37093 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbaFLXSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:18:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.14 00/19] 3.14.8-stable review
Date: Thu, 12 Jun 2014 16:21:37 -0700
Message-Id: <20140612232138.561318739@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.14.8 release.
There are 19 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jun 14 23:21:28 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.8-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.14.8-rc1

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

Jan Vcelak <jv@fcelda.cz>
    rtl28xxu: add chipset version comments into device list

Jan Vcelak <jv@fcelda.cz>
    rtl28xxu: add USB ID for Genius TVGo DVB-T03

Till Dörges <till@doerges.net>
    rtl28xxu: add ID [0ccd:00b4] TerraTec NOXON DAB Stick (rev 3)

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

Nicholas Bellinger <nab@linux-iscsi.org>
    target: Allow READ_CAPACITY opcode in ALUA Standby access state

Nicholas Bellinger <nab@linux-iscsi.org>
    iser-target: Fix multi network portal shutdown regression

Sagi Grimberg <sagig@mellanox.com>
    Target/iscsi,iser: Avoid accepting transport connections during stop stage

Markos Chandras <markos.chandras@imgtec.com>
    MIPS: asm: thread_info: Add _TIF_SECCOMP flag

Florian Westphal <fw@strlen.de>
    netfilter: ipv4: defrag: set local_df flag on defragmented skb

Andy Lutomirski <luto@amacapital.net>
    fs,userns: Change inode_capable to capable_wrt_inode_uidgid


-------------

Diffstat:

 Makefile                                  |  4 ++--
 arch/mips/include/asm/thread_info.h       |  3 ++-
 drivers/ata/ahci.c                        |  4 ++++
 drivers/infiniband/ulp/isert/ib_isert.c   |  8 ++++++++
 drivers/media/dvb-core/dvb-usb-ids.h      |  3 +++
 drivers/media/usb/dvb-usb-v2/rtl28xxu.c   | 15 ++++++++++++++-
 drivers/misc/mei/hw-me.c                  | 25 +++++++++++++++++++------
 drivers/pci/msi.c                         |  2 +-
 drivers/target/iscsi/iscsi_target.c       |  1 +
 drivers/target/iscsi/iscsi_target_core.h  |  1 +
 drivers/target/iscsi/iscsi_target_login.c |  1 +
 drivers/target/iscsi/iscsi_target_tpg.c   |  2 ++
 drivers/target/target_core_alua.c         |  9 +++++++++
 fs/attr.c                                 |  8 ++++----
 fs/inode.c                                | 10 +++++++---
 fs/namei.c                                | 11 ++++++-----
 fs/xfs/xfs_ioctl.c                        |  2 +-
 include/linux/capability.h                |  2 +-
 kernel/auditsc.c                          | 27 ++++++++++++++++++---------
 kernel/capability.c                       | 20 ++++++++------------
 net/ipv4/netfilter/nf_defrag_ipv4.c       |  5 +++--
 21 files changed, 115 insertions(+), 48 deletions(-)


