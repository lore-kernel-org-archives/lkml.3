Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaLIVho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:37:44 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53601 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753195AbaLIVhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:37:43 -0500
Date: Tue, 9 Dec 2014 21:37:28 +0000
From: Mark Brown <broonie@kernel.org>
To: Fabio Estevam <festevam@gmail.com>
Cc: anthony.olech.opensource@diasemi.com, support.opensource@diasemi.com,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>
Message-ID: <20141209213728.GN11764@sirena.org.uk>
References: <CAOMZO5DBL1G7H3RE43edi5ObGOzvF_2Oo+LHqiG7EFfoWjXxaA@mail.gmail.com>
 <CAOMZO5B0WcR-=__QzCzD86oocuj--uhq+QYj3o1WU05JO-Qyfw@mail.gmail.com>
 <20141209212708.GL11764@sirena.org.uk>
 <CAOMZO5DYuUmc9m65Pssmy+Ak+A__WTLmXY2=+3jQ1ZKQcE5Pew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w0g8YuYCbDvF0cDN"
Content-Disposition: inline
In-Reply-To: <CAOMZO5DYuUmc9m65Pssmy+Ak+A__WTLmXY2=+3jQ1ZKQcE5Pew@mail.gmail.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: da9052-regulator fails to probe in linux-next
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w0g8YuYCbDvF0cDN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 09, 2014 at 07:34:09PM -0200, Fabio Estevam wrote:

> Yes, so here is a cleaner one:
> http://arm-soc.lixom.net/bootlogs/next/next-20141104/wandboard-arm-imx_v6_v7_defconfig.html

> The anatop regulators is drivers/regulator/pfuze100-regulator.c and
> the dt description is at:
> arch/arm/boot/dts/imx6qdl.dtsi

Still not seeing any references to either pfuze100 or vdd (other than
the external audio CODEC)...

--w0g8YuYCbDvF0cDN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUh2uXAAoJECTWi3JdVIfQsHMH/1fFjBJTgvX6cV4wiO1EM/1H
4D7rHGB68z5y8VAbC3Z/HatPS56bXHtEpIWhkAYQC1rsOp53Wvkdfiwj2wKr+3/d
UapH6aenU9uwEiYBGKGoOpbk+36SkuoPvwUuISyZNKFQRi8nFaNTh5v/T96EpGgP
cvewfrTzB3+tPvQ56+m5bmXnaAjrI3L1X76C2HO46Tig7Dv2moeFB3tv4SQPnwA7
s2xw+F+JKLHJvL23wwxShtGpsRcdl3yGxayTxRN5Q2T9sPyPmSNIExtRKv0GVd1L
oPKqVusFfieZtd7zF1j7Z8VAExqKSAgU1nBW/sBNYnxUhC3FnncrghQ/qdNsLd0=
=JlcF
-----END PGP SIGNATURE-----

--w0g8YuYCbDvF0cDN--
