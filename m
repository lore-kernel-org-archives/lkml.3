Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753970AbaAUUsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 15:48:10 -0500
Received: from ring0.de ([91.143.88.219]:45631 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbaAUUsI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 15:48:08 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Tue, 21 Jan 2014 21:48:03 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Anton Vorontsov <anton@enomsg.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCHv3] dt: binding documentation for bq2415x charger
Message-ID: <20140121204803.GA853@earth.universe>
References: <1389393286-15263-1-git-send-email-sre@debian.org>
 <1389401268-15069-1-git-send-email-sre@debian.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <1389401268-15069-1-git-send-email-sre@debian.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

> Add devicetree binding documentation for bq2415x charger.
>=20
> Signed-off-by: Sebastian Reichel <sre@debian.org>
> Acked-by: Pavel Machek <pavel@ucw.cz>

I've seen, that you just sent a pull request for the power supply
tree. Can you please add this patch [0] and send another pull
request? It should go into the kernel together with the bq2415x DT
support patch!

[0] http://www.spinics.net/lists/devicetree/msg18023.html

-- Sebastian

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCAAGBQJS3t0DAAoJENju1/PIO/qaDgkP/3Yt8muD1GhmKTNV4LyIG+gl
7Am8UFoyfH3g1F15rpYj5JIqAxats91KPMPzNWPVJU+r0JTsxOADovj7ALgCUjs7
oZ5JCtmbHjulHtTQgYUKVNBogjqIU86QpmYQtfyOHqPVFOnrN3uh3L1rXarkkTkA
ZBplteSUqDy7rCbNOvUpzZvaQlcNt3cl5r5/clXKIj7Oe485tztLAMwzPkGfdDSP
m+tLTsWWPjubpdRAh6pLj55yoJPBk/WeirKfORwqQ2G/xuZgj8172WcFQEYgyGIq
jWs21deB1Lin8spYHwQpFmry4Nkzyhe7d659BrRP2sR2Oj4rmpQKQtWJ9Ejhsgnd
R2nNq5NZSlRKwvXsOOq+2J9ZkQaEWJXGCz5o3IOBcDCEWdYWEOqPrZmc7I6V7p8a
l8KcJJ1NaGwIqwOK8bKZVuZ0wm+apa30S/ca2ps6FEwqXUgDX8curNGgSQiHeiof
fWdTxuaG7mBvWaxgMwY6EaUNgj8tYuDBgmffclem0/0UbfDU14ZEf30BWkTaqbPy
nDpSmET35tx3Q3U5R7EDmbVZvVgvJxGVR9k7cmuBbNcy0/IWNWUqxYAYSiJy6miG
Xc/Ark3kb27I1m73JY8I9BWPOcl9PPm8dnQzFVHgjm9oRI4M9OhCzmw3UH7SEzaw
URKc2GLI6XT7s8tLmGCa
=0oS0
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
