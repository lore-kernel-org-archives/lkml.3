Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757407Ab3DXKBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 06:01:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35805 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756375Ab3DXKBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 06:01:20 -0400
Date: Wed, 24 Apr 2013 11:01:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Wenyou Yang <wenyou.yang@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        richard.genoud@gmail.com, plagnioj@jcrosoft.com,
        nicolas.ferre@atmel.com, JM.Lin@atmel.com,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 4/8] spi/spi-atmel: BUG: fix doesn' support 16 bits
 transfers using PIO
Message-ID: <20130424100118.GD5019@opensource.wolfsonmicro.com>
References: <1364968581-23700-1-git-send-email-wenyou.yang@atmel.com>
 <1364968805-24090-1-git-send-email-wenyou.yang@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NxDiCysn+RCvdoZt"
Content-Disposition: inline
In-Reply-To: <1364968805-24090-1-git-send-email-wenyou.yang@atmel.com>
X-Cookie: Caution: Keep out of reach of children.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NxDiCysn+RCvdoZt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 03, 2013 at 02:00:05PM +0800, Wenyou Yang wrote:
> From: Richard Genoud <richard.genoud@gmail.com>
>=20
> Fix using PIO transfer mode only support 8 bits transfer, doesn't support=
 16 bits.

This doesn't apply to my -next branch, please check and regenerate.

--NxDiCysn+RCvdoZt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRd61eAAoJELSic+t+oim9IlUP/2L+qtobfU9rH3WqRZX6NYo+
Z6N/Qo+1oZsEgTph8AF8AnOWOjObK+lGhVdxkHw1YdGN6p3arRcre8lirggKLrmm
ZYmqHiu+IxEIm7XAZ7mksQU8WZerWtx53DSM7UkBIzgl6Fw9rUgTh268OQtBu3WE
BdtxPSu8sFX8MGLMiMR0igJhLuMoqgwZkODJmPbExqST87dqV7N+jTdWRhU/R0Z5
nCjLZFFJzFuxoydTX4XCmBcSoz1miwE7QJIS3F8DzFOBfKHsIEDenA9yzzJktwg1
OiOUqj1PoCTFFQsgIpV/SJzlBAQleAYqIipaQEFNlYjhXD0z3nSicUf1hkCzcXO9
Dqno1PsSJknDaXJ5KWlEoYlaH5Yvb+EzJxygt4aXfS1/dQnnvQb+eDHLY0YpJuTo
UgYhJP+jYoGyAL1jwu8z5olGBw4U+hzBqfAIy2qFLRFIEoeO7CJ2QuBZVAjKOzvo
iGVVKh2p4kHVDe9t7sZOqbTGiRyvWoZQjm4/BuIAAAp9iTkWgCHF/o0Ura1C66aH
5n3aFETbXaJtyQiPfJhwjwn3ff1teK6336nv4aKIg21y/IeL7R9pkbov3U87s5Rz
koiiio/KhaL9paiIhEGgHgM/OJizEltbH1GOmNNgl7K2vttMSVtPNKOXD3d2RAJe
M/jsFiyU7VfU8XMwqy19
=8hPv
-----END PGP SIGNATURE-----

--NxDiCysn+RCvdoZt--
