Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbbAFR1J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 12:27:09 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37364 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751828AbbAFR1H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 12:27:07 -0500
Date: Tue, 6 Jan 2015 11:25:45 -0600
From: Felipe Balbi <balbi@ti.com>
To: Pavel Machek <pavel@ucw.cz>
CC: <pali.rohar@gmail.com>, <sre@debian.org>, <sre@ring0.de>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <tony@atomide.com>, <khilman@kernel.org>,
        <aaro.koskinen@iki.fi>, <ivo.g.dimitrov.75@gmail.com>
Subject: Re: 3.19 on Nokia n900: audio quality awful
Message-ID: <20150106172545.GK6502@saruman>
Reply-To: <balbi@ti.com>
References: <20150106170433.GA5408@amd>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Jtds+vpI57xq70EV"
Content-Disposition: inline
In-Reply-To: <20150106170433.GA5408@amd>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Jtds+vpI57xq70EV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2015 at 06:04:33PM +0100, Pavel Machek wrote:
> Hi!
>=20
> In 3.18, sound is nice and clear.
>=20
> In 3.19, sound is unusable. It produces nasty tone when it should be
> quiet, and there's at least as much noise as is sound.
>=20
> Unfortunately, list of mixers also changed (and there's cca 120
> settings), but a) it does not work with the old list and b) nothing I
> could figure out did make the sound usable. Some setting resulted in
> even more noise.
>=20
> Any idea what could have caused it?

$ git bisect start
$ git bisect good v3.18
$ git bisect bad

that'll help find what caused it.

--=20
balbi

--Jtds+vpI57xq70EV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUrBqZAAoJEIaOsuA1yqREbhEP/i0RGZglistS1EQLPyfxCwmu
6rLM8oq47XN63M10NfXu5xlHHbbnpgOCoinmcrntNL3IVeMlgrdOyuaR1Pf64NPA
F2KnAaoIHsa9D9uPGTdaTQTpQSPR8m+lER0GJCT6IhdSC0eZE8D0Gc+feubnqlWX
I2NmZCP1/NCY2b4swC74eBAHOWHFR+hIy9lf8TCR7B0RRxPzqsgu31/RohAGB3qV
K2VCiuWfHJOVWWEYPe/SzbjHN/Nk4SCOkTSpA2hZrbFGgBb8oV48zN4tlin1ux5H
Je3DZjs+9tdDabhXgIwTZetJY9P3i8bSeU24Ox6DOz4FgL8nM3jMyHUcmddcttKk
EplBOZAaevuVAAIT0J7i20bqULrykNomeLyJoCIndcPedvQbL+7UtChe2yhYPgmG
nWiW+EjT9Lg/SrkEPlkBgGuZtSq6LAgiVltflV2/XnLUu8cPtBuEpDV5YT3KV36t
inAJJy60t+whggRPtrcqcDotDwDQKPz9ydtMRAbimSAC6E52Fs46tXdEbfdp9zbH
pj5bW1PeOecWQ509CKG4IWAxKjNJZScIu1TdiMTzCHcmbwoNOomZXX4jCFhTmFpb
/5h4OaJ3hvON5BOzYosjWSVvC7WXQy/HGTlE/OzMd3CH2miKM+NArCzokvgWLSQ4
+3yBufIXUL08iA7iwepN
=3G77
-----END PGP SIGNATURE-----

--Jtds+vpI57xq70EV--
