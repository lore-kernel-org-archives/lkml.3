Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3AYL1Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 06:27:24 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41640 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751605Ab3AYL1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 06:27:22 -0500
Date: Fri, 25 Jan 2013 03:27:03 -0800
From: tip-bot for Jon Stanley <jonstanley@gmail.com>
Message-ID: <tip-7b9f6b402c756975ac4e23a5f1bfa261c7c90017@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, rostedt@goodmis.org, jonstanley@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, jonstanley@gmail.com, rostedt@goodmis.org,
        tglx@linutronix.de
In-Reply-To: <1347049967-3143-1-git-send-email-jonstanley@gmail.com>
References: <1347049967-3143-1-git-send-email-jonstanley@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] tools lib traceevent:
  Update FSF postal address to be URL's.
Git-Commit-ID: 7b9f6b402c756975ac4e23a5f1bfa261c7c90017
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 03:27:08 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b9f6b402c756975ac4e23a5f1bfa261c7c90017
Gitweb:     http://git.kernel.org/tip/7b9f6b402c756975ac4e23a5f1bfa261c7c90017
Author:     Jon Stanley <jonstanley@gmail.com>
AuthorDate: Fri, 7 Sep 2012 16:32:46 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 24 Jan 2013 16:40:17 -0300

tools lib traceevent: Update FSF postal address to be URL's.

The FSF now prefers to use URL's in copyright headers rather than
their postal address. This change updates the address to be
<http://www.gnu.org/licenses> per http://www.gnu.org/licenses/gpl-howto.html

Signed-off-by: Jon Stanley <jonstanley@gmail.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1347049967-3143-1-git-send-email-jonstanley@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/lib/traceevent/event-parse.c  | 3 +--
 tools/lib/traceevent/event-parse.h  | 3 +--
 tools/lib/traceevent/event-utils.h  | 3 +--
 tools/lib/traceevent/parse-filter.c | 3 +--
 tools/lib/traceevent/trace-seq.c    | 3 +--
 5 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
index 7538a1f..dc42e55 100644
--- a/tools/lib/traceevent/event-parse.c
+++ b/tools/lib/traceevent/event-parse.c
@@ -13,8 +13,7 @@
  * GNU Lesser General Public License for more details.
  *
  * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  *
diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
index 24a4bba..7be7e89 100644
--- a/tools/lib/traceevent/event-parse.h
+++ b/tools/lib/traceevent/event-parse.h
@@ -13,8 +13,7 @@
  * GNU Lesser General Public License for more details.
  *
  * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
diff --git a/tools/lib/traceevent/event-utils.h b/tools/lib/traceevent/event-utils.h
index bc07500..e76c9ac 100644
--- a/tools/lib/traceevent/event-utils.h
+++ b/tools/lib/traceevent/event-utils.h
@@ -13,8 +13,7 @@
  * GNU Lesser General Public License for more details.
  *
  * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
index 5ea4326..2500e75 100644
--- a/tools/lib/traceevent/parse-filter.c
+++ b/tools/lib/traceevent/parse-filter.c
@@ -13,8 +13,7 @@
  * GNU Lesser General Public License for more details.
  *
  * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-seq.c
index b1ccc92..a57db80 100644
--- a/tools/lib/traceevent/trace-seq.c
+++ b/tools/lib/traceevent/trace-seq.c
@@ -13,8 +13,7 @@
  * GNU Lesser General Public License for more details.
  *
  * You should have received a copy of the GNU Lesser General Public
- * License along with this program; if not, write to the Free Software
- * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
+ * License along with this program; if not,  see <http://www.gnu.org/licenses>
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
