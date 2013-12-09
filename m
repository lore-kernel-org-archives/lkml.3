Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760439Ab3LID6N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Dec 2013 22:58:13 -0500
Received: from ozlabs.org ([203.10.76.45]:55475 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760353Ab3LID6L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Dec 2013 22:58:11 -0500
Date: Mon, 9 Dec 2013 14:58:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Tikhomirov <av.tikhomirov@samsung.com>
Subject: linux-next: build failure after merge of the usb-gadget tree
Message-Id: <20131209145803.4aba29ca2eba4444070e43ce@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Dec_2013_14_58_03_+1100_6+BcBnuJm8mHXVVQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Dec_2013_14_58_03_+1100_6+BcBnuJm8mHXVVQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

After merging the usb-gadget tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/built-in.o: In function `otg_set_state':
(.text+0x14f7de): undefined reference to `usb_bus_start_enum'

CONFIG_USB is 'm' in this build.

I am not sure what changed to cause this, maybe e1d2e31975e1 ("usb: phy:
Add OTG FSM configuration option")?

I have used the usb-gadget tree from next-20131206 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__9_Dec_2013_14_58_03_+1100_6+BcBnuJm8mHXVVQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSpT/PAAoJEMDTa8Ir7ZwVxOYP/AyD38Ec5tvVYwxk+Wx5UV0m
NxInaT8hGtYWjIXgsLfwY1f0g7IuBmFpGQdwElTDPaAx5wsUDNM0AtGKIb0ipHxj
vv511/yrgEZxtFpJNGFD/JwuukP/0U8qt31dmUpIRNHChHBRvNWDEhU08fVDcfIH
vQ93C4NX4+kqgphfxWkuPIRE6fF4MwRudJKI1m0R0X1hH/OtGpNIovcsO0tMzI9n
FqC6HBS4DOsFMZVht8Y2cUyf/AgWrNPPC3J1dpX/jEpV6BKQGbPpx1YPUBnIlQuN
qYGLRHUIL8iQKieJK9kjqhKe+yQYHLXWANdSttxuX3DAIlWTJ7aueaWEaccQW+x/
TxFItGAMQzcB1BDAVGDLxpI8el7QjbNywsMnCv5mjHjIaOAL97hYGNcaYoSwhw+K
hnZDXTExpiKZ4Lhb+fbA/vmDJsXA+7n6lcqla3JpWaz52HH23SKEeSDcvsdcxMU1
UcNkSFy95CDQmpqEiFB3EsKMHoghwVu63lJ/lUSjKYnfEHwRsrnTvug4EUrWbvbp
UV5hC9MNuQhNg+n3LGLwX5PiwN0bWHbG3qjFAB0qjI3gQFB5gxVnWPATdABzstgr
ck98E+S5Zfz8Vt9YLCJQY3BxnxFKM2A/NFzAs/IZhq+orNrAJJ9prnmgLs5WPhJD
L+vOX7ExXLJySHOgXQTv
=FBbz
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Dec_2013_14_58_03_+1100_6+BcBnuJm8mHXVVQ--
