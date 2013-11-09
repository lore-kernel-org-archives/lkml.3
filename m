Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684Ab3KIGvw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 01:51:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab3KIGvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 01:51:44 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russ Anderson <rja@sgi.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH 3.11 09/94] x86: Update UV3 hub revision ID
Date: Fri,  8 Nov 2013 22:51:15 -0800
Message-Id: <20131109065204.918327039@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131109065204.252462489@linuxfoundation.org>
References: <20131109065204.252462489@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russ Anderson <rja@sgi.com>

commit dd3c9c4b603c664fedc12facf180db0f1794aafe upstream.

The UV3 hub revision ID is different than expected.  The first
revision was supposed to start at 1 but instead will start at 0.

Signed-off-by: Russ Anderson <rja@sgi.com>
Link: http://lkml.kernel.org/r/20131014161733.GA6274@sgi.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/apic/x2apic_uv_x.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/apic/x2apic_uv_x.c
+++ b/arch/x86/kernel/apic/x2apic_uv_x.c
@@ -113,7 +113,7 @@ static int __init early_get_pnodeid(void
 		break;
 	case UV3_HUB_PART_NUMBER:
 	case UV3_HUB_PART_NUMBER_X:
-		uv_min_hub_revision_id += UV3_HUB_REVISION_BASE - 1;
+		uv_min_hub_revision_id += UV3_HUB_REVISION_BASE;
 		break;
 	}
 


