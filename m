Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755503AbaJWTYy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 15:24:54 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:24439 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752354AbaJWTYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 15:24:53 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: As4NAGJVSVRbtA79/2dsb2JhbABcgw66QwUBBW+aPoEUFwF9hF8jgRqIfAG6Ao53hiWKMx2ENQWGLZcwli2BRwGCMjuCegEBAQ
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Fabian Frederick <fabf@skynet.be>
Subject: [RFC 00/13] drivers: replace long unsigned int by unsigned long
Date: Thu, 23 Oct 2014 21:24:44 +0200
Message-Id: <1414092284-27898-1-git-send-email-fabf@skynet.be>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Trivial patchset to use standard unsigned long in drivers/
instead of long unsigned int

I'm just sending the summary; if you think it's worth being applied,
I'll send this patchset and smaller ones for other trees.

Regards,
Fabian

Fabian Frederick (13):
  qla4xxx: replace long unsigned int by unsigned long
  megaraid_sas: replace long unsigned int by unsigned long
  ql2xxx: replace long unsigned int by unsigned long
  be2iscsi: replace long unsigned int by unsigned long
  xhci: replace long unsigned int by unsigned long
  edac: replace long unsigned int by unsigned long
  ene_ir: replace long unsigned int by unsigned long
  memstick: replace long unsigned int by unsigned long
  RDMA/nes: replace long unsigned int by unsigned long
  watchdog: replace long unsigned int by unsigned long
  alienware-wmi: replace long unsigned int by unsigned long
  hp-wmi: replace long unsigned int by unsigned long
  mtd: replace long unsigned int by unsigned long

 drivers/edac/e752x_edac.c               |  2 +-
 drivers/edac/i5000_edac.c               |  2 +-
 drivers/edac/i5400_edac.c               |  2 +-
 drivers/edac/i7300_edac.c               |  2 +-
 drivers/infiniband/hw/nes/nes.c         |  8 ++++----
 drivers/media/rc/ene_ir.c               |  2 +-
 drivers/memstick/host/r592.c            |  4 ++--
 drivers/mtd/sm_ftl.h                    |  2 +-
 drivers/platform/x86/alienware-wmi.c    |  4 ++--
 drivers/platform/x86/hp-wmi.c           |  2 +-
 drivers/scsi/be2iscsi/be_main.c         |  2 +-
 drivers/scsi/megaraid/megaraid_sas_fp.c | 28 ++++++++++++++--------------
 drivers/scsi/qla2xxx/qla_nx2.c          |  2 +-
 drivers/scsi/qla4xxx/ql4_nx.c           |  2 +-
 drivers/usb/host/xhci.c                 |  2 +-
 drivers/watchdog/bcm47xx_wdt.c          |  2 +-
 16 files changed, 34 insertions(+), 34 deletions(-)

-- 
1.9.3

