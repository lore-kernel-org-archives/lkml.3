Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935093AbaDJEFC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:05:02 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:60242 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934830AbaDJEE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 00:04:57 -0400
From: Michael Welling <mwelling@ieee.org>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, jslaby@suse.cz
Cc: Michael Welling <mwelling@ieee.org>
Subject: [PATCH 2/2] Strip out the FSF address info
Date: Wed,  9 Apr 2014 23:04:31 -0500
Message-Id: <1397102671-26536-2-git-send-email-mwelling@ieee.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1397102671-26536-1-git-send-email-mwelling@ieee.org>
References: <1397102671-26536-1-git-send-email-mwelling@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Welling <mwelling@ieee.org>
---
 drivers/tty/serial/xr17c15x.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/tty/serial/xr17c15x.c b/drivers/tty/serial/xr17c15x.c
index f8963e1..2010316 100644
--- a/drivers/tty/serial/xr17c15x.c
+++ b/drivers/tty/serial/xr17c15x.c
@@ -7,7 +7,6 @@
  *
  * Based on Linux 2.6.31 Kernel's  drivers/serial/8250.c and /8250_pci.c
  *
- *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
  * the Free Software Foundation; either version 2 of the License, or
@@ -18,10 +17,6 @@
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
  */
 
 #include <linux/module.h>
-- 
1.7.9.5

