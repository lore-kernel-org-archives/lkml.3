Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752946AbaBTCDq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 21:03:46 -0500
Received: from ozlabs.org ([203.10.76.45]:54227 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752276AbaBTCDp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 21:03:45 -0500
Date: Thu, 20 Feb 2014 13:03:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Barksdale <dbarksdale@uplogix.com>,
        Dinesh Ram <Dinesh.Ram@cern.ch>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: linux-next: manual merge of the hid tree with Linus' tree
Message-Id: <20140220130329.cbf82034cb246805a4fd59ca@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Feb_2014_13_03_29_+1100_pS8HYIV0sYRndiGw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Feb_2014_13_03_29_+1100_pS8HYIV0sYRndiGw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the hid tree got a conflict in
drivers/hid/hid-ids.h between commits adc232592337 ("[media] si4713: HID
blacklist Si4713 USB development board") and 3db187e7bf76 ("HID:
multitouch: add FocalTech FTxxxx support") from Linus' tree and commit
e932d8178667 ("HID: add hid-cp2112 driver") from the hid tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/hid/hid-ids.h
index 22f28d6b33a8,00be0d0f0dde..000000000000
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@@ -241,9 -240,7 +241,10 @@@
 =20
  #define USB_VENDOR_ID_CYGNAL		0x10c4
  #define USB_DEVICE_ID_CYGNAL_RADIO_SI470X	0x818a
 +#define USB_DEVICE_ID_FOCALTECH_FTXXXX_MULTITOUCH	0x81b9
 +
 +#define USB_DEVICE_ID_CYGNAL_RADIO_SI4713       0x8244
+ #define USB_DEVICE_ID_CYGNAL_CP2112	0xea90
 =20
  #define USB_VENDOR_ID_CYPRESS		0x04b4
  #define USB_DEVICE_ID_CYPRESS_MOUSE	0x0001

--Signature=_Thu__20_Feb_2014_13_03_29_+1100_pS8HYIV0sYRndiGw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTBWJ1AAoJEMDTa8Ir7ZwVZsYP/3gPNObwoiVAGYkH8H7RwewC
8G+1D7p/ocwnHwV/GnWgyUzqb/8nwFJRtMcuCBoyJ5MjsjWCk6gYYPTEAABVlImS
+TzM/XThT7xBdKmDwuW4KS9IBLNQ7GG727CjFGzN+rVLI73sYM4o0JECTZKD7wIw
FqvZ41rlklUxCqcNv+uoy0tahPXlXaWA3kQyyCrN/aZ3g6DBjeZvZAfQLB332wXM
EXTHkzJFpnBWRNfstGnDkUBeKEgYRUWhoLJwud3Pz7XKLuE8yizxEmUPGoMa2dMw
71xO2PtD0JRG7gTe0bAqo+cmZZbVJ+9m1+apr1DTebR3Bv5jQBIoEJYGDx8XRidI
y2nWMiWBMv4gK6kkr2WAd99d3wtoxtyqQ6Oyl779BCK0GVti7KD17lIxojzGSenU
a8UMbyGFiy2+eISSjDkeYtTqUd1Rt9679KB48gU8FkHOZhBnOstch8vMMIAP6cIm
sNYseSQUA0WJc9rUonecImGpToB1MNHqB4e0HeBIvX57j7i/RB905qDiRSlD/Abe
yiQJC9cNRM5KzI19UNXlJDGUk4Wa7XyVGgFzJ76nLDSbIVU3cCc9tXkxmtbptl4w
j0RMoFYPIhuRtc8Iv/iVSgjgN/TzsVG1gK5/3xO6XgqnmUg/L2x64MXkZurZYcS7
wp1K7GvK8WlVD2sB6RVf
=CWgg
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Feb_2014_13_03_29_+1100_pS8HYIV0sYRndiGw--
