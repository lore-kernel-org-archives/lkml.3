Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757832Ab3JOH5o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:57:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35103 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3JOH5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:57:42 -0400
Date: Tue, 15 Oct 2013 00:57:28 -0700
From: tip-bot for Russ Anderson <tipbot@zytor.com>
Message-ID: <tip-dd3c9c4b603c664fedc12facf180db0f1794aafe@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, rja@sgi.com, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, rja@sgi.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20131014161733.GA6274@sgi.com>
References: <20131014161733.GA6274@sgi.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Update UV3 hub revision ID
Git-Commit-ID: dd3c9c4b603c664fedc12facf180db0f1794aafe
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 15 Oct 2013 00:57:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dd3c9c4b603c664fedc12facf180db0f1794aafe
Gitweb:     http://git.kernel.org/tip/dd3c9c4b603c664fedc12facf180db0f1794aafe
Author:     Russ Anderson <rja@sgi.com>
AuthorDate: Mon, 14 Oct 2013 11:17:34 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 15 Oct 2013 08:44:46 +0200

x86: Update UV3 hub revision ID

The UV3 hub revision ID is different than expected.  The first
revision was supposed to start at 1 but instead will start at 0.

Signed-off-by: Russ Anderson <rja@sgi.com>
Cc: <stable@kernel.org> # v3.9, v3.10, v3.11
Link: http://lkml.kernel.org/r/20131014161733.GA6274@sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/x2apic_uv_x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/x2apic_uv_x.c b/arch/x86/kernel/apic/x2apic_uv_x.c
index 1191ac1..a419814 100644
--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -113,7 +113,7 @@ static int __init early_get_pnodeid(void)
 		break;
 	case UV3_HUB_PART_NUMBER:
 	case UV3_HUB_PART_NUMBER_X:
-		uv_min_hub_revision_id += UV3_HUB_REVISION_BASE - 1;
+		uv_min_hub_revision_id += UV3_HUB_REVISION_BASE;
 		break;
 	}
 
