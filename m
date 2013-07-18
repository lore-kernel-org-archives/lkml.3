Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758354Ab3GRKLM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 06:11:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43330 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757343Ab3GRKLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 06:11:10 -0400
Date: Thu, 18 Jul 2013 13:10:58 +0300
From: Felipe Balbi <balbi@ti.com>
To: Rong Wang <wr011235813@gmail.com>
CC: <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Rong.Wang@csr.com>
Subject: Re: [PATCH] usb: udc: add gadget state kobject uevent
Message-ID: <20130718101058.GG11251@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <CA+k=oDzG+R-ei5WGxP8L1Od6VWTK9SgWcXHNjd89u6+b2bECkQ@mail.gmail.com>
 <20130715165209.GA6000@kroah.com>
 <CA+k=oDzZ5sf_wFMUvE_vkkqRQaOV0P3vWP99tDpoZkrwMN7Q+A@mail.gmail.com>
 <20130716063117.GA30320@kroah.com>
 <20130717075706.GC5291@arwen.pp.htv.fi>
 <CA+k=oDza-oN++KCYtVMD0V62xgkJ3ctUOmzNkaYYYhXuKtaWKQ@mail.gmail.com>
 <20130717132736.GA7614@arwen.pp.htv.fi>
 <CA+k=oDy=_CWMCfcGfy=wbhn0BDm45Y8wS=wpe6SviPcnetntTw@mail.gmail.com>
 <20130718084041.GE11251@arwen.pp.htv.fi>
 <CA+k=oDxbu09FoQdOVUQhK-Q4hKuPYyiYDS1akoE2kggN7echgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FK65GREB+Evh/hTL"
Content-Disposition: inline
In-Reply-To: <CA+k=oDxbu09FoQdOVUQhK-Q4hKuPYyiYDS1akoE2kggN7echgA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--FK65GREB+Evh/hTL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 18, 2013 at 05:28:19PM +0800, Rong Wang wrote:
> Hi Felipe,
>=20
> Thanks, I'll test the patch.
>=20
> But sysfs_notify(&gadget->dev.kobj, NULL, "status"), status or state ?
> I notice that DEVICE_ATTR(state, S_IRUGO, usb_gadget_state_show, NULL)

good eyes, please send a patch which I'll queue on this -rc and Cc:
<stable@vger.kernel.org>.

I'll rewrite my patch on top of the patched -rc later.

--=20
balbi

--FK65GREB+Evh/hTL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR578yAAoJEIaOsuA1yqRELScQAKIv8ll9Q1VZERV2yONWLcR4
HNNEQ/MkmL8FiMBcUYBuuv4rVqkfZS3M2MKXe6b8w/HZgx3/32jHsaYtyOjWmrsy
t4gBx4wFqWYRNTtXPDjYTokbxS0WOQZgefEQHrWTgxpXbl8JNEo0z/qIMUNnuTwA
ayPLal4sv034cM+4rqDEHdy1+RpprPR56u8ekCuAnweIPN+/RRWbnERSvM4i3xc+
x0IGj28vycFGfz0tWJF7WuO0XOL6f1SiMZE2RJQUOrS1TW2YI/4V0FH+Cgt9nOB3
QbSxO7cDYAMS8PnZd7T/wF5i/9Jr2My+N8UWAEjB+tpcEgwpXR0lGfTZDHH5sTG9
qPiPSZXPomfbdfHsL7dTaO+usbRTsHisZZLt5QVJMJlcMVoAAm4t0w0ENzLoU1S/
UWSiRySMMGapWMTPkSE7tEQ6kPIsjnG+6MqOMb/eB3J8ZPWgIp48d/ht9n/FT2lu
797rMitCfFuwuyKblRORy0hjE0ryAvrIsh7Ct3iHAPBQFY5Et475rg6yJwNefeow
xV+szz7zRssna5EB+8a04yF8pOwQ5bTKdfets9zZDbfBNa3jzA2yjAWB4/ARrDM4
OuBYtTJoKma5yKlKuZ31NUJXW4f1i445t2WlEsb16wueZU0gJIninDsR4y3gmOZd
FkiPlWV0sARW6fuqEWMK
=VL0Z
-----END PGP SIGNATURE-----

--FK65GREB+Evh/hTL--
