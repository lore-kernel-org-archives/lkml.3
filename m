Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465AbaFFXrO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 19:47:14 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:60667 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371AbaFFXrN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 19:47:13 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: stefani@seibold.net, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 0/2] Update vDSO examples for 32-bit systems
Date: Fri,  6 Jun 2014 16:47:04 -0700
Message-Id: <cover.1402098294.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have useful code in the 32-bit x86 vDSO now; update the sample code.

Despite the late submission, this might be 3.16 material: it's just
documentation.  If I'd been more on top of this, I would have done it
for 3.15.

Andy Lutomirski (2):
  doc,vdso: Rename vdso_test.c to vdso_standalone_test_x86.c
  doc,vdso: Make vDSO examples more portable

 Documentation/vDSO/parse_vdso.c               |  59 ++++++------
 Documentation/vDSO/vdso_standalone_test_x86.c | 128 ++++++++++++++++++++++++++
 Documentation/vDSO/vdso_test.c                | 103 +++++----------------
 3 files changed, 181 insertions(+), 109 deletions(-)
 create mode 100644 Documentation/vDSO/vdso_standalone_test_x86.c

-- 
1.9.3

