Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751467AbaI3VNM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:13:12 -0400
Received: from sauhun.de ([89.238.76.85]:42785 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053AbaI3VNK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:13:10 -0400
Date: Tue, 30 Sep 2014 23:13:39 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Rajat Jain <rajatxjain@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-i2c <linux-i2c@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Rajat Jain <rajatjain@juniper.net>, Guenter Roeck <groeck@juniper.net>
Subject: Re: [PATCH 0/4] Driver for talking to PLX PEX8xxx PCIe switch over
 I2C
Message-ID: <20140930211339.GA1264@katana>
References: <542A3593.4020108@gmail.com>
 <CAErSpo7BkXDHOZwHzwEu2BN3=39xFwQOyrjgVo6afWKMsnYT=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <CAErSpo7BkXDHOZwHzwEu2BN3=39xFwQOyrjgVo6afWKMsnYT=A@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > Since this is a driver for a PCIe switch, I currently put it under /dri=
ver/pci/.
> > I'm very open to suggestions for moving this around (Does introducing
> > drivers/pci/switch/ seem any better?). Especially I can see that the
> > drivers/pci/Kconfig appears under "Bus Options" in the main menu which =
does not
> > look like the right place for this driver. I am looking for suggestions=
 here.
>=20
> Definitely interesting work.  I have no idea where to put it.  It
> doesn't have anything to do with PCI core services or structures, so
> drivers/pci doesn't seem like the ideal place for it, but I don't have
> any better ideas.  If it did end up under drivers/pci, I agree that a
> drivers/pci/switch or something similar would probably be better than
> having it directly in drivers/pci.
>=20
> Maybe Wolfram or other I2C folks will have an idea.

Hmm, is this a common interface for those switches? Then a directory
like drivers/pci/switch could make sense. Otherwise I'd suggest
drivers/misc?


--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKx0DAAoJEBQN5MwUoCm2wcwP/2SmPFJxcR4iHj5WFmDfvarU
VfRMOFK3wlFwO52659zxHz2rHOM6i2sOgEHZlHaB/0IU7XA9PZx6iEyMbBGYBLJN
okQiNiE0hnl8w+DAcWxPs8On2rICa6KadfEYyIXzL7Z0958ffhnREZ7a+oYKWorw
Aa1b+YppzBTjpw/4w31HqNbPhZbxTWZc4biyKkTsQeFA0vX6evkpcTQOLVyFR7Nw
aZvI4wHbiuZoqLTnxKNw56h7ixJjCMVQfQrJ/HvcwiMO13DNBU7zxVU/1nVyc6CQ
wguGL8lBfWgIMMChdBVTO5wdpMGmDsCSFaojb2vz8RhzlubwjcXu4DgNVN8EdWMr
aliQXIs3Uf18/mZrA0uIo3NVjFQZeTpUtbS7tDM/T2+ITst1ctmb68WDzddfBtW5
Y5U2/8v6R1dte/cSGKpLQG74jkDBsOTA9BExjQSIwNM8lEA6XUydX+h5TJfVAeYv
xk9+HqfEuH54kSKy+U9fx5Hngk2mKl4+jCTyoQzGu2YYezcvHh2EAZ/gCSBoVwxw
msuTKfuzI3It3+qI5V/oa+5sDkYU0bVrLyf4NvV5U1FqDM+i0Ln4RFXdqBCHQ1UM
ZSXNtCv57Zt8+tthbIQ88MFHVXf/B7vi3ckMPnGxOHhBfFZ9BWqSigEC4hCW3xO2
3K9tM7a1kg+bD9+11LK7
=daoW
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
