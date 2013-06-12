Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab3FLP2L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 11:28:11 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40666 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3FLP2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 11:28:09 -0400
Date: Wed, 12 Jun 2013 16:28:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Alexander Shiyan <shc_work@mail.ru>,
        Lars-Peter Clausen <lars@metafoo.de>
Message-ID: <20130612152804.GH1403@sirena.org.uk>
References: <1370953095-32044-1-git-send-email-srinivas.kandagatla@st.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LYDt+Tnt2WQ/hIRe"
Content-Disposition: inline
In-Reply-To: <1370953095-32044-1-git-send-email-srinivas.kandagatla@st.com>
X-Cookie: Tomorrow, you can be anywhere.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v3] regmap: Add regmap_field APIs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LYDt+Tnt2WQ/hIRe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2013 at 01:18:15PM +0100, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>=20
> It is common to access regmap registers at bit level, using
> regmap_update_bits or regmap_read functions, however the end user has to
> take care of a mask or shifting. This becomes overhead when such use
> cases are high. Having a common function to do this is much convenient
> and less error prone.

Applied, thanks.

--LYDt+Tnt2WQ/hIRe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRuJOAAAoJELSic+t+oim9HkEP/ii5gPATRzKjHkHkQinxPR+g
3Gw086Yrhdd/ZtscF7bWPTXQXux3dyXwJIsGvDvUUnXcsfxtEDApBir+3q4IFtRI
AJtPO6Sqx+61FqCmRZuluBMwbt46WlMKNVBhwP5M8E/pe8ykT2XfqPgxzbJW1g+I
uZYlYQIF3UwjBw1CF1hYMyKnMlGbPpHJQhxrlpNRUcHdcdzw5qZE6h9apbcZasO8
y2/LhnzAKutOVgsnKXbIOhntRKpC/28CXlmYHZapGyKH+sV8Mw3Cd5ByWhRq9k0O
/DC0OKbElppL6GMnxG6c3G9zWWFcxSxoX67CDuWh5aZrwiy3aw9TNoacHnS1kIxG
lYJCQitajan5TXwintGZyYO4luKUWJTSU9lLME5+qMlnSkUv1Psv1MI6T56Vx5Oc
jmB3J4a/PIa7hfzE2QVp/t9CR+HijyFZ0yI9SnDB4llpKC6IUjDcbAdrVpnh2J5A
Yy+eMy95zn/I+mkcGwd+anIytv+OOnvMzl7U+NctAlPPjSu7F7khKFnKlwMBsRSG
GbYafW8ZTBPuJFQKLTLnqQGuWjYTKpyIPIwOclMGJrdwBD0f3x0FyJLIv+M6XPry
ybywe/1qmJ4B1cKaNQqx8Ok0QtxOXsxIXNEjTGy2nMt1xW6wXzfHqfrTuXfg+7g0
LyUVdGvpSRDdG/n9tmqF
=/JXQ
-----END PGP SIGNATURE-----

--LYDt+Tnt2WQ/hIRe--
