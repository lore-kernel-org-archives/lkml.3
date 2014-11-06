Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555AbaKFKAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 05:00:47 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48560 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752328AbaKFKAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 05:00:04 -0500
Date: Thu, 6 Nov 2014 10:59:05 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Antoine =?iso-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH v3 0/2] dmaengine: Add driver documentation
Message-ID: <20141106095905.GI2989@lukather>
References: <1414529750-14431-1-git-send-email-maxime.ripard@free-electrons.com>
 <20141106055713.GS1870@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tBhgiDt8dP1efIIJ"
Content-Disposition: inline
In-Reply-To: <20141106055713.GS1870@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tBhgiDt8dP1efIIJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 06, 2014 at 11:27:13AM +0530, Vinod Koul wrote:
> On Tue, Oct 28, 2014 at 09:55:48PM +0100, Maxime Ripard wrote:
> > Hi,
> >=20
> > This is the third attempt at documenting how to write a dmaengine
> > driver.
>=20
> Applied all, thanks.
>=20
> Fixed minor typos in second one.
>=20
> Also we need to move dmatest.txt to new folder and also update MAINTAINER=
S,
> so applied with these two patches as well

Great news, thanks for the additional patches too.

Maxime
--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--tBhgiDt8dP1efIIJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUW0ZoAAoJEBx+YmzsjxAgft8P/icc/ckgMFNUTSw8hKVz61Mc
A9xOeQjGFPu7Nb6GmV/Ainstrgl2SFLSy8g7fNOuLSoFbc8erIHNnReB572sbJtL
QkdyyPREq5ubB7rNji2Qomb4N3u7JojW7Bagh/ApDOu3oR0QnYf54KwWaJDihJJd
2/QRUPC6pEssnOAw8OjTflSEYZ+qPF62Z3BM1Wtf8LGeHGdKbzZKyyWVeCLoLwer
DyeS6z5kk79a8en4QIwCTJobPq3iTZDhCXtNyHh4fv2N97WKEMKrlzXaLmGZYCPN
XeEfGVeXEHxVVcUC8leia/bjzTsiU5vBvAZrwEcHVJlGsdO2WLqNGnbc7qTZCR62
fy7F5hhhFGOkKb8Sfk3uSnB5RCsCtRjEGkGK9qycyaw6jh4q4Xijf/plU4/y5Uph
EkxjJBSS70hxJc1qEXY0/CbB8QOq14Mp3toxI6ok77SK28zxu7gFvS1AIHuEDFqt
mzSL04LdErYvGHdh31yjP0FAUJYup8wigfVq3Wg5RhUv/yKIrWNeWv8m65rUwHGN
JDH2fJ/r4f5wNU9C/efX36/uBgrGa13d0GKFk8ywd3/RkkwfD++vLUHbWaf7hnMP
+4WlOw17tRmLH83afI3ESPzkx5yF6AiRXk4npWS7r0Bgk39bbgu67Z1lZG0RGP2u
53qZXQRttK0DhQaukDiy
=evap
-----END PGP SIGNATURE-----

--tBhgiDt8dP1efIIJ--
