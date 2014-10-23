Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbaJWMz3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 08:55:29 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44481 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755296AbaJWMz2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 08:55:28 -0400
Date: Thu, 23 Oct 2014 13:55:02 +0100
From: Mark Brown <broonie@kernel.org>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, russ.dill@gmail.com,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Message-ID: <20141023125502.GB3729@sirena.org.uk>
References: <1414054344-3688-1-git-send-email-Russ.Dill@gmail.com>
 <20141023094053.GA30334@kroah.com>
 <20141023121815.1d8ef21d@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MfFXiAuoTsnnDAfZ"
Content-Disposition: inline
In-Reply-To: <20141023121815.1d8ef21d@alan.etchedpixels.co.uk>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.174.112.79
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] usb: serial: Perform verification for FTDI FT232R devices
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MfFXiAuoTsnnDAfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 23, 2014 at 12:18:15PM +0100, One Thousand Gnomes wrote:
> > >  drivers/usb/serial/ftdi_sio.c | 111 +++++++++++++++++++++++++++++++++++++++++-
> > >  drivers/usb/serial/ftdi_sio.h |  41 ++++++++++++++++
> > >  2 files changed, 151 insertions(+), 1 deletion(-)

> > Funny patch, you should have saved it for April 1, otherwise people
> > might have actually taken this seriously :)

> > Patches as performance art, now I've seen everything...

> Chuckle. Sillyness aside a pure detection version of that patch might be
> useful so it can warn users "Running Windows may damage your adapter" 8)

The EEPROM read function might also be interesting too, especially with
a userspace interface for reading it back.

--MfFXiAuoTsnnDAfZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUSPqlAAoJECTWi3JdVIfQkgwH/3EOq0zYk6YLb6XdMJSRj1zX
yT2mY7f6ID5UzyWgqUEtVgHu54P0dapBIQrbbi4Y0tO7A3CcZ3O1NVLoVxcBc0ck
zWRDxk5Nu7g/r22PzjbXtv3NlfGFV39Vio0bIkEoYcY9EXEe4tg+/U8Kx31zRX9o
eyN1cTn+VZ+AA0faoYHtImojRx9TuW2TaJ9j3zmd7hg2EVUpa8MdY63/bHmtPRXc
37vMAyN+vAhrkYqrYw/t6Y17hHBdxmJfjHHf2wFYUNyDA4DLS68o3bT7ZycqUt4+
w6rXxvsGjIITSYdQHF4A3f0N9ht4Rs/KrqR/nLyvEA6JUbM7aDusFUFQyX0QZ2A=
=Fasw
-----END PGP SIGNATURE-----

--MfFXiAuoTsnnDAfZ--
