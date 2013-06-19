Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934707Ab3FSMfW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 08:35:22 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:13167 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934022Ab3FSMfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 08:35:20 -0400
From: Aaro Koskinen <aaro.koskinen@nsn.com>
To: Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Aaro Koskinen <aaro.koskinen@nsn.com>
Subject: [PATCH] Documentation/cgroups/memory.txt: fix stat file documentation
Date: Wed, 19 Jun 2013 15:34:29 +0300
Message-Id: <1371645269-19762-1-git-send-email-aaro.koskinen@nsn.com>
X-Mailer: git-send-email 1.7.10.4
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 1197
X-purgate-ID: 151667::1371645317-000017BA-D8DC2B02/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Documentation for inactive_anon / active_anon was mixed up. Fix that.

Signed-off-by: Aaro Koskinen <aaro.koskinen@nsn.com>
---
 Documentation/cgroups/memory.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index ddf4f93..b63be03 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -490,10 +490,10 @@ pgpgin		- # of charging events to the memory cgroup. The charging
 pgpgout		- # of uncharging events to the memory cgroup. The uncharging
 		event happens each time a page is unaccounted from the cgroup.
 swap		- # of bytes of swap usage
-inactive_anon	- # of bytes of anonymous memory and swap cache memory on
+inactive_anon	- # of bytes of anonymous and swap cache memory on inactive
 		LRU list.
 active_anon	- # of bytes of anonymous and swap cache memory on active
-		inactive LRU list.
+		LRU list.
 inactive_file	- # of bytes of file-backed memory on inactive LRU list.
 active_file	- # of bytes of file-backed memory on active LRU list.
 unevictable	- # of bytes of memory that cannot be reclaimed (mlocked etc).
-- 
1.7.10.4

