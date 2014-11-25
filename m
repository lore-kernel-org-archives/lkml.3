Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751093AbaKYSHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 13:07:43 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:36853 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaKYSHm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 13:07:42 -0500
Date: Tue, 25 Nov 2014 12:07:53 -0600
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB patches for v3.19 merge window
Message-ID: <20141125180753.GJ6360@saruman>
Reply-To: <balbi@ti.com>
References: <1416928650-20218-1-git-send-email-balbi@ti.com>
 <20141125173521.GA28406@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Jbyekxk18hnEXT0m"
Content-Disposition: inline
In-Reply-To: <20141125173521.GA28406@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Jbyekxk18hnEXT0m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2014 at 09:35:21AM -0800, Greg KH wrote:
> On Tue, Nov 25, 2014 at 09:17:30AM -0600, Felipe Balbi wrote:
> > Hi Greg,
> >=20
> > Here's a giant pull request for v3.19. Patches have been
> > on linux-next for quite a while - most of them at least - and
> > I tested what I could - read, what I had HW for - on both
> > BeagleBoneBlack and AM437x SK. Some has also been tested with
> > BeagleBoard X15, but that's still not supported in mainline
> > (probably v3.19 as well).
> >=20
> > Anyway, let me know if you want to change anything.
> >=20
> > cheers
> >=20
> > The following changes since commit 0df1f2487d2f0d04703f142813d53615d62a=
1da4:
> >=20
> >   Linux 3.18-rc3 (2014-11-02 15:01:51 -0800)
> >=20
> > are available in the git repository at:
> >=20
> >   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/usb-=
for-v3.19
>=20
> I had a merge conflict in drivers/usb/chipidea/otg_fsm.c, so you might
> want to verify I got that change correct.

looks good to me, thanks

--=20
balbi

--Jbyekxk18hnEXT0m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUdMV5AAoJEIaOsuA1yqREs40P/j5V05lXkf2gKU8V8WPFVBqq
JvP4cSqz3TTsSk/6Aj5/Mb4qgzLHDpYAzCoSFqjJjcDVFn9Z+LYKrPmQIRZEkVMe
ZB4gzFQfm6W4Rk7AZSUu3E+knR7Uho1Yhv8hrW/a0f6V+BsU+s6k/ELn+83STnNX
Wqo/CGI++zNywDTRFmWPSua35FqnlJZ3DzaK8+pA1pudPgeZzMMPemS1bG+6CDTu
jFUf/jh8qv5xqekubXJ8xAZqQghGLYAZjX4r5GqU3gbQqG0qrYwv7m0KggxCe4oF
R1xN1K2dY45AaxRWyBuzaEML3nkU8EZf9kCAMxAQONY2NKghVTiPlGiop9fadxh8
zkUA7WvQBTkoOKtUESUsxpWK4KjAGlJFlLKVCa8h6CtpyKlqwEnH2ymA3HnowtU8
lSppT/NIJ0GEIGOS73NM3N7bTDW98mfLCZZuGoel9uxd8vuAuOu1xwimyGvnB5iB
VlbPJifPmbHM/GluySD3jZiWc7psn+b5Nqq42KqxK5ybsE8bgpCucVfU/fKPNBRx
QcPXGRU4QCmTPV9KzpOgFDt4NId4bpbtdsQjlHFZ3cVTD++y+tQ3fB3G/VRZIL9l
xce5NPUgPeb7y7PygbTUIzCZIcfhf5mOzkErbjAdpSbH1KgtNn+1jeYogIKwbKRq
2CbH9ejH8IJIoUKenEVS
=xla/
-----END PGP SIGNATURE-----

--Jbyekxk18hnEXT0m--
