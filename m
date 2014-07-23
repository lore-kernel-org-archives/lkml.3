Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbaGWGCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:02:36 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:51655 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbaGWGCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:02:13 -0400
From: Alexei Starovoitov <ast@plumgrid.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 2/2] bpf: update MAINTAINERS entry
Date: Tue, 22 Jul 2014 23:01:59 -0700
Message-Id: <1406095319-3627-3-git-send-email-ast@plumgrid.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1406095319-3627-1-git-send-email-ast@plumgrid.com>
References: <1406095319-3627-1-git-send-email-ast@plumgrid.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexei Starovoitov <ast@plumgrid.com>
---
 MAINTAINERS |    7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 78215a5dea28..62bf15f6954f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1912,6 +1912,13 @@ S:	Supported
 F:	drivers/net/bonding/
 F:	include/uapi/linux/if_bonding.h
 
+BPF (Safe dynamic programs and tools)
+M:	Alexei Starovoitov <ast@kernel.org>
+L:	netdev@vger.kernel.org
+L:	linux-kernel@vger.kernel.org
+S:	Supported
+F:	kernel/bpf/
+
 BROADCOM B44 10/100 ETHERNET DRIVER
 M:	Gary Zambrano <zambrano@broadcom.com>
 L:	netdev@vger.kernel.org
-- 
1.7.9.5

