Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaFBHnn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:43:43 -0400
Received: from netz.smurf.noris.de ([213.95.21.43]:39919 "EHLO
	netz.smurf.noris.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbaFBHnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:43:41 -0400
X-Greylist: delayed 958 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Jun 2014 03:43:40 EDT
Date: Mon, 2 Jun 2014 09:27:09 +0200
From: Matthias Urlichs <matthias@urlichs.de>
To: Johan Hovold <jhovold@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oliver@neukum.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: drop two usb-serial subdriver entries
Message-ID: <20140602072709.GP10337@smurf.noris.de>
References: <1401615137-11862-1-git-send-email-jhovold@gmail.com>
 <20140601174559.GB1281@kroah.com>
 <20140602071607.GD14935@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="veXX9dWIonWZEC6h"
Content-Disposition: inline
In-Reply-To: <20140602071607.GD14935@localhost>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Smurf-Spam-Score: -1.1 (-)
X-Smurf-Whitelist: +relay_from_hosts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--veXX9dWIonWZEC6h
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

Johan Hovold:
> > > -USB OPTION-CARD DRIVER
> > > -M:	Matthias Urlichs <smurf@smurf.noris.de>
> > > -L:	linux-usb@vger.kernel.org
> > > -S:	Maintained
> > > -F:	drivers/usb/serial/option.c
> >=20
> > Why are we taking away the maintainership of these individual drivers
> > from these developers?  I had no problem giving you the drivers I was
> > supposed to be in charge of, but I need a signed-off-by from Matthias
> > and Oliver for these if they want to do the same.
>=20
> I honestly thought you had just missed these entries when you removed
> individual maintainership for the other usb-serial drivers with the
> motivation that the developers were not around and that maintainership
> for individual drivers did not make much sense anymore (as consolidation
> proceeds, I read). (These two entries were also not grouped with the
> others.)
>=20
> Oliver and perhaps also Mathias are still around, but the option driver
> is now down to about 200 LOC (including boilerplate) when not counting
> the id table, while the kl5kusb105 is currently at about 400 LOC
> (including boilerplate) since I converted it to use the generic
> implementation a few years ago.
>=20
> Oliver and Mathias, what do you think of this? Would you be willing to
> sign off on this patch?
>=20
Fine by me. While I am indeed "still around", Option doesn't need a
maintainer any more -- the thing just works, and I do not see any need
for driver-specific changes other than additions to the ID table.

You hardly need a maintainer for that.

--=20
-- Matthias Urlichs

--veXX9dWIonWZEC6h
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTjCdJAAoJEHLPjl4ltMKTJ1wQANfTwR1jUK9UHEF4Ksd/uw3j
QFDxoULzUfdsnVFJzrBFsaDDOStSfbxlYWFmbmxVu3WdltTQNjXKJNRWjt5sLBLN
kh6H+7SRzf/EPXe7dH7Dml63Cx+WPnLXOieMf2OzCnMRUvAWGFWK7rdPorUu9h4A
uhRUL+5M8W6DVR1zbegP7DLdRa1AoYjeCoSw1BBM+5KEGfINO5Eizq1GH01QYl2S
Ox+DAPRBRe9wnPz20GdQSTjHEBlR2bKf9KcJ6Db6Av7Bgp5NNu7OdzIVcgmlERFW
N/oeDJigVAHZwIrVpDvgKvdIhFkfwTwFglRQ6lfNcs7roVNv21NvM9jZ9284OW3p
zEbTI3MgFMgPm9zhroPE8SuPjhTcyBSfhtXoVoulIVv6q20u/P2JI+gVm/CZWVWB
lDv8qnV0Dua0dGRGGHdblpUMzeu2uS/R6R+g1y0mNUxjhtfU4Ke/wXyLvMckHkRs
IvEr8T491wnid+3XO51zJ4OXNnQiictt5UgmrNwW5SLjJtGPTf8nLb8mfpXl3TEZ
Yw88/zgnj44QvQNjfo1Zd2vlolH47y+wicYIgoCdK8ixvqY2G5kYHZIhOVAr/nLj
uZT4CSNvD0hnOzNKxetpJQPbNMUOg+vjCTMHzWFNsIQAxp4CfLNIv69yKtp5CUjq
qGtUCbhWBXnkAEoGXfZd
=DScW
-----END PGP SIGNATURE-----

--veXX9dWIonWZEC6h--
