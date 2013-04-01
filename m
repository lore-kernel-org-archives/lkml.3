Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757050Ab3DAMaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:30:46 -0400
Received: from bues.ch ([80.190.117.144]:42973 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab3DAMap (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:30:45 -0400
X-Greylist: delayed 1106 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Apr 2013 08:30:45 EDT
Date: Mon, 1 Apr 2013 14:08:56 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: linux-kernel <linux-kernel@vger.kernel.org>
Subject: event subsystem: Define conference event types
Message-ID: <20130401140856.776f11f7@milhouse>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/zizAzDEy.qrIQJL/QE6oqzh"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/zizAzDEy.qrIQJL/QE6oqzh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

In order to improve the media coverage of important developer
conference events, extend the Linux event subsystem by corresponding
event type numbers.

Instead of referring to events by cryptic acronyms that nobody
knows the real meaning of, use even shorter acronyms defined to
hexadecimal numbers that every real hacker is familiar with.

Signed-off-by: Michael Buesch <m@bues.ch>

---


Index: linux/include/uapi/linux/input.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- linux.orig/include/uapi/linux/input.h	2013-02-28 22:27:32.798071135 +01=
00
+++ linux/include/uapi/linux/input.h	2013-04-01 13:56:05.715754517 +0200
@@ -183,6 +183,7 @@
 #define EV_FF			0x15
 #define EV_PWR			0x16
 #define EV_FF_STATUS		0x17
+#define EV_CONFERENCE		0x18
 #define EV_MAX			0x1f
 #define EV_CNT			(EV_MAX+1)
=20
@@ -750,6 +751,25 @@
 #define KEY_CNT			(KEY_MAX+1)
=20
 /*
+ * Conference events
+ */
+#define CONF_KS			0x00 /* Kernel Summit */
+#define CONF_WNS		0x01 /* Wireless Networking Summit */
+#define CONF_ABS		0x02 /* Android Builders Summit */
+#define CONF_ALS		0x03 /* Automotive Linux Summit */
+#define CONF_LFCS		0x04 /* Linux Foundation Collaboration Summit */
+#define CONF_ELC		0x05 /* Embedded Linux Conference */
+#define CONF_FOSDEM		0x06 /* uhm, ... *scratches head* */
+#define CONF_KLF		0x07 /* Korea Linux Forum */
+#define CONF_LCE		0x08 /* LinuxCon Europe */
+#define CONF_LCA		0x09 /* linux.conf.au */
+#define CONF_LCJ		0x0A /* LinuxCon Japan */
+#define CONF_LCNA		0x0B /* LinuxCon North America */
+#define CONF_LPC		0x0C /* Linux Plumbers Conference */
+#define CONF_LSS		0x0D /* Linux Security Summit */
+#define CONF_PC			0x0E /* PyCon */
+
+/*
  * Relative axes
  */
=20

--=20
Michael

--Sig_/zizAzDEy.qrIQJL/QE6oqzh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWXjYAAoJEPUyvh2QjYsOLsUP/icslujBN8qmjslTw/5CZX8W
hqFmDd41akU7ZmTHhvIGdOdF76GqQ3RCI31FO5vQdxDvKRKpt/BXtxlvlWDaPA9P
ga9qvwquWpRX33E4VpbI9EPSfjcDQtnOEx/NQhlmhCszKksOhle865EshTRQXKrx
I6OC/ZglrrQetkEGTv8JLFNX8TqHrQxGxMTheLtNorsceLgzovt8WNCHxO4W5aZT
HCP8qGMLjjwP83K11QNsXLMP20RpvsdYRKXs+enzfUIUG+SuafsulubpMxFVHpDM
VHFph874MNohKUxkMeEZOuYHebANQI9A1b9c8XJi42Ve0aQ7U92etWDZPcGTeB6G
6iHgTRvTFSMzt74hOIdjkmUOopCnzB80wFTKWu8nYFY57OVB332nTSNBxkRbKrkL
y4cHMl7raE65/pBPCIHNo2/XtYisixca86o9HrgsOeTi2ID7HJfrl+pIF3V/sKkp
ghMOMNgRM1q6iu5SI4WOw1aHV0rHaAUOtdZ9TnI4Bz1DMyy5+SJuJInVhoN4/cJU
xfVmBggpDAXrX2rpcNJnNGbqb/aqSAMcYeWSZbrebM9YTFwYMBpHylFPDiUimuUp
rxnKgTuXBadFAhiw5Y1/lNvEv9qvUggw4oa2Uq59HHde2HCLRbEMclfzX1u8QRfA
dFjGR6L+bl/crMqGvEH/
=g4bR
-----END PGP SIGNATURE-----

--Sig_/zizAzDEy.qrIQJL/QE6oqzh--
