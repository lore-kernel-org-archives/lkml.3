Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039AbaATP3B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 10:29:01 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:60046 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669AbaATP27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 10:28:59 -0500
Message-ID: <52DD4096.6020408@gmail.com>
Date: Mon, 20 Jan 2014 09:28:22 -0600
From: Souvik Banerjee <souvik1997@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>, matthew.garrett@nebula.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] dell-wmi: Add KEY_SWITCHVIDEOMODE for Dell N4110.
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="IbnAtGaFspiluRuvjh2f1ENVDJiXXmvpE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IbnAtGaFspiluRuvjh2f1ENVDJiXXmvpE
Content-Type: multipart/mixed;
 boundary="------------080702090808030304070004"

This is a multi-part message in MIME format.
--------------080702090808030304070004
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

This key is reported by the keyboard controller but also generates WMI
events. By adding it to the legacy keymap the WMI messages can be
silenced.
---
 drivers/platform/x86/dell-wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/dell-wmi.c
b/drivers/platform/x86/dell-wmi.c
index 60e0900..72f6cc8 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -92,6 +92,9 @@ static const struct key_entry dell_wmi_legacy_keymap[]
__initconst =3D {
 	{ KE_IGNORE, 0xe025, { KEY_RESERVED } },
 	{ KE_IGNORE, 0xe026, { KEY_RESERVED } },

+	/* For laptops like the Dell Inspiron N4110 with a monitor hotkey */
+	{ KE_KEY, 0xe027, { KEY_SWITCHVIDEOMODE } },
+
 	{ KE_IGNORE, 0xe02e, { KEY_VOLUMEDOWN } },
 	{ KE_IGNORE, 0xe030, { KEY_VOLUMEUP } },
 	{ KE_IGNORE, 0xe033, { KEY_KBDILLUMUP } },
--=20
1.8.5.3


--------------080702090808030304070004
Content-Type: text/x-patch;
 name="0001-dell-wmi-Add-KEY_SWITCHVIDEOMODE-for-Dell-N4110.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename*0="0001-dell-wmi-Add-KEY_SWITCHVIDEOMODE-for-Dell-N4110.patch"

=46rom 66440f78e9989d759be4dd550f76179d8df64083 Mon Sep 17 00:00:00 2001
From: Souvik Banerjee <souvik1997@gmail.com>
Date: Mon, 20 Jan 2014 09:10:29 -0600
Subject: [PATCH] dell-wmi: Add KEY_SWITCHVIDEOMODE for Dell N4110.

This key is reported by the keyboard controller but also generates WMI
events. By adding it to the legacy keymap the WMI messages can be
silenced.
---
 drivers/platform/x86/dell-wmi.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/dell-wmi.c b/drivers/platform/x86/dell-=
wmi.c
index 60e0900..72f6cc8 100644
--- a/drivers/platform/x86/dell-wmi.c
+++ b/drivers/platform/x86/dell-wmi.c
@@ -92,6 +92,9 @@ static const struct key_entry dell_wmi_legacy_keymap[] =
__initconst =3D {
 	{ KE_IGNORE, 0xe025, { KEY_RESERVED } },
 	{ KE_IGNORE, 0xe026, { KEY_RESERVED } },
=20
+	/* For laptops like the Dell Inspiron N4110 with a monitor hotkey */
+	{ KE_KEY, 0xe027, { KEY_SWITCHVIDEOMODE } },
+
 	{ KE_IGNORE, 0xe02e, { KEY_VOLUMEDOWN } },
 	{ KE_IGNORE, 0xe030, { KEY_VOLUMEUP } },
 	{ KE_IGNORE, 0xe033, { KEY_KBDILLUMUP } },
--=20
1.8.5.3


--------------080702090808030304070004--

--IbnAtGaFspiluRuvjh2f1ENVDJiXXmvpE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS3UC3AAoJEDYrZuXu8ZIMG0UP/0rd14xCLpJ981auqsv7kR8u
6E4Icdl9RT67/Dh8p4JUQe3ehM8ViZ7+AcuYotuSIK/fhsnsk2dPpVPrEv1/KBVH
cr/qTwJoGefeeQn0qUkJS3hP76E1u9cTEhUiqXim6SPW5D/2JM+AYu5gjbNimM8Q
LxGRAKOuzVlkDCq2qNAgwrcv47rou6prHLFUo1shsizhdMESqkqyCoTJW6T/betR
KRHIgQnP17JV68LgP8HKDSnQJ+niozdiUGEuLOMJeYV0isuh1d3oZQvr8tBqk0yp
RRZP5UYJElcK+6Pyo01Vlx/JKSYHndXg2Ertl1ZU34x4PGl+L0TKVM78erSY1MWg
hWnicRVeTG49Kpyz4YOXiKbVaRV9zaogx5jhc/mTXt934H3Rasu9WX79G1Bgr3/I
O7e5uHJTSoa2h13BXJgGZkHqoCiUDXcOseNjLFSwo9FAHxTqdmC8mkbsA+lzvCYE
807rhEQdSs1c9PuNuSxTJ0MqwWLpnXwWlG9/sBishlf1UX8yy5pm1XT/iUpqUOXd
Bl6cg7XeSGIJy5AdCjeKv1q85iczefnNysZlMMhmwU8YGeQfh9wV0XSzJ8MeP4XV
hhspYw1bAqqOCzjDz+7eYYT21yzc4pNvYqxVYlhE8McjU9xUI/1gYy2fwczEVzOW
kYdxUdU15L8kueg4pYty
=KYBN
-----END PGP SIGNATURE-----

--IbnAtGaFspiluRuvjh2f1ENVDJiXXmvpE--
