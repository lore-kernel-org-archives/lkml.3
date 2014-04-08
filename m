Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260AbaDHHFv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 03:05:51 -0400
Received: from gwu.lbox.cz ([62.245.111.132]:35916 "EHLO gwu.lbox.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756220AbaDHHFt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 03:05:49 -0400
Date: Tue, 8 Apr 2014 09:00:35 +0200
From: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: "Greg KH (gregkh@linuxfoundation.org)" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Subject: Re: 3.0 -> 3.10 regression? poweroff instead of reboot?
Message-ID: <20140408070035.GI3339@pcnci.linuxbox.cz>
References: <20140331120102.GY3339@pcnci.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFAE58E@HASMSX106.ger.corp.intel.com>
 <20140402135812.GI3339@pcnci.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFB112D@HASMSX106.ger.corp.intel.com>
 <20140402143635.GA4410@nik-comp.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFB7151@HASMSX106.ger.corp.intel.com>
 <20140407132530.GF3339@pcnci.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFB7512@HASMSX106.ger.corp.intel.com>
 <20140408064953.GH3339@pcnci.linuxbox.cz>
 <5B8DA87D05A7694D9FA63FD143655C1B1AFB7D28@HASMSX106.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="32mFWuI8C7a/mRQ2"
Content-Disposition: inline
In-Reply-To: <5B8DA87D05A7694D9FA63FD143655C1B1AFB7D28@HASMSX106.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Antivirus: on proxybox by F-Secure antivirus, database version 2014-04-08_02
X-Milter-Copy-Status: I
X-Milter-Copy-Status: I
X-Spam-Score: N/A (imported whitelist)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--32mFWuI8C7a/mRQ2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> This is really strange, can it be that your mailer has introduced some bl=
anks into the patch,
> I've checked that patch applies to all relevant stable kernels.

I had it downloaded from link You've sent:
https://lkml.org/lkml/2014/3/25/396

using=20

wget https://lkml.org/lkml/diff/2014/3/25/396/1

I get two whitespaces on the last line..

n.


> =20
> > anyways, You can certainly forgot about that, it was my fault :(
> >=20
> > sorry about that
>=20
> No harm done, it's good this was sorted out.
> Thanks
> Tomas
> =20
>=20
>=20

--=20
-------------------------------------
Ing. Nikola CIPRICH
LinuxBox.cz, s.r.o.
28.rijna 168, 709 00 Ostrava

tel.:   +420 591 166 214
fax:    +420 596 621 273
mobil:  +420 777 093 799
www.linuxbox.cz

mobil servis: +420 737 238 656
email servis: servis@linuxbox.cz
-------------------------------------

--32mFWuI8C7a/mRQ2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAlNDnpMACgkQ3xdJJrLygV7q4QCfdbYLAXr4aHULEAB0G5BlRGLm
fDsAoKzWqUKo/2GiG4QBFob0vnISKOBm
=TdSD
-----END PGP SIGNATURE-----

--32mFWuI8C7a/mRQ2--
