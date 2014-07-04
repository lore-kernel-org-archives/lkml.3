Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759978AbaGDDYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 23:24:23 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63345 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756073AbaGDDYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 23:24:19 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: linux-kernel@vger.kernel.org, rdunlap@infradead.org,
        linux-doc@vger.kernel.org
Cc: Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] Documentation: Fix typo in DocBook files
Date: Fri,  4 Jul 2014 12:24:05 +0900
Message-Id: <1404444245-21906-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 2.0.0.390.gcb682f8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixed spelling typo in various template files
within Documentation/Docbook.

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/DocBook/gadget.tmpl                 | 2 +-
 Documentation/DocBook/genericirq.tmpl             | 4 ++--
 Documentation/DocBook/kernel-locking.tmpl         | 2 +-
 Documentation/DocBook/libata.tmpl                 | 6 +++---
 Documentation/DocBook/media_api.tmpl              | 2 +-
 Documentation/DocBook/regulator.tmpl              | 2 +-
 Documentation/DocBook/uio-howto.tmpl              | 4 ++--
 Documentation/DocBook/usb.tmpl                    | 2 +-
 Documentation/DocBook/writing-an-alsa-driver.tmpl | 2 +-
 9 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/Documentation/DocBook/gadget.tmpl b/Documentation/DocBook/gadget.tmpl
index 4017f14..2c425d7 100644
--- a/Documentation/DocBook/gadget.tmpl
+++ b/Documentation/DocBook/gadget.tmpl
@@ -708,7 +708,7 @@ hardware level details could be very different.
 
 <para>Systems need specialized hardware support to implement OTG,
 notably including a special <emphasis>Mini-AB</emphasis> jack
-and associated transciever to support <emphasis>Dual-Role</emphasis>
+and associated transceiver to support <emphasis>Dual-Role</emphasis>
 operation:
 they can act either as a host, using the standard
 Linux-USB host side driver stack,
diff --git a/Documentation/DocBook/genericirq.tmpl b/Documentation/DocBook/genericirq.tmpl
index 46347f6..59fb5c0 100644
--- a/Documentation/DocBook/genericirq.tmpl
+++ b/Documentation/DocBook/genericirq.tmpl
@@ -182,7 +182,7 @@
 	<para>
 	Each interrupt is described by an interrupt descriptor structure
 	irq_desc. The interrupt is referenced by an 'unsigned int' numeric
-	value which selects the corresponding interrupt decription structure
+	value which selects the corresponding interrupt description structure
 	in the descriptor structures array.
 	The descriptor structure contains status information and pointers
 	to the interrupt flow method and the interrupt chip structure
@@ -470,7 +470,7 @@ if (desc->irq_data.chip->irq_eoi)
      <para>
        To avoid copies of identical implementations of IRQ chips the
        core provides a configurable generic interrupt chip
-       implementation. Developers should check carefuly whether the
+       implementation. Developers should check carefully whether the
        generic chip fits their needs before implementing the same
        functionality slightly differently themselves.
      </para>
diff --git a/Documentation/DocBook/kernel-locking.tmpl b/Documentation/DocBook/kernel-locking.tmpl
index 19f2a5a..e584ee1 100644
--- a/Documentation/DocBook/kernel-locking.tmpl
+++ b/Documentation/DocBook/kernel-locking.tmpl
@@ -1760,7 +1760,7 @@ as it would be on UP.
 </para>
 
 <para>
-There is a furthur optimization possible here: remember our original
+There is a further optimization possible here: remember our original
 cache code, where there were no reference counts and the caller simply
 held the lock whenever using the object?  This is still possible: if
 you hold the lock, no one can delete the object, so you don't need to
diff --git a/Documentation/DocBook/libata.tmpl b/Documentation/DocBook/libata.tmpl
index deb71ba..d7fcdc5 100644
--- a/Documentation/DocBook/libata.tmpl
+++ b/Documentation/DocBook/libata.tmpl
@@ -677,7 +677,7 @@ and other resources, etc.
 
 	<listitem>
 	<para>
-	ATA_QCFLAG_ACTIVE is clared from qc->flags.
+	ATA_QCFLAG_ACTIVE is cleared from qc->flags.
 	</para>
 	</listitem>
 
@@ -708,7 +708,7 @@ and other resources, etc.
 
 	   <listitem>
 	   <para>
-	   qc->waiting is claread &amp; completed (in that order).
+	   qc->waiting is cleared &amp; completed (in that order).
 	   </para>
 	   </listitem>
 
@@ -1163,7 +1163,7 @@ and other resources, etc.
 
 	<para>
 	Once sense data is acquired, this type of errors can be
-	handled similary to other SCSI errors.  Note that sense data
+	handled similarly to other SCSI errors.  Note that sense data
 	may indicate ATA bus error (e.g. Sense Key 04h HARDWARE ERROR
 	&amp;&amp; ASC/ASCQ 47h/00h SCSI PARITY ERROR).  In such
 	cases, the error should be considered as an ATA bus error and
diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index 4decb46..03f9a1f 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -68,7 +68,7 @@
 		several digital tv standards. While it is called as DVB API,
 		in fact it covers several different video standards including
 		DVB-T, DVB-S, DVB-C and ATSC. The API is currently being updated
-		to documment support also for DVB-S2, ISDB-T and ISDB-S.</para>
+		to document support also for DVB-S2, ISDB-T and ISDB-S.</para>
 	<para>The third part covers the Remote Controller API.</para>
 	<para>The fourth part covers the Media Controller API.</para>
 	<para>For additional information and for the latest development code,
diff --git a/Documentation/DocBook/regulator.tmpl b/Documentation/DocBook/regulator.tmpl
index 346e552..3b08a08 100644
--- a/Documentation/DocBook/regulator.tmpl
+++ b/Documentation/DocBook/regulator.tmpl
@@ -155,7 +155,7 @@
        release regulators.  Functions are
        provided to <link linkend='API-regulator-enable'>enable</link>
        and <link linkend='API-regulator-disable'>disable</link> the
-       reguator and to get and set the runtime parameters of the
+       regulator and to get and set the runtime parameters of the
        regulator.
      </para>
      <para>
diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index 9561815..bbe9c1f 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -766,10 +766,10 @@ framework to set up sysfs files for this region. Simply leave it alone.
 	<para>
 	The dynamic memory regions will be allocated when the UIO device file,
 	<varname>/dev/uioX</varname> is opened.
-	Simiar to static memory resources, the memory region information for
+	Similar to static memory resources, the memory region information for
 	dynamic regions is then visible via sysfs at
 	<varname>/sys/class/uio/uioX/maps/mapY/*</varname>.
-	The dynmaic memory regions will be freed when the UIO device file is
+	The dynamic memory regions will be freed when the UIO device file is
 	closed. When no processes are holding the device file open, the address
 	returned to userspace is ~0.
 	</para>
diff --git a/Documentation/DocBook/usb.tmpl b/Documentation/DocBook/usb.tmpl
index 8d57c18..85fc0e2 100644
--- a/Documentation/DocBook/usb.tmpl
+++ b/Documentation/DocBook/usb.tmpl
@@ -153,7 +153,7 @@
 
 	<listitem><para>The Linux USB API supports synchronous calls for
 	control and bulk messages.
-	It also supports asynchnous calls for all kinds of data transfer,
+	It also supports asynchronous calls for all kinds of data transfer,
 	using request structures called "URBs" (USB Request Blocks).
 	</para></listitem>
 
diff --git a/Documentation/DocBook/writing-an-alsa-driver.tmpl b/Documentation/DocBook/writing-an-alsa-driver.tmpl
index d0056a4..6f639d9 100644
--- a/Documentation/DocBook/writing-an-alsa-driver.tmpl
+++ b/Documentation/DocBook/writing-an-alsa-driver.tmpl
@@ -5696,7 +5696,7 @@ struct _snd_pcm_runtime {
 	suspending the PCM operations via
 	<function>snd_pcm_suspend_all()</function> or
 	<function>snd_pcm_suspend()</function>.  It means that the PCM
-	streams are already stoppped when the register snapshot is
+	streams are already stopped when the register snapshot is
 	taken.  But, remember that you don't have to restart the PCM
 	stream in the resume callback. It'll be restarted via 
 	trigger call with <constant>SNDRV_PCM_TRIGGER_RESUME</constant>
-- 
2.0.0.390.gcb682f8

