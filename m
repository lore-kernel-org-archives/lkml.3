Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab3HBWnT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 18:43:19 -0400
Received: from mail-db8lp0187.outbound.messaging.microsoft.com ([213.199.154.187]:59592
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751931Ab3HBWnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 18:43:14 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 4
X-BigFish: VPS4(zzzz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hz70kd2izz2dh668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e1dh1e23h1155h)
X-WSS-ID: 0MQXDRR-02-3R6-02
X-M-MSG: 
From: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
To: <tglx@linutronix.de>, <mingo@redhat.com>, <hpa@zytor.com>,
        <dougthompson@xmission.com>, <bp@alien8.de>, <bhelgaas@google.com>,
        <jbeulich@suse.com>, <linux-kernel@vger.kernel.org>,
        <linux-edac@vger.kernel.org>, <linux-pci@vger.kernel.org>
CC: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
Subject: [PATCH 0/3 V2] EDAC, AMD64_EDAC: Add ECC error decoding for newer Fam15h models.
Date: Fri, 2 Aug 2013 17:43:01 -0500
Message-ID: <1375483384-2302-1-git-send-email-Aravind.Gopalakrishnan@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from V1:
	- Splitting up the patch
	- Remove unnecessary helper functions
	- Add family/model to amd64_pvt
	- Cleanup indent issues

Aravind Gopalakrishnan (3):
  EDAC, AMD64_EDAC: Add PCI Device ID Functions 3 and 4 for newer F15h
    models.
  EDAC, AMD64_EDAC: Add relevant condition checks as F15h M30h does not
    support GART or L3.
  EDAC, AMD64_EDAC: Add ECC decoding support for newer F15h models.

 arch/x86/kernel/amd_nb.c  |   14 ++-
 drivers/edac/amd64_edac.c |  276 +++++++++++++++++++++++++++++++++++++++++----
 drivers/edac/amd64_edac.h |   65 ++++++++++-
 include/linux/pci_ids.h   |    2 +
 4 files changed, 330 insertions(+), 27 deletions(-)

-- 
1.7.10.4


