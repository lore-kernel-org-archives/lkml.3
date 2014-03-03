Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbaCCQfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:35:10 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:33202 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754135AbaCCQfH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:35:07 -0500
Date: Mon, 3 Mar 2014 10:33:08 -0600
From: Felipe Balbi <balbi@ti.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, Felipe Balbi <balbi@ti.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: atmel_usba: Fix crashed during stopping
 when DEBUG is enabled
Message-ID: <20140303163308.GA10987@saruman.home>
Reply-To: <balbi@ti.com>
References: <1393598066-4016-1-git-send-email-gregory.clement@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KsGdsel6WgEHnImy"
Content-Disposition: inline
In-Reply-To: <1393598066-4016-1-git-send-email-gregory.clement@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--KsGdsel6WgEHnImy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2014 at 03:34:01PM +0100, Gregory CLEMENT wrote:
> The debug trace in the atmel_usba_stop function made the assumption
> that the driver pointer passed in parameter was not NULL. Since the
> commit "usb: gadget: udc-core: fix a regression during gadget driver
> unbinding", it was no more always true. This lead to a kernel crash.
>=20
> This commit now use the driver pointer stored in udc which fixes this
> issue.
>=20
> Since the commit which have triggered this issue was backported to the
> 3.2 stable branch, then this one should also be backported to the same
> kernel.
>=20
> Cc: stable@vger.kernel.org # v3.2+
> Fixes: 511f3c5326ea (usb: gadget: udc-core: fix a regression during gadge=
t driver unbinding)

this line shouldn't be here and you're missing a SoB line, can't take
this patch, sorry.

--=20
balbi

--KsGdsel6WgEHnImy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTFK7EAAoJEIaOsuA1yqRE5ZgP/1KyTFAzGuSZP8m5OhfHzvhy
qRoSuDENU1bZa/VMaob12zQh7AFiytjZMmsUUIokUKUuI+mz5KudDjV6r3ghAZic
6I8fjEZBf33STGRybwOosVH2ugCezfy2nNjjPWFF0fZjS/tx/EENZZ2RjyqbVY8s
19lDzTP1HVRDhS8tpsbnbrnApq6DDvs5N5PqN+rJyCmj5NW1vvYdp2I7qCBOBF5m
7GQN4F1mFTFd0CGcQmZJA4w3woWwQkcQ/OWLJCxwis9gNWzzG73SAUkgkAnC2GiT
vbtmPY6YNvEg+vtw6EXWwXHYZxVcOu2rihyc7uio4LOcCfWjqicWUqIsH55EEV8W
ebsAKZHc+/AZLTUOmBIzVzRTMttqWPDkGCBsmva4sgbi0okRo2+Z5Wh0EgXVPIv6
dl9kaiH+73EE7/0k/AG2kqXX8Ktd9H2R7+ftB5Jc76tFwNFhJyXvfmAWUg3pNROo
xrogSQbUzHpoy+iCGexDDOkBkePvtoCSThWGEk7k0JOO7MjgvueI0GN1Uu8pfgai
QvHayIpFY9piGH+E2mf00BAyNkrIcXmO+GmuPusf2zaVgNzGUC7QI9/9xc2XOwYC
OZ69FEDMIyrYf9SVgzm6RfRR1acUldXAc/Ifq0qDM8e0OkwClGpVAkqqElA8BC3l
7OXeoVVH45oiAL0VopKW
=XKTs
-----END PGP SIGNATURE-----

--KsGdsel6WgEHnImy--
