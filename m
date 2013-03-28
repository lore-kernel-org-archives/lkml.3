Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab3C1AN4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 20:13:56 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56270 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752803Ab3C1ANz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 20:13:55 -0400
Date: Thu, 28 Mar 2013 00:13:53 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        Jonas Aaberg <jonas.aberg@stericsson.com>
Subject: Re: [PATCH 21/46] regulator: ab8500: Correct TVOUT regulator
 start-up delay
Message-ID: <20130328001353.GN18316@opensource.wolfsonmicro.com>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
 <1363881583-15234-22-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWxvw4U2tXStDw65"
Content-Disposition: inline
In-Reply-To: <1363881583-15234-22-git-send-email-lee.jones@linaro.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JWxvw4U2tXStDw65
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 21, 2013 at 03:59:18PM +0000, Lee Jones wrote:
> From: Jonas Aaberg <jonas.aberg@stericsson.com>
>=20
> Update TVOUT regulator to match specification. (Was 10ms,
> changed to 500us.)

This fails to apply due to Axel's changes which remove delay entirely...

--JWxvw4U2tXStDw65
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRU4s7AAoJELSic+t+oim9oyIP/0Wfs/Ef7pbg7xXXXST9cxWh
x/kDSx1U9/DIoVUmuXqmqaIhx6WNqRw4yT4f2pjqGpBtEGiHqeE9exyWIYF74oOE
hObZsnTihd+NHPbfyNMNbqrZmUw4zSymRWprZQTrKqhf4IVdx+8NlS102LLDrC9F
HgWJoaTPeNDw86vReAX9ZzFKYtF22sD/N1b/4vVbFRprZjktby9S4RiGZ/kuu3tv
VeSur7AcMXbzXhImSFC+dQ8/8M10mUKJ/R1m9i4zOmXyw5Db2+LQ/Jf1z+SgqaQv
sHmZq3dwi3EDF7xtm6+GCPdoRZrtdTJkLbcrQBLZUWCp/Di4KgN47um9hnH9ttPQ
TO3T84nvf6/tn/8mG/qoABF9KOIwXCNcW3XiecF+F2cI8ujGf7UIC/k7Vnwp/QBL
Ao2aWFbC2NtRyDySqFenbeOc0+iXNZazvniS5E3HxP9ffNqzvl59HaZUvUbps3dC
9YVGzNvftgoYkH9LIOHKxafbaoEJqM3naC4fJUqX0adNYSszd1nmwM302EA8PA77
Aq6VL3EC3gDR38PxjracBXPGdiFtQDxSu0ecovSnuFYF2umB3cy1JSnoOK1xkXQ9
ogdkiRPK/eXKMZl8XmfcJQOOytWPdPEEy74yUT67h/EPvUwpM1REZC0VuMWVTXrt
nBM1p9Dlp8TLF3mF+Zbh
=hX+P
-----END PGP SIGNATURE-----

--JWxvw4U2tXStDw65--
