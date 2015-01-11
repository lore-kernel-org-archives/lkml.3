Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751846AbbAKKwp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 05:52:45 -0500
Received: from albert.telenet-ops.be ([195.130.137.90]:42356 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbbAKKwn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 05:52:43 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-m68k@vger.kernel.org
Cc: Greg Ungerer <gerg@uclinux.org>, linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] m68k: Remove FSF address
Date: Sun, 11 Jan 2015 11:52:43 +0100
Message-Id: <1420973563-18305-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have a central copy of the GPL for that, and the FSF may change
address again in the future.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/mcfqspi.h | 5 -----
 arch/m68k/lib/ashldi3.c         | 7 +------
 arch/m68k/lib/ashrdi3.c         | 7 +------
 arch/m68k/lib/divsi3.S          | 7 +------
 arch/m68k/lib/lshrdi3.c         | 7 +------
 arch/m68k/lib/modsi3.S          | 7 +------
 arch/m68k/lib/muldi3.c          | 7 +------
 arch/m68k/lib/mulsi3.S          | 7 +------
 arch/m68k/lib/udivsi3.S         | 7 +------
 arch/m68k/lib/umodsi3.S         | 7 +------
 10 files changed, 9 insertions(+), 59 deletions(-)

diff --git a/arch/m68k/include/asm/mcfqspi.h b/arch/m68k/include/asm/mcfqspi.h
index 7b51416ccae221d1..256da0e4aeb41b8a 100644
--- a/arch/m68k/include/asm/mcfqspi.h
+++ b/arch/m68k/include/asm/mcfqspi.h
@@ -11,11 +11,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License along
- * with this program; if not, write to the Free Software Foundation, Inc.,
- * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
- *
 */
 
 #ifndef mcfqspi_h
diff --git a/arch/m68k/lib/ashldi3.c b/arch/m68k/lib/ashldi3.c
index 7729f33878d1c43b..37234c2df47f6e8e 100644
--- a/arch/m68k/lib/ashldi3.c
+++ b/arch/m68k/lib/ashldi3.c
@@ -11,12 +11,7 @@ any later version.
 GNU CC is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-GNU General Public License for more details.
-
-You should have received a copy of the GNU General Public License
-along with GNU CC; see the file COPYING.  If not, write to
-the Free Software Foundation, 59 Temple Place - Suite 330,
-Boston, MA 02111-1307, USA.  */
+GNU General Public License for more details. */
 
 #define BITS_PER_UNIT 8
 
diff --git a/arch/m68k/lib/ashrdi3.c b/arch/m68k/lib/ashrdi3.c
index 18ea5f7ed921f50e..1d59345f36c63155 100644
--- a/arch/m68k/lib/ashrdi3.c
+++ b/arch/m68k/lib/ashrdi3.c
@@ -11,12 +11,7 @@ any later version.
 GNU CC is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-GNU General Public License for more details.
-
-You should have received a copy of the GNU General Public License
-along with GNU CC; see the file COPYING.  If not, write to
-the Free Software Foundation, 59 Temple Place - Suite 330,
-Boston, MA 02111-1307, USA.  */
+GNU General Public License for more details. */
 
 #define BITS_PER_UNIT 8
 
diff --git a/arch/m68k/lib/divsi3.S b/arch/m68k/lib/divsi3.S
index ec307b61991e417d..2c0ec85ac6615473 100644
--- a/arch/m68k/lib/divsi3.S
+++ b/arch/m68k/lib/divsi3.S
@@ -19,12 +19,7 @@ distribution when not linked into another program.)
 This file is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-General Public License for more details.
-
-You should have received a copy of the GNU General Public License
-along with this program; see the file COPYING.  If not, write to
-the Free Software Foundation, 59 Temple Place - Suite 330,
-Boston, MA 02111-1307, USA.  */
+General Public License for more details. */
 
 /* As a special exception, if you link this library with files
    compiled with GCC to produce an executable, this does not cause
diff --git a/arch/m68k/lib/lshrdi3.c b/arch/m68k/lib/lshrdi3.c
index d06442d3a3288abf..49e1ec8f2cc27a9f 100644
--- a/arch/m68k/lib/lshrdi3.c
+++ b/arch/m68k/lib/lshrdi3.c
@@ -11,12 +11,7 @@ any later version.
 GNU CC is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-GNU General Public License for more details.
-
-You should have received a copy of the GNU General Public License
-along with GNU CC; see the file COPYING.  If not, write to
-the Free Software Foundation, 59 Temple Place - Suite 330,
-Boston, MA 02111-1307, USA.  */
+GNU General Public License for more details. */
 
 #define BITS_PER_UNIT 8
 
diff --git a/arch/m68k/lib/modsi3.S b/arch/m68k/lib/modsi3.S
index ef38494357685878..1d9e0efdf31d201f 100644
--- a/arch/m68k/lib/modsi3.S
+++ b/arch/m68k/lib/modsi3.S
@@ -19,12 +19,7 @@ distribution when not linked into another program.)
 This file is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-General Public License for more details.
-
-You should have received a copy of the GNU General Public License
-along with this program; see the file COPYING.  If not, write to
-the Free Software Foundation, 59 Temple Place - Suite 330,
-Boston, MA 02111-1307, USA.  */
+General Public License for more details. */
 
 /* As a special exception, if you link this library with files
    compiled with GCC to produce an executable, this does not cause
diff --git a/arch/m68k/lib/muldi3.c b/arch/m68k/lib/muldi3.c
index ee5f0b1b5c5dd9b8..9006d15b87218d95 100644
--- a/arch/m68k/lib/muldi3.c
+++ b/arch/m68k/lib/muldi3.c
@@ -12,12 +12,7 @@ any later version.
 GNU CC is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-GNU General Public License for more details.
-
-You should have received a copy of the GNU General Public License
-along with GNU CC; see the file COPYING.  If not, write to
-the Free Software Foundation, 59 Temple Place - Suite 330,
-Boston, MA 02111-1307, USA.  */
+GNU General Public License for more details. */
 
 #ifdef CONFIG_CPU_HAS_NO_MULDIV64
 
diff --git a/arch/m68k/lib/mulsi3.S b/arch/m68k/lib/mulsi3.S
index ce29ea37b45ffdfc..c39ad4e738e9a652 100644
--- a/arch/m68k/lib/mulsi3.S
+++ b/arch/m68k/lib/mulsi3.S
@@ -19,12 +19,7 @@ distribution when not linked into another program.)
 This file is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-General Public License for more details.
-
-You should have received a copy of the GNU General Public License
-along with this program; see the file COPYING.  If not, write to
-the Free Software Foundation, 59 Temple Place - Suite 330,
-Boston, MA 02111-1307, USA.  */
+General Public License for more details. */
 
 /* As a special exception, if you link this library with files
    compiled with GCC to produce an executable, this does not cause
diff --git a/arch/m68k/lib/udivsi3.S b/arch/m68k/lib/udivsi3.S
index c424c4a1f0a3276a..35a5446572a5ee3b 100644
--- a/arch/m68k/lib/udivsi3.S
+++ b/arch/m68k/lib/udivsi3.S
@@ -19,12 +19,7 @@ distribution when not linked into another program.)
 This file is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-General Public License for more details.
-
-You should have received a copy of the GNU General Public License
-along with this program; see the file COPYING.  If not, write to
-the Free Software Foundation, 59 Temple Place - Suite 330,
-Boston, MA 02111-1307, USA.  */
+General Public License for more details. */
 
 /* As a special exception, if you link this library with files
    compiled with GCC to produce an executable, this does not cause
diff --git a/arch/m68k/lib/umodsi3.S b/arch/m68k/lib/umodsi3.S
index 5def5f626478c38c..099da514a8fd80da 100644
--- a/arch/m68k/lib/umodsi3.S
+++ b/arch/m68k/lib/umodsi3.S
@@ -19,12 +19,7 @@ distribution when not linked into another program.)
 This file is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
-General Public License for more details.
-
-You should have received a copy of the GNU General Public License
-along with this program; see the file COPYING.  If not, write to
-the Free Software Foundation, 59 Temple Place - Suite 330,
-Boston, MA 02111-1307, USA.  */
+General Public License for more details. */
 
 /* As a special exception, if you link this library with files
    compiled with GCC to produce an executable, this does not cause
-- 
1.9.1

