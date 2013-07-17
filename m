Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab3GQH6A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 03:58:00 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:59545 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752200Ab3GQH56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 03:57:58 -0400
Date: Wed, 17 Jul 2013 10:57:06 +0300
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Rong Wang <wr011235813@gmail.com>, <balbi@ti.com>,
        Arnd Bergmann <arnd@arndb.de>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <Rong.Wang@csr.com>
Subject: Re: [PATCH] usb: udc: add gadget state kobject uevent
Message-ID: <20130717075706.GC5291@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <CA+k=oDzG+R-ei5WGxP8L1Od6VWTK9SgWcXHNjd89u6+b2bECkQ@mail.gmail.com>
 <20130715165209.GA6000@kroah.com>
 <CA+k=oDzZ5sf_wFMUvE_vkkqRQaOV0P3vWP99tDpoZkrwMN7Q+A@mail.gmail.com>
 <20130716063117.GA30320@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TiqCXmo5T1hvSQQg"
Content-Disposition: inline
In-Reply-To: <20130716063117.GA30320@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--TiqCXmo5T1hvSQQg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 15, 2013 at 11:31:17PM -0700, Greg KH wrote:
> > The question is since we default GADGET, so the g_mass_storage.ko is
> > installed early but connecting to a host PC
> > is randomly, But the udev has no idea when a host PC connects our devic=
e.
> >=20
> > So we consider it's reasonable to let the udev know the GADGET device s=
tate.
> > Is there any alternative to our question?
>=20
> I thought we already export events for gadget device states, have you
> looked for them?  I can't dig through the code at the moment, but this
> seems like a pretty common issue...
>=20
> Felipe, any ideas?

we already expose that in sysfs. IIRC udev can act on sysfs changes,
no ?

--=20
balbi

--TiqCXmo5T1hvSQQg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR5k5RAAoJEIaOsuA1yqREMT4P/iMPYoNTVtb5CbJ/8xh6W4UE
SMh7YpbzE0p3hL+uGt2xsV3UUPpFd6ltRKzJHh4JkmYdkummp6hzegu8YQZSo1tM
ykwkJb9PiXQnmxutKiW4fF7v7CHKJfY9FCwuEbRl6/wSTrcHvgZ8Q9fxumMKrcyZ
Y8L1nYZkSbyo4nNRnGCFRgYY4doETj1/y2gJGfkqoGtpWMn54oHptxw2pDfyq/dj
VWHN9uJ/Wi3yGXK4Nn1YlrgTw7nvkvoRYGUll5P+bQ/0zBTm/GhbXsPFRhTUlGue
crqyxfvamKn5d0yvAFfvnx7mO/ZbIr0ihwmikAN9GUHuQqP4Ywk8MRVsL7qn+j+0
NGYwm6W4ENUPDzF7ubSioDABw0KkMjm6TkXSTntaJcyyK+RXwXtwa6gK4CSiXvV+
umE47I7QEMPKLu5wBsMI58AS9l6TWLUK8WxOBNFvo5wUNHhJzaFhJX/gZXfoO5qQ
5pbJbAB+aqUhxwyX2nEbRWB4+9ZVtInFsD+AIFPtdDMU0GSAnT6F/Ej5WAfNrp7k
GPzBbKyt1V6itZX2TCxVRxTJ9OR87+FzKxkG9z8l90LdJjQjbPhmQIvTkmthEOrp
Q9mmm3t/2pSoEX23qFQJVLUFkd8662WkAe7S82x9DLGDXRKJSVoUi4DDagun5qq+
o5ikdgxuL/JcxBIZA1pq
=2yBc
-----END PGP SIGNATURE-----

--TiqCXmo5T1hvSQQg--
