Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759431Ab3FNCiY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 22:38:24 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43770 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751173Ab3FNCiW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 22:38:22 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [Trivial PATCH 01/33] arm: kernel: isa: Convert use of typedef ctl_table to struct ctl_table
Date: Thu, 13 Jun 2013 19:37:26 -0700
Message-Id: <e78cf3653228ef35505d50e94c29e71650903a17.1371177118.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1371177118.git.joe@perches.com>
References: <cover.1371177118.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This typedef is unnecessary and should just be removed.

Signed-off-by: Joe Perches <joe@perches.com>
---
 arch/arm/kernel/isa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/kernel/isa.c b/arch/arm/kernel/isa.c
index 3464859..9d1cf71 100644
--- a/arch/arm/kernel/isa.c
+++ b/arch/arm/kernel/isa.c
@@ -20,7 +20,7 @@
 
 static unsigned int isa_membase, isa_portbase, isa_portshift;
 
-static ctl_table ctl_isa_vars[4] = {
+static struct ctl_table ctl_isa_vars[4] = {
 	{
 		.procname	= "membase",
 		.data		= &isa_membase, 
@@ -44,7 +44,7 @@ static ctl_table ctl_isa_vars[4] = {
 
 static struct ctl_table_header *isa_sysctl_header;
 
-static ctl_table ctl_isa[2] = {
+static struct ctl_table ctl_isa[2] = {
 	{
 		.procname	= "isa",
 		.mode		= 0555,
@@ -52,7 +52,7 @@ static ctl_table ctl_isa[2] = {
 	}, {}
 };
 
-static ctl_table ctl_bus[2] = {
+static struct ctl_table ctl_bus[2] = {
 	{
 		.procname	= "bus",
 		.mode		= 0555,
-- 
1.8.1.2.459.gbcd45b4.dirty

