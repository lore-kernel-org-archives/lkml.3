Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109AbaBTCE1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 21:04:27 -0500
Received: from ozlabs.org ([203.10.76.45]:44391 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752564AbaBTCEZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 21:04:25 -0500
Date: Thu, 20 Feb 2014 13:04:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jikos@jikos.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Reyad Attiyat <reyad.attiyat@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: linux-next: manual merge of the hid tree with Linus' tree
Message-Id: <20140220130415.dec1afdd528ce945f0771afc@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Feb_2014_13_04_15_+1100_GsxI/a99KXls_Mf_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Feb_2014_13_04_15_+1100_GsxI/a99KXls_Mf_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the hid tree got a conflict in
drivers/hid/hid-core.c between commit 117309c51dca ("HID: microsoft: Add
ID's for Surface Type/Touch Cover 2") from Linus' tree and commit
3faed1aff786 ("HID: hid-microsoft: Add support for scrollwheel and
special keypad keys") from the hid tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/hid/hid-core.c
index cc32a6f96c64,6f579dfba6ee..000000000000
--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@@ -1780,8 -1823,7 +1824,9 @@@ static const struct hid_device_id hid_h
  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_PRESENTER_8K_=
USB) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_DIGITAL_MEDIA=
_3K) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_WIRELESS_OPTICAL=
_DESKTOP_3_0) },
 +	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TYPE_COVER_2)=
 },
 +	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_TOUCH_COVER_2=
) },
+ 	{ HID_USB_DEVICE(USB_VENDOR_ID_MICROSOFT, USB_DEVICE_ID_MS_OFFICE_KB) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_MONTEREY, USB_DEVICE_ID_GENIUS_KB29E) },
  	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN) =
},
  	{ HID_USB_DEVICE(USB_VENDOR_ID_NTRIG, USB_DEVICE_ID_NTRIG_TOUCH_SCREEN_1=
) },

--Signature=_Thu__20_Feb_2014_13_04_15_+1100_GsxI/a99KXls_Mf_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTBWKfAAoJEMDTa8Ir7ZwVZXMP/jpfh9khsyYYASuELDPN4I5g
1dwSzrAOtE2xkv3lQzulmXHWD4IfkqAeR5DoI5s7myiFoWbQFWODUgz/y9JN1Pxg
YuDK24JGY9T49TXAlz+3pclfSFvuw1Wf0dol576XxIQimcj11IFATGmks8hFb535
AcGubub7ON6DXfhmJC1StWuUBBpGqYQOoXj1wf8X17CetYuFkgcf6wg31Vd9VJAJ
d/X+1A3xzsvFFuq7eBcUN6KsVuRAUFOS6aJ9oZa2UY9xSIFPx179A8MsH9FwTSyp
gEBi7z25QS9eZNZIVcmLxRc9FEqiKRN7DackYG77ZACV8z4XcMR8rr/05nOaxrHl
J8GOR6WP45rKRYx+61aCIXURCFTXdWzF4pPrBH0pEVzhcMbfSicFQluFv/WYgFR/
6QYDD1dKaLCKJ5ZtU9X4BXy1eduJd3ci95A7OGT2NeJXOCQwaO5qqqtLh5Tqe2ct
FV45wIjvJ/drUmEQRva9QkPClTEXEk09v3eV/QbF1Lz4aL/7JIOn8j1/P2LVL72S
1QvPA8h3FlMLCKgkfWwyqisD2kf+vhqJPTYhsd1mqz46QIAq+Pd5xeu9zqIuGJWv
g2xYQkWUArPHP1R++n5qyTtd8+ppzzKlH2OiuK79NxIbsKuYe7am01K43Anhwimu
G/SftNjxOEa9bNNeWg8K
=rBED
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Feb_2014_13_04_15_+1100_GsxI/a99KXls_Mf_--
