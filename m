Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960AbaCJK74 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 06:59:56 -0400
Received: from sauhun.de ([89.238.76.85]:58958 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751057AbaCJK7y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 06:59:54 -0400
Date: Mon, 10 Mar 2014 11:59:52 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org, nsekhar@ti.com,
        khilman@deeprootsystems.com,
        davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH] i2c-davinci: Handle signals gracefully
Message-ID: <20140310105952.GA7227@katana>
References: <1389265885-26777-1-git-send-email-mike.looijmans@topic.nl>
 <20140309202107.GA2835@katana>
 <531D92F7.7080509@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xHFwDpU9dbj6ez1V"
Content-Disposition: inline
In-Reply-To: <531D92F7.7080509@topic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xHFwDpU9dbj6ez1V
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> >Even more, you should complete the whole transfer. There are devices
> >where things can really go wrong if you send a half-complete command and
> >then start with the next one. So, not checking signals at all is the way
> >to go for I2C drivers. There is some cruft left, so I am happy about
> >patches fixing that, with testing on real HW. Like yours here.
>=20
> I agree.
>=20
> I know the Zynq (using a cadence controller) also lets signals
> interrupt I2C transfers, so I'll propose a patch to Xilinx and CC to
> you and linux-i2c to completely remove signal handling from that
> driver as well.

Cool, thanks!


--xHFwDpU9dbj6ez1V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTHZsoAAoJEBQN5MwUoCm2pkAQAJzc2MNUaTFcdCLghtuilnSx
qlQ00rRZmvBlZwUvE+Sb09sJ0hC38/n3gQuW7NDU0/9WWr5doMaCjzI1ySuR5XFQ
Ec2JZ/j8sqbosMXB9REjuWeJOho0qADN5xA8O8Da2IZ4YgguvG8K6Ks/TwD1Z90V
FAQgbkxR4g1fxLj0PkK6UmOvpa+ExfM6d8Pw6G5k0U5DtZxkeWQq/NelaiFzamcM
dPJnrZGjPETALHf0RLWJLf4sidoRx//FeZTpfw5N9IQwUdVH8U6dU4uqlV1DfVmg
KPlC5WwE402r+bBcDixAPrQ2stFwLzJxQZ+QE74ThAuIUEV3MH1N3g408dVPEQIO
Mh5fniK6a7WovHuzFl4BF8TgKIusrrxgNsFDIN9uWAcyfeW898lf33qdCmsswaIK
6p3HToIt+2JInGh6msf8Q+WViLMS7OwlbqE8iqsoC6rqsQJs9+4AKWPan460ty66
M+3Xi1hntFbIQVyU20GHZoGIeWyUZWFf9+DzmKuOsal0gXMIMlJGPeOr7QHPxffn
AglsA4klqL7idRWeYNeS12OLHxpzmSiqKDDdgXlzeJjrN+wmEeTssyGx6Dh0rZZv
5SWFSwc/iEcgGe/fHTzp41B/JTd4fp+34LDPSIok3r8nW6Yin6RlqlJSLSM2vMqa
YUI3dSd09awnigXUIqRF
=jEz2
-----END PGP SIGNATURE-----

--xHFwDpU9dbj6ez1V--
