Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaFLXTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 19:19:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751171AbaFLXTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 19:19:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: [PATCH 3.4 0/8] 3.4.94-stable review
Date: Thu, 12 Jun 2014 16:22:47 -0700
Message-Id: <20140612232238.396722659@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the start of the stable review cycle for the 3.4.94 release.
There are 8 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat Jun 14 23:22:28 UTC 2014.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.4.94-rc1.gz
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 3.4.94-rc1

Jérôme Carretero <cJ-ko@zougloub.eu>
    ahci: Add Device ID for HighPoint RocketRaid 642L

Ben Collins <ben.c@servergy.com>
    SCSI: megaraid: Use resource_size_t for PCI resources, not long

Andy Lutomirski <luto@amacapital.net>
    auditsc: audit_krule mask accesses need bounds checking

Rashika Kheria <rashika.kheria@gmail.com>
    Staging: zram: Fix memory leak by refcount mismatch

Jiang Liu <liuj97@gmail.com>
    zram: protect sysfs handler from invalid memory access

Guenter Roeck <linux@roeck-us.net>
    powerpc: Fix 64 bit builds with binutils 2.24

Florian Westphal <fw@strlen.de>
    netfilter: ipv4: defrag: set local_df flag on defragmented skb

Chris Mason <clm@fb.com>
    mlx4_en: don't use napi_synchronize inside mlx4_en_netpoll


-------------

Diffstat:

 Makefile                                       |  4 ++--
 arch/powerpc/Makefile                          |  4 +++-
 arch/powerpc/include/asm/ppc_asm.h             |  7 ++++++-
 drivers/ata/ahci.c                             |  2 ++
 drivers/net/ethernet/mellanox/mlx4/en_cq.c     |  1 -
 drivers/net/ethernet/mellanox/mlx4/en_netdev.c |  6 +-----
 drivers/net/ethernet/mellanox/mlx4/mlx4_en.h   |  1 -
 drivers/scsi/megaraid/megaraid_sas.h           |  1 -
 drivers/scsi/megaraid/megaraid_sas_base.c      |  5 +++--
 drivers/staging/zram/zram_sysfs.c              | 21 +++++++++++++++-----
 kernel/auditsc.c                               | 27 +++++++++++++++++---------
 net/ipv4/netfilter/nf_defrag_ipv4.c            |  5 +++--
 12 files changed, 54 insertions(+), 30 deletions(-)


