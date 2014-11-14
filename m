Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161109AbaKNNj7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 08:39:59 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38216 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161032AbaKNNj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 08:39:58 -0500
Date: Fri, 14 Nov 2014 11:10:00 +0000
From: Mark Brown <broonie@kernel.org>
To: Johan Havold <johan@kernel.org>
Cc: Laurentiu Palcu <laurentiu.palcu@intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141114111000.GY3815@sirena.org.uk>
References: <1415799490-27989-1-git-send-email-laurentiu.palcu@intel.com>
 <1415799490-27989-2-git-send-email-laurentiu.palcu@intel.com>
 <20141113122728.GA18285@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="S+nDaPSl8JRieaZD"
Content-Disposition: inline
In-Reply-To: <20141113122728.GA18285@localhost>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/2] spi: add support for DLN-2 USB-SPI adapter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--S+nDaPSl8JRieaZD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2014 at 01:27:28PM +0100, Johan Havold wrote:
> On Wed, Nov 12, 2014 at 03:38:09PM +0200, Laurentiu Palcu wrote:
> > This adds support for Diolan DLN2 USB-SPI adapter.
> >=20
> > Information about the USB protocol interface can be found in the
> > Programmer's Reference Manual [1], see section 5.4.6 for the SPI
> > master module commands and responses.

John, please delete unneeded context from your replies - it makes it
much easier to find any content you've added.

--S+nDaPSl8JRieaZD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUZeMHAAoJECTWi3JdVIfQKEgH/ijHSJnt0GOQSZDIqfCAp1Bd
a9M9otWx6UxdnsVsjv7/pfMialqcTTwyB/MzpzK023g19H4gwo9QVKby/XIk0lVB
8YXfxwFSLY12YGOuW13wR9/z0jj2HyT31dz9f/5L4n5pW1KWNynEVqtgjDdEng26
qmWJxO7CD5FxUJP1qfuE8lBdKX6ozdGkH6Y4k+t8RJg1RX3n6mSrOiEwg1MNkfp6
WUawqwG+G2B/E9C/c6k2NKpiDTxT3elySqDjsGVafsQ91TuC/SNXm38GgJ205i6a
U3XqdW/ksckUij2ThBJgmu3+B23rS2NqakCe79swKQbhWyHvhArbs+J/d0HZ+3w=
=ODX4
-----END PGP SIGNATURE-----

--S+nDaPSl8JRieaZD--
