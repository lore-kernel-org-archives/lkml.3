Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab3LVHhX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 02:37:23 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:50538 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab3LVHgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 02:36:49 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, trivial@kernel.org, yann.morin.1998@free.fr,
        linux-kbuild@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 2/2] [trivial] scripts: kconfig: Fix trailing whitespace in zconf.tab.c_shipped
Date: Sun, 22 Dec 2013 16:36:25 +0900
Message-Id: <1387697785-29767-2-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.5.2.192.g7794a68
In-Reply-To: <1387697785-29767-1-git-send-email-standby24x7@gmail.com>
References: <1387697785-29767-1-git-send-email-standby24x7@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixed "ERROR: trailing whitespace" found by
checkpatch.pl, in zconf.tab.c_shipped

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 scripts/kconfig/zconf.tab.c_shipped | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/scripts/kconfig/zconf.tab.c_shipped b/scripts/kconfig/zconf.tab.c_shipped
index 25ae16a..c7b7639 100644
--- a/scripts/kconfig/zconf.tab.c_shipped
+++ b/scripts/kconfig/zconf.tab.c_shipped
@@ -1,19 +1,19 @@
 /* A Bison parser, made by GNU Bison 2.5.  */
 
 /* Bison implementation for Yacc-like parsers in C
-   
+
       Copyright (C) 1984, 1989-1990, 2000-2011 Free Software Foundation, Inc.
-   
+
    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.
-   
+
    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.
-   
+
    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.  */
 
@@ -26,7 +26,7 @@
    special exception, which will cause the skeleton and the resulting
    Bison output files to be licensed under the GNU General Public
    License without this special exception.
-   
+
    This special exception was added by the Free Software Foundation in
    version 2.2 of Bison.  */
 
-- 
1.8.5.2.192.g7794a68

