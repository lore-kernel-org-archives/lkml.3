Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaKCAH0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 19:07:26 -0500
Received: from mail-lb0-f176.google.com ([209.85.217.176]:63089 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811AbaKCAHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 19:07:09 -0500
From: Konrad Zapalowicz <bergo.torino@gmail.com>
To: gregkh@linuxfoundation.org, jslaby@suse.cz, cascardo@linux.vnet.ibm.com
Cc: lidza.louina@gmail.com, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-serial@vger.kernel.org,
        Konrad Zapalowicz <bergo.torino@gmail.com>
Subject: [PATCH 5/5] drivers: serial: jsm: Remove FSF address from the file documentation/header
Date: Mon,  3 Nov 2014 01:06:30 +0100
Message-Id: <1414973190-10153-6-git-send-email-bergo.torino@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1414973190-10153-5-git-send-email-bergo.torino@gmail.com>
References: <1414973190-10153-1-git-send-email-bergo.torino@gmail.com>
 <1414973190-10153-2-git-send-email-bergo.torino@gmail.com>
 <1414973190-10153-3-git-send-email-bergo.torino@gmail.com>
 <1414973190-10153-4-git-send-email-bergo.torino@gmail.com>
 <1414973190-10153-5-git-send-email-bergo.torino@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit removes the address of Free Software Foundation from each
of the mentioned file in order to suppress the checkpatch warning.

Signed-off-by: Konrad Zapalowicz <bergo.torino@gmail.com>
---
 drivers/tty/serial/jsm/jsm.h        | 5 -----
 drivers/tty/serial/jsm/jsm_cls.c    | 5 -----
 drivers/tty/serial/jsm/jsm_driver.c | 5 -----
 drivers/tty/serial/jsm/jsm_neo.c    | 5 -----
 drivers/tty/serial/jsm/jsm_tty.c    | 5 -----
 5 files changed, 25 deletions(-)

diff --git a/drivers/tty/serial/jsm/jsm.h b/drivers/tty/serial/jsm/jsm.h
index 662523d..72ed5c1 100644
--- a/drivers/tty/serial/jsm/jsm.h
+++ b/drivers/tty/serial/jsm/jsm.h
@@ -13,11 +13,6 @@
  * implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  * PURPOSE.  See the GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 * Temple Place - Suite 330, Boston,
- * MA  02111-1307, USA.
- *
  * Contact Information:
  * Scott H Kilau <Scott_Kilau@digi.com>
  * Wendy Xiong   <wendyx@us.ibm.com>
diff --git a/drivers/tty/serial/jsm/jsm_cls.c b/drivers/tty/serial/jsm/jsm_cls.c
index 949e080..c6f450c 100644
--- a/drivers/tty/serial/jsm/jsm_cls.c
+++ b/drivers/tty/serial/jsm/jsm_cls.c
@@ -12,11 +12,6 @@
  * implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  * PURPOSE.  See the GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
- *
- *
  *	NOTE TO LINUX KERNEL HACKERS:  DO NOT REFORMAT THIS CODE!
  *
  *	This is shared code between Digi's CVS archive and the
diff --git a/drivers/tty/serial/jsm/jsm_driver.c b/drivers/tty/serial/jsm/jsm_driver.c
index 0927ddf..efbd87a 100644
--- a/drivers/tty/serial/jsm/jsm_driver.c
+++ b/drivers/tty/serial/jsm/jsm_driver.c
@@ -13,11 +13,6 @@
  * implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  * PURPOSE.  See the GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 * Temple Place - Suite 330, Boston,
- * MA  02111-1307, USA.
- *
  * Contact Information:
  * Scott H Kilau <Scott_Kilau@digi.com>
  * Wendy Xiong   <wendyx@us.ibm.com>
diff --git a/drivers/tty/serial/jsm/jsm_neo.c b/drivers/tty/serial/jsm/jsm_neo.c
index dfaf488..dc2cd90 100644
--- a/drivers/tty/serial/jsm/jsm_neo.c
+++ b/drivers/tty/serial/jsm/jsm_neo.c
@@ -13,11 +13,6 @@
  * implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  * PURPOSE.  See the GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 * Temple Place - Suite 330, Boston,
- * MA  02111-1307, USA.
- *
  * Contact Information:
  * Scott H Kilau <Scott_Kilau@digi.com>
  * Wendy Xiong   <wendyx@us.ibm.com>
diff --git a/drivers/tty/serial/jsm/jsm_tty.c b/drivers/tty/serial/jsm/jsm_tty.c
index f9b1fbd..8a71960 100644
--- a/drivers/tty/serial/jsm/jsm_tty.c
+++ b/drivers/tty/serial/jsm/jsm_tty.c
@@ -13,11 +13,6 @@
  * implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
  * PURPOSE.  See the GNU General Public License for more details.
  *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 * Temple Place - Suite 330, Boston,
- * MA  02111-1307, USA.
- *
  * Contact Information:
  * Scott H Kilau <Scott_Kilau@digi.com>
  * Ananda Venkatarman <mansarov@us.ibm.com>
-- 
1.9.1

