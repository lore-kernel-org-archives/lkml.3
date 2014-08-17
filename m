Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaHQSi0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 14:38:26 -0400
Received: from mo-online.de ([89.238.66.174]:52748 "EHLO mo-online.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379AbaHQSiY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 14:38:24 -0400
X-Greylist: delayed 497 seconds by postgrey-1.27 at vger.kernel.org; Sun, 17 Aug 2014 14:38:23 EDT
Date: Sun, 17 Aug 2014 20:30:33 +0200
From: Markus Osterhoff <mo@mo-online.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: [TYPO 4/9] [typo] COPYING: form feeds removed
Message-ID: <20140817183033.GE4077@mo-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Operating-System: linux-2.6.39.3
X-Mutt-Manual: http://www.mutt.org/doc/manual/manual.html
X-PGP-Key: http://mo-online.de/~osti/public.key
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

some lines contain a single ^L (ASCII 0xc, 12, form feed),
which are unnecessary.

Signed-off-by: Markus Osterhoff <linux-kernel@k-raum.org>
---
 COPYING | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/COPYING b/COPYING
index ca442d3..0dde99b 100644
--- a/COPYING
+++ b/COPYING
@@ -71,7 +71,7 @@ patent must be licensed for everyone's free use or not licensed at all.
 
   The precise terms and conditions for copying, distribution and
 modification follow.
-
+
 		    GNU GENERAL PUBLIC LICENSE
    TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION
 
@@ -126,7 +126,7 @@ above, provided that you also meet all of these conditions:
     License.  (Exception: if the Program itself is interactive but
     does not normally print such an announcement, your work based on
     the Program is not required to print an announcement.)
-
+
 These requirements apply to the modified work as a whole.  If
 identifiable sections of that work are not derived from the Program,
 and can be reasonably considered independent and separate works in
@@ -184,7 +184,7 @@ access to copy from a designated place, then offering equivalent
 access to copy the source code from the same place counts as
 distribution of the source code, even though third parties are not
 compelled to copy the source along with the object code.
-
+
   4. You may not copy, modify, sublicense, or distribute the Program
 except as expressly provided under this License.  Any attempt
 otherwise to copy, modify, sublicense or distribute the Program is
@@ -241,7 +241,7 @@ impose that choice.
 
 This section is intended to make thoroughly clear what is believed to
 be a consequence of the rest of this License.
-
+
   8. If the distribution and/or use of the Program is restricted in
 certain countries either by patents or by copyrighted interfaces, the
 original copyright holder who places the Program under this License
@@ -294,7 +294,7 @@ PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGES.
 
 		     END OF TERMS AND CONDITIONS
-
+
 	    How to Apply These Terms to Your New Programs
 
   If you develop a new program, and you want it to be of the greatest
-- 
1.8.5.5

