Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab3DUDot (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 23:44:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:27710 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab3DUDos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 23:44:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,517,1363158000"; 
   d="scan'208";a="298288016"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: hein_tibosch@yahoo.es, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] fix initconst in lib/decompress.c
Date: Sat, 20 Apr 2013 20:44:45 -0700
Message-Id: <1366515885-18131-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>


diff --git a/lib/decompress.c b/lib/decompress.c
index 31a8042..f8fdeda 100644
--- a/lib/decompress.c
+++ b/lib/decompress.c
@@ -38,7 +38,7 @@ struct compress_format {
 	decompress_fn decompressor;
 };
 
-static const struct compress_format compressed_formats[] __initdata = {
+static const struct compress_format compressed_formats[] __initconst = {
 	{ {037, 0213}, "gzip", gunzip },
 	{ {037, 0236}, "gzip", gunzip },
 	{ {0x42, 0x5a}, "bzip2", bunzip2 },
