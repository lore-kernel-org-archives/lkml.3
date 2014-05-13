Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbaEMWHZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 18:07:25 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:58413 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932222AbaEMWFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 18:05:52 -0400
From: Alexis Berlemont <alexis.berlemont@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Alexis Berlemont <alexis.berlemont@gmail.com>, jolsa@redhat.com,
        acme@ghostprotocols.net, dsahern@gmail.com, mingo@kernel.org
Subject: [PATCH 29/34] perf kbuild: fix tarpkg target in tests/make
Date: Wed, 14 May 2014 00:03:24 +0200
Message-Id: <1400018609-20486-30-git-send-email-alexis.berlemont@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
References: <1400018609-20486-1-git-send-email-alexis.berlemont@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 tools/perf/MANIFEST | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index c0c87c8..dcb06e8 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -1,3 +1,4 @@
+scripts
 tools/perf
 tools/scripts
 tools/lib/traceevent
-- 
1.9.2

