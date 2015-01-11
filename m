Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751578AbbAKTlU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 14:41:20 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:48556 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbbAKTlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 14:41:15 -0500
From: David Decotigny <ddecotig@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jiri Kosina <jkosina@suse.cz>, Peter Foley <pefoley2@pefoley.com>,
        Randy Dunlap <rdunlap@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
        Willem de Bruijn <willemb@google.com>,
        David Decotigny <decot@googlers.com>
Subject: [PATCH net-next v1] doc: net: fix txtimestamp build
Date: Sun, 11 Jan 2015 11:41:03 -0800
Message-Id: <1421005263-24530-1-git-send-email-ddecotig@gmail.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@googlers.com>

Signed-off-by: David Decotigny <decot@googlers.com>
---
 Documentation/networking/timestamping/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/networking/timestamping/Makefile b/Documentation/networking/timestamping/Makefile
index 8c20dfa..80a3ce0 100644
--- a/Documentation/networking/timestamping/Makefile
+++ b/Documentation/networking/timestamping/Makefile
@@ -10,5 +10,6 @@ hostprogs-y := hwtstamp_config timestamping txtimestamp
 always := $(hostprogs-y)
 
 HOSTCFLAGS_timestamping.o += -I$(objtree)/usr/include
+HOSTCFLAGS_txtimestamp.o += -D_GNU_SOURCE
 HOSTCFLAGS_txtimestamp.o += -I$(objtree)/usr/include
 HOSTCFLAGS_hwtstamp_config.o += -I$(objtree)/usr/include
-- 
2.2.0.rc0.207.ga3a616c

