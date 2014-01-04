Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834AbaADRUI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 12:20:08 -0500
Received: from mout.web.de ([212.227.15.14]:54593 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267AbaADRUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 12:20:06 -0500
From: Jan Kiszka <jan.kiszka@web.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-trace-users@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kvm <kvm@vger.kernel.org>
Subject: [PATCH 0/3] trace-cmd: Updates for kvm plugin
Date: Sat,  4 Jan 2014 18:19:47 +0100
Message-Id: <cover.1388855989.git.jan.kiszka@web.de>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
X-Provags-ID: V03:K0:rpLrkv+Z/D829EkcKbfGEXMhEWvSMhXlXJGsrSiXP+htsfupKqk
 MAPq2786fjerNX1F6+n1PGNMckO4RGPLTACwuihOO+c1yeCyeE4ZziMcpQz5JzvRQzvroTZ
 A4Ts0/b5YGHPtqcfo++zSR+ZSfNMBULTCB381kF6nQyOf9MRN9KE3CULLZ9pR90XP/D0PN2
 4mAvio2IZKjRyrUjMEwMA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patch 1 is resent unchanged from a previous round, patches 2 and 3
improve the output of nested vmexit tracepoints.

Jan Kiszka (3):
  trace-cmd: Report unknown VMX exit reasons with code
  trace-cmd: Factor out print_exit_reason in kvm plugin
  trace-cmd: Fix and cleanup kvm_nested_vmexit tracepoints

 plugin_kvm.c | 47 +++++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 20 deletions(-)

-- 
1.8.1.1.298.ge7eed54

