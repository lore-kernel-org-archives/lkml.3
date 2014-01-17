Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbaAQSAX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 13:00:23 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:56087 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752600AbaAQSAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 13:00:20 -0500
Date: Fri, 17 Jan 2014 18:00:15 +0000
From: Mark Brown <broonie@kernel.org>
To: Nishanth Menon <nm@ti.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20140117180015.GA17314@sirena.org.uk>
References: <1389900750-27625-1-git-send-email-nm@ti.com>
 <20140117160821.GV17314@sirena.org.uk>
 <52D95EA1.6000608@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Hch1Uz/zGPcHFdv8"
Content-Disposition: inline
In-Reply-To: <52D95EA1.6000608@ti.com>
X-Cookie: We have DIFFERENT amounts of HAIR --
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: ti-abb: Add support for interleaved LDO
 registers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Hch1Uz/zGPcHFdv8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 17, 2014 at 10:47:29AM -0600, Nishanth Menon wrote:
> On 01/17/2014 10:08 AM, Mark Brown wrote:

> > Is there a system controller involved here by any chance?

> Nope. ABB LDO module is a standalone instance whose register set
> happens to be part of a memory range, as I recently got to know, is a
> favorite for our hardware designers to put "misc" modules at SoC
> integration time - Sigh! I guess I have made more than enough stink
> about this internally already :(.

That sounds exactly like a system controller :)

--Hch1Uz/zGPcHFdv8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS2W+sAAoJELSic+t+oim9n2AQAI0kIZoMcPjhCM5OIo2/D7as
oTUwvd+BtWSC7FPxD+T34yfUj+iQQ1lywAsP3W4xRzp3gYJ93qlpqB2UHwFsWarj
nAO1Xx2rc0oJwAq7S1N6PpPuGP3XH3wSjAZzFi/ffiVwFYKdohPGJaT8qzHNdJ1g
rabAv8m+HcwZhVB8dQa8r4g+I8g6lqiLGdo28bs5FitQoIgrWyKF9kUJbesWhwYi
MsJXbrQoLA+cluQISH3t952lPu3bko4EL+ayu+Yutmb9/8qTt5OZLtlyHldyzSVO
k/TzqMPkxSvNGDlbxskYBUqkwVVERyS5cRf9ZTQnmaVQucxlum3ifbdKBjTeTSCa
MDXbl6m+Wp4+izQ45brYtlyjRkJdE8nAxJQ2wA1WgIlf7DzODDtl619RI+BIvYEk
Mk//SwSnoKxyFB9StV08CexdxxVGYGA0+FfGgDdixTpZwi3Tv7yF7Kn/dhvBmHEH
5rmB4WCqwyQ0IAbh39ItnKclQqR55Lr418IHDbOtZvjMRDr/v7Y7zmEcTgd5xB5V
PLG9Lr4PCtxDwyvfAUVqH7rQW0Y1CfrMufz20ogtLADUEIR9GjjrHf3yNowXgctF
nXAWpviN/cE6yBbx0M26++4lPLwFLy1FfOScwRDnawMfiMvt9PxXaGzAr1NnqpTH
PQ1TxRuVWxxdExZRtgzI
=/bV9
-----END PGP SIGNATURE-----

--Hch1Uz/zGPcHFdv8--
