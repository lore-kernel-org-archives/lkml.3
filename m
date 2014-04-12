Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbaDLNTg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Apr 2014 09:19:36 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:59680 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754403AbaDLNTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Apr 2014 09:19:31 -0400
From: Dominique van den Broeck <domdevlin@free.fr>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Dominique van den Broeck <domdevlin@free.fr>
Subject: [PATCH v2 4/4] fwserial: (coding style) removing FSF postal address
Date: Sat, 12 Apr 2014 15:18:15 +0200
Message-Id: <1397308695-30779-4-git-send-email-domdevlin@free.fr>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1397308695-30779-1-git-send-email-domdevlin@free.fr>
References: <20140412010411.GA29370@kroah.com>
 <1397308695-30779-1-git-send-email-domdevlin@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Style-only modifications to make checkpatch.pl --file --strict a bit happier.
Removing FSF postal address from file top comment since it has changed in the
past, as stated by checkpatch.pl.

Signed-off-by: Dominique van den Broeck <domdevlin@free.fr>
---
diff -upr a/drivers/staging/fwserial/dma_fifo.c b/drivers/staging/fwserial/dma_fifo.c
--- a/drivers/staging/fwserial/dma_fifo.c	2014-04-11 20:48:20.813667706 +0200
+++ b/drivers/staging/fwserial/dma_fifo.c	2014-04-11 20:47:49.700058306 +0200
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #include <linux/kernel.h>
diff -upr a/drivers/staging/fwserial/dma_fifo.h b/drivers/staging/fwserial/dma_fifo.h
--- a/drivers/staging/fwserial/dma_fifo.h	2014-04-11 20:48:20.813667706 +0200
+++ b/drivers/staging/fwserial/dma_fifo.h	2014-04-11 20:47:49.700058306 +0200
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #ifndef _DMA_FIFO_H_
diff -upr a/drivers/staging/fwserial/fwserial.c b/drivers/staging/fwserial/fwserial.c
--- a/drivers/staging/fwserial/fwserial.c	2014-04-11 20:48:20.813667706 +0200
+++ b/drivers/staging/fwserial/fwserial.c	2014-04-11 20:47:49.701058326 +0200
@@ -12,10 +12,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software Foundation,
- * Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
