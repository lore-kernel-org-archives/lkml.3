Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752241Ab3F2HLV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jun 2013 03:11:21 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:35050 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751356Ab3F2HLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jun 2013 03:11:20 -0400
Date: Sat, 29 Jun 2013 09:11:18 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Cc: Shawn Guo <shawn.guo@linaro.org>, Russell King <linux@arm.linux.org.uk>,
        jimwall@q.com, brian@crystalfontz.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 8/8] ARM: mxs: dt: cfa10057: remove hogpins
Message-ID: <20130629071118.GG2593@lukather>
References: <1372424577-8279-1-git-send-email-alexandre.belloni@free-electrons.com>
 <1372424577-8279-9-git-send-email-alexandre.belloni@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="doKZ0ri6bHmN2Q5y"
Content-Disposition: inline
In-Reply-To: <1372424577-8279-9-git-send-email-alexandre.belloni@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--doKZ0ri6bHmN2Q5y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 28, 2013 at 03:02:57PM +0200, Alexandre Belloni wrote:
> Necessary pins are now grabbed by respective drivers. Unecessary hogpins =
are
> simply removed.
>=20
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--doKZ0ri6bHmN2Q5y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzoiWAAoJEBx+YmzsjxAgh78QAId42+mDizNz4KtJ9skiCeGQ
TKrWzmX+uE+CccBVt1RA829yyRUs6jXTwlUVbd4huOeI1aDE6JlsxKqKHBa0RQqS
inZayJzbbzXGgDQSAZyguyYXeBSidh81wee+3gYNtYMP+/vUxhDTP/zuHMDGJxAK
0bafQlwjCdcwpNO+6iaTiKdoNL53EZ0PkWXyyVbQwd8cxWjxR8kAXC/QiTaD6aSv
e3JP+s26MJc24YYvWpVi2kBKJTG+claHJNPwAdu4W7eBk/uTvz8VzhBSgsk44uSJ
63u8QaW0smhkfsGjaE8VC7rKvUF4LlQqIxB2F2KW3uqA3neCdgoMuL8Kr+Izr/v7
2f85j7/0Pc4G0DZ8Fx39VG3aZ2zF2EHUMHsiRWyGwvlBbvIrQW/ieOzRAYnwNygi
kfmQAcTlM8bYqy39FXo63YY7hZFNdMPgk99S4fSZ3D4Hw1oVOLEKZsZzP3X2D/rl
bxbeWJkmt0JMMyWcGb+752WB+AolCu0se9kgZncx4xkeORteyNPUF+dfRmNhpsxI
Dl220IEGFBEx71/s6LlPECC6jYo06Zz+GcbTrWqtdfQzzzETVRVTVzsGXfws6BSE
E+pf+Yz8xSlVfFmo+GFxdW/QV1iB+zemld39I7fBLwuUUw+q1A6PFCETeHVCuvs5
gFdyq9IE4F6n0od+pVP6
=X/KL
-----END PGP SIGNATURE-----

--doKZ0ri6bHmN2Q5y--
