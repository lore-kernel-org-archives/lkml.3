Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab3KXRRe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 12:17:34 -0500
Received: from ring0.de ([91.143.88.219]:60972 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752760Ab3KXRR3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 12:17:29 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sun, 24 Nov 2013 18:17:23 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3 1/2] Input: twl4030-keypad - add device tree support
Message-ID: <20131124171723.GA1050@earth.universe>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	linux-input@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1383948866-32672-1-git-send-email-sre@debian.org>
 <1383948866-32672-2-git-send-email-sre@debian.org>
 <20131111221941.GB23331@amd.pavel.ucw.cz>
 <20131112032506.GA30028@earth.universe>
 <20131117182840.GA30012@xo-6d-61-c0.localdomain>
 <20131118035815.GA3311@core.coreip.homeip.net>
 <20131119125031.GA14587@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="TB36FDmn/VVEgNH/"
Content-Disposition: inline
In-Reply-To: <20131119125031.GA14587@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TB36FDmn/VVEgNH/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

> > > I'd suggest just simple "autorepeat", so that we get rid of ugly doub=
le-negation.
> > The idea was that majority of setups want autorepeat so in the absence
> > of the property autorepeat is turned on.
>=20
> I see... but autorepeat on by default makes sense on devices that are
> usually querty keybaords, but does not make sense on devices that are
> usually phone keypads or power buttons.
>=20
> So my proposal is:
>=20
> 1) driver decides if it makes sense to autorepeat by default or not.
>=20
> 2) dts says autorepeat=3D0 or autorepeat=3D1
>=20
> That way, we get dts that get chance to work on other OSes, get rid of
> double negations, and get right defaults when autorepeat is not
> specified.

Sounds fine to me. Any objections?

-- Sebastian

--TB36FDmn/VVEgNH/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSkjSiAAoJENju1/PIO/qaixUP/1NY6jaxnhiLo1qW0KJ68Fuh
BXvrCogHOlW64FxhNc+m5g8E2Lzijt34eVGvaD/PPm+Yhs5qNXcGta/7RZtEnEaw
/IK0bKDhF9cfvUusfZhOMbbTsuEac2C28kNPl9We7f85uL8G3pzMV+WGv74QU6R5
gD3dSymnNhUUokvVVrb9iU9u3HgZDm87bfGaFqJsDmlKAjBtwzLB0iZnQ684+87a
HiA4oWNlbA+Wyxb0By9eqgF6RKGXQrrmeSGx7A11xoSb3xli8aXO825WE09na2aB
WjDMXpTiAVcjCDAWGjOIxFu3nzKZYckOjOg9aVNkCm1UD3DIqhS51MMSAq/QSFev
kLvq0SzqRL1J4XSGVSrxyHQGvdOWQ9GLGpHjOYcWTlE652laIhrnQreltypfa6va
Km/GrAX4qsHDWj6iYolUGPkaUBMgA9UG9p1SKfclZy+ccCLdmhM9AwzNTK+KY2Bt
wMdKbaopNQ63WWKgFni0hopjj//9+H0KVJAxgzq506IOHuupeQ3NBtESjXRwG08x
6XdL/Xp+1JISkPKEuohvg86eSJh0twEkOEkqRpn9pbwExWYku1oiCwdept+W6nt2
1kdKBoA36p2H9+L52BqbmSuehgjpB697k5Dqmq6/x4cz6mkHOG5FiyXU3FELeSkR
0AVqR1mcjt8CrIbQftm8
=lh55
-----END PGP SIGNATURE-----

--TB36FDmn/VVEgNH/--
