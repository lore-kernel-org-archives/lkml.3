Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752463Ab3AUIFT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 03:05:19 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:35972 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751404Ab3AUIFR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 03:05:17 -0500
Date: Mon, 21 Jan 2013 10:05:06 +0200
From: Felipe Balbi <balbi@ti.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: nokia: Add mass storage driver to g_nokia
Message-ID: <20130121080506.GA8777@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1358650693-29971-1-git-send-email-pali.rohar@gmail.com>
 <20130120092537.GB16066@arwen.pp.htv.fi>
 <201301201117.32096@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/dobhs11T7y2rNN"
Content-Disposition: inline
In-Reply-To: <201301201117.32096@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--J/dobhs11T7y2rNN
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Jan 20, 2013 at 11:17:31AM +0100, Pali Roh=E1r wrote:
> On Sunday 20 January 2013 10:25:37 Felipe Balbi wrote:
> > On Sun, Jan 20, 2013 at 03:58:13AM +0100, Pali Roh=E1r wrote:
> > > Signed-off-by: Pali Roh=E1r <pali.rohar@gmail.com>
> >=20
> > NAK for two reasons:
> >=20
> > a) the original Nokia kernel used a separate g_file_storage
> > gadget to use Mass Storage mode, use that
> >=20
> > b) there is no commit log
>=20
> Reason why add mass storage mode to g_nokia is to avoid switching=20
> between g_{file,mass}_storage and g_nokia and to have one gadget=20
> driver for Nokia N900. It is better to have usb network and mass=20
> storage mode in one driver (and not to unload & load another).
>=20
> I tested this patch with 3.8-rc3 kernel on Nokia N900 and usb=20
> network with mass storage mode working without problems.

Doesn't matter, in this case this is something which nokia wrote to
carry on their Maemo/MeeGo devices so unless someone from Nokia says
this is how they want to use nokia.c from now on, I can't simply risk
breaking all other users for your own convenience.

On top of all that, we're working to remove all gadget drivers from
kernel and keep only function drivers.

--=20
balbi

--J/dobhs11T7y2rNN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ/PayAAoJEIaOsuA1yqRE3qcQAJvsBxLYZJ13TZK7Nh03iDfm
oriupTbhR5dmjS5D7Cl5fcJ7W1Iil+rffm9Eg2HPsZ3PNyuf4TWGGBqUN6BO9d+z
4pTWkdtPAx9dClid9Pn6mRS0jHjpoHJAqihXIyQ4I4WLcZKZgIN3QDeQuv+PsSfn
WF9Hlo4QjZOqxHyE4WVOKkYxDpWkoZnLxg9iXlXjgirxLTbmnAzrMK/DOHJxyHpi
4Dyxe28Cy3NAOtPbExdT+rho4/PjvJ1Aa4hMqJY6E5Kp5WwH9g12JXmEkvdMKWu+
CzwVFi5Q5cmynb0t7qHQ4PI3+tgMKRAiG520zQPYENmjzLVff3kkdZIwoWnI0iJA
in4er49vyy053gwLvTHc9VDAT1b89reYK7+EauuchbfveQU3fsbpUaXMsJkt5r1I
NDSjHAtaFe+f0lQ0b6+Bm44OcYvj4Zudllml7w8sAq8TUbD2mQcCQMM4NZpSZ1Sw
MQrKm5uX+1On8XCGOyaROoMoVpp3YmLnvs/EuKqit/acCUllGBq78dyWhQqXFVsG
yxIxNjpozNqHw2hMruUhMFKfM7ahily3nUezWDPQaV4oNZnMQMTtj8dQkioboCOO
xKjtSWpjGW0cmBkMVVbOBks0pjJiJ3b/oMVyvyGQb5NT775h5O5PjOcpqZ/HOe2j
RFvpaQGTbywCa0xWMZo/
=9tjT
-----END PGP SIGNATURE-----

--J/dobhs11T7y2rNN--
