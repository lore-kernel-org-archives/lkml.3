Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaB0Tls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 14:41:48 -0500
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:13829 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296AbaB0Tlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 14:41:47 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AiMXANiTD1NbtAMT/2dsb2JhbABaKIJegkd8E75EAgKBHBd0gmYcIxiBAiQTh30ByzWOVYQ+AQOJSI5vAZIqgzov
Date: Thu, 27 Feb 2014 19:43:14 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: anton <anton@tuxera.com>, akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] Documentation/filesystems/ntfs.txt: Remove changelog
 reference
Message-Id: <20140227194314.bfd78fd074c1b45de1912923@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

File was removed in the following commit :
7c821a179f91c3ad52588400ce52a7fb48b9868c ("Remove fs/ntfs/ChangeLog")

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 Documentation/filesystems/ntfs.txt | 2 --
 1 file changed, 2 deletions(-)

diff --git a/Documentation/filesystems/ntfs.txt b/Documentation/filesystems/ntfs.txt
index 791af8d..61947fa 100644
--- a/Documentation/filesystems/ntfs.txt
+++ b/Documentation/filesystems/ntfs.txt
@@ -455,8 +455,6 @@ not have this problem with odd numbers of sectors.
 ChangeLog
 =========
 
-Note, a technical ChangeLog aimed at kernel hackers is in fs/ntfs/ChangeLog.
-
 2.1.30:
 	- Fix writev() (it kept writing the first segment over and over again
 	  instead of moving onto subsequent segments).
-- 
1.8.1.4

