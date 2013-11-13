Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab3KMX3j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 18:29:39 -0500
Received: from ring0.de ([91.143.88.219]:53140 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751531Ab3KMX3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 18:29:30 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Thu, 14 Nov 2013 00:29:24 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/5 v2] input: tc3589x-keypad: support probing from
 device tree
Message-ID: <20131113232923.GB13669@earth.universe>
Mail-Followup-To: Mark Rutland <mark.rutland@arm.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Lee Jones <lee.jones@linaro.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
References: <1384265618-10590-1-git-send-email-linus.walleij@linaro.org>
 <20131112153057.GA9683@earth.universe>
 <CACRpkdb_bryGJo7CKGP5tj3RFGv=Gh+Q5m9ucVKqJ068tjPC2g@mail.gmail.com>
 <20131112200514.GA15413@earth.universe>
 <CACRpkdaAaLjm_b+OLj3tobxBN8YGUcTPnXJ=qtBqd02=FTxhjQ@mail.gmail.com>
 <20131112204013.GA17674@earth.universe>
 <20131113142406.GH21713@e106331-lin.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
In-Reply-To: <20131113142406.GH21713@e106331-lin.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Nov 13, 2013 at 02:24:06PM +0000, Mark Rutland wrote:
> > Current suggestions (taken from kernel) are:
> >=20
> > * <<vendor>>,no-autorepeat
> > * keypad,autorepeat
> > * linux,keypad-no-autorepeat
> > * linux,input-no-autorepeat
> > * linux,no-autorepeat
> > * autorepeat
> >=20
> > I do not really care, which one is chosen, except for two things:
> >=20
> > * <<vendor>> seems wrong. This is not vendor specific.
> > * I would prefer "input-" over "keypad-", since then the same name
> >   can be used for single keys, buttons, etc.
>=20
> Both of those sound valid to me, but I think it may make sense to keep
> the "linux," prefix. As I understand it this is really telling the Linux
> input subsystem to react to a device acting in a certain way, rather
> than describing or configuring the device in a certain way.

That leaves the following two options:

* linux,input-no-autorepeat
* linux,no-autorepeat

Any suggestions for those?

-- Sebastian

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJShAtTAAoJENju1/PIO/qapIIP/1nOGTKGR/ITDpzrdQBJ7vnG
1607bRwWnJvSOulQXp7XtqeEMz0brrZgamE2d/CHUxxQSQtrJTCZTDB4VDFxVUAq
vzVAZpH54czpN+vA+zS7KJo47VJ83o9lk0G07F4FVVPLr4mCd6CdLVGzeo009gG2
bfXwxvgObOEHsPa7mZoYseSl4fJctTcbrqJmsNLyZ6yO6eowFLX3RR+MJhuhleCm
C1BnbN4WVnqSAnmPAbXGGZx8C7dzZGGjg3qR5osQIgD4gRkJ04ylHhTkgSgfgM6G
Kp14tE8exYm592B5HH3uI/GKvgOsfeUA5o7Af2AP4ol1/BFE3jjYzwbeNYoEu0dN
NbsmD2Hf3QxjGRwhklxXrX/mmYdSHxRWyEtK4uH2h3qdyGx446ZRjq3NqqqBJEj3
ANhAeNJWobFqC9KHO6rJW/a0IUg8v/wUr33P47zetqTDVFppk/AEyMh9iV/mNXCr
e2Fjbmb0wxRhdBcCnv6mFHv0hoYEeaybl+nKvsQ0ELw8wPo6p/B20pQNJJOaSmBb
QYbybQ8XJNQx0L4dMDq4gH6HbOVb+7VAymsM+Xf4Wvq59k3NPlr+W58plA57xDRB
UqBWKHEaWggfeyqizg4Fr8qhqB1ySg2xrk0HvCovr1qlkQgscg6FbnVmwGPH2fnE
/9zrq8KgGJRsQN1LUnzP
=iEj7
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
