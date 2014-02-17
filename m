Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754080AbaBQVgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 16:36:17 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:52878 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753507AbaBQVgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 16:36:08 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 02/12] rcu: Stop tracking FSF's postal address
Date: Mon, 17 Feb 2014 13:35:49 -0800
Message-Id: <1392672959-6386-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140217213533.GA5387@linux.vnet.ibm.com>
 <1392672959-6386-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14021721-6688-0000-0000-000006AE6EF4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

All of the RCU source files have the usual GPL header, which contains a
long-obsolete postal address for FSF.  To avoid the need to track the
FSF office's movements, this commit substitutes the URL where GPL may
be found.

Reported-by: Greg KH <gregkh@linuxfoundation.org>
Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 include/linux/rcupdate.h | 4 ++--
 include/linux/rcutiny.h  | 4 ++--
 include/linux/rcutree.h  | 4 ++--
 include/linux/srcu.h     | 4 ++--
 kernel/rcu/rcu.h         | 4 ++--
 kernel/rcu/srcu.c        | 4 ++--
 kernel/rcu/tiny.c        | 4 ++--
 kernel/rcu/tiny_plugin.h | 4 ++--
 kernel/rcu/torture.c     | 4 ++--
 kernel/rcu/tree.c        | 4 ++--
 kernel/rcu/tree.h        | 4 ++--
 kernel/rcu/tree_plugin.h | 4 ++--
 kernel/rcu/tree_trace.c  | 4 ++--
 kernel/rcu/update.c      | 4 ++--
 14 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 72bf3a01a4ee..b200756ea4c0 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright IBM Corporation, 2001
  *
diff --git a/include/linux/rcutiny.h b/include/linux/rcutiny.h
index 6f01771b571c..c364e9148de2 100644
--- a/include/linux/rcutiny.h
+++ b/include/linux/rcutiny.h
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright IBM Corporation, 2008
  *
diff --git a/include/linux/rcutree.h b/include/linux/rcutree.h
index 72137ee8c603..08b084068967 100644
--- a/include/linux/rcutree.h
+++ b/include/linux/rcutree.h
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright IBM Corporation, 2008
  *
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 9b058eecd403..a2783cb5d275 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright (C) IBM Corporation, 2006
  * Copyright (C) Fujitsu, 2012
diff --git a/kernel/rcu/rcu.h b/kernel/rcu/rcu.h
index 79c3877e9c5b..1bd787fddcb2 100644
--- a/kernel/rcu/rcu.h
+++ b/kernel/rcu/rcu.h
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright IBM Corporation, 2011
  *
diff --git a/kernel/rcu/srcu.c b/kernel/rcu/srcu.c
index 3318d8284384..5db7e9272d37 100644
--- a/kernel/rcu/srcu.c
+++ b/kernel/rcu/srcu.c
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright (C) IBM Corporation, 2006
  * Copyright (C) Fujitsu, 2012
diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index 1254f312d024..53b95bbf4abb 100644
--- a/kernel/rcu/tiny.c
+++ b/kernel/rcu/tiny.c
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright IBM Corporation, 2008
  *
diff --git a/kernel/rcu/tiny_plugin.h b/kernel/rcu/tiny_plugin.h
index 280d06cae352..431528520562 100644
--- a/kernel/rcu/tiny_plugin.h
+++ b/kernel/rcu/tiny_plugin.h
@@ -14,8 +14,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright (c) 2010 Linaro
  *
diff --git a/kernel/rcu/torture.c b/kernel/rcu/torture.c
index 732f8ae3086a..ab7dd192a50b 100644
--- a/kernel/rcu/torture.c
+++ b/kernel/rcu/torture.c
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright (C) IBM Corporation, 2005, 2006
  *
diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index e64157798624..321feef0f5c0 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright IBM Corporation, 2008
  *
diff --git a/kernel/rcu/tree.h b/kernel/rcu/tree.h
index 8c19873f1ac9..75dc3c39a02a 100644
--- a/kernel/rcu/tree.h
+++ b/kernel/rcu/tree.h
@@ -13,8 +13,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright IBM Corporation, 2008
  *
diff --git a/kernel/rcu/tree_plugin.h b/kernel/rcu/tree_plugin.h
index 6e2ef4b2b920..f9b9cdd36c8d 100644
--- a/kernel/rcu/tree_plugin.h
+++ b/kernel/rcu/tree_plugin.h
@@ -14,8 +14,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright Red Hat, 2009
  * Copyright IBM Corporation, 2009
diff --git a/kernel/rcu/tree_trace.c b/kernel/rcu/tree_trace.c
index d1f1e64a6d72..5cdc62e1beeb 100644
--- a/kernel/rcu/tree_trace.c
+++ b/kernel/rcu/tree_trace.c
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright IBM Corporation, 2008
  *
diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index c54609faf233..fd0d5b5b8e7c 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -12,8 +12,8 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ * along with this program; if not, you can access it online at
+ * http://www.gnu.org/licenses/gpl-2.0.html.
  *
  * Copyright IBM Corporation, 2001
  *
-- 
1.8.1.5

