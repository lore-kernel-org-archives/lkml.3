Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753651Ab3C0Of2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 10:35:28 -0400
Received: from multi.imgtec.com ([194.200.65.239]:39971 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab3C0OfW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 10:35:22 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: James Hogan <james.hogan@imgtec.com>
Subject: [PATCH 0/3] metag: misc improvements
Date: Wed, 27 Mar 2013 14:35:11 +0000
Message-ID: <1364394914-21257-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_03_27_14_35_22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few more misc arch/metag/ improvements for v3.10.

James Hogan (2):
  metag: export _metag_da_present and cpu_2_hwthread_id
  metag: add exported <asm/ech.h> for extended context handling

Paul Clothier (1):
  metag: ptrace: Implement NT_METAG_TLS

 arch/metag/include/uapi/asm/Kbuild |  1 +
 arch/metag/include/uapi/asm/ech.h  | 15 +++++++++++++++
 arch/metag/kernel/da.c             |  2 ++
 arch/metag/kernel/ptrace.c         | 34 ++++++++++++++++++++++++++++++++++
 arch/metag/kernel/setup.c          |  1 +
 include/uapi/linux/elf.h           |  1 +
 6 files changed, 54 insertions(+)
 create mode 100644 arch/metag/include/uapi/asm/ech.h

-- 
1.8.1.2


