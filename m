Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756932Ab3J2BGn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 21:06:43 -0400
Received: from ring0.de ([91.143.88.219]:37803 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756818Ab3J2BGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 21:06:40 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Tue, 29 Oct 2013 02:06:08 +0100
From: Sebastian Reichel <sre@debian.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: linux-input@vger.kernel.org,
        "=?iso-8859-1?Q?'Beno=EEt?= Cousson'" <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
Subject: Re: [PATCHv2 1/3] Input: twl4030-keypad - add device tree support
Message-ID: <20131029010608.GA5353@earth.universe>
Mail-Followup-To: Kumar Gala <galak@codeaurora.org>,
	linux-input@vger.kernel.org,
	=?iso-8859-1?Q?'Beno=EEt?= Cousson' <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>,
	Russell King <linux@arm.linux.org.uk>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org
References: <1382446042-27099-1-git-send-email-sre@debian.org>
 <1382446042-27099-2-git-send-email-sre@debian.org>
 <5137C017-2515-427C-865F-B938CC24B210@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <5137C017-2515-427C-865F-B938CC24B210@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 28, 2013 at 01:42:47AM -0500, Kumar Gala wrote:
> > +This binding is based on the matrix-keymap binding with the following
> > +changes:
>=20
> Maybe be a bit more specific and say 'based on the input/matrix-keymap.tx=
t binding'..

OK.

> > + * keypad,num-rows and keypad,num-columns are required.
>=20
> Is linux,keymap required from matrix-keymap.txt?

Yes, matrix-keymap.txt contains descriptions for the following:

required:
 - linux,keymap
optional:
 - keypad,num-rows
 - keypad,num-columns

> > +Optional Properties specific to linux:
> > +- linux,keypad-no-autorepeat: do no enable autorepeat feature.
>=20
> Does it make sense to update the matrix-keymap.txt binding to add
> 'linux,keypad-no-autorepeat' there?

At least according to devicetree documentation there are
keymap-matrix.txt based drivers, which do not support
"linux,keypad-no-autorepeat".

-- Sebastian

--huq684BweRXVnRxX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSbwn/AAoJENju1/PIO/qakfIP/RzLbeDgdIolOTlkwGfucBEa
lPxJn/QuxpFeSMN/rC/2ui+palmqwwCgMYl2t9KeyERdRuna6Tm7aDT784fANRA1
bZE19QY17Nl4usNyyfNDfnPpGaLg6shyopNYtxnEfTW/5437VzBcUEqHzebrCeCB
myFB4kxtq5OViNHQSjdHE68+knzbmUmXRp8b8VoM/XzWaVUH/hN23JA7rataRqKd
UMtW8/K6nchvC/YB7cASpYjmDQEclUdhPro9bYXw5HUNQiC4wAWFPBoeOrJ7GyYJ
Aj6g00EEp7iQmz2VtqhMOagUIbV1+LG5YQP7IHYSmh0wgVgwLiPAD2ZUCHEYLAB0
Qxq4lcLvoD6ug+d1eWfek17MClIbn+AORKxZwJcCECxPxEvBdNet2dA1JpzEWKTA
2NaQ1zKYnqvhL0dH47zc4gzz0uhW31ADdNDNgjHmVTK31XM3RV0mhh14cTzUF5Y4
uKXhaE6r6X9kUM1j+CK2l0KU2Yo6avxqCdS+s4nzLQlBJK4IRP8OiVFjnZoULA1R
yMOnglxW+sIvPqfYUXzXmeq9oyoJKs7a9j2/QvcddoU6A6iunPIOqxS85lmFhpxh
sMO1OI6dtNYTxfAfnlebFhK7vIf7r1wmgi/cuA8oifmUKRdRjOfZyu+jmWo3e5ri
GyJZmbajGhCSTswzhhn0
=ixKm
-----END PGP SIGNATURE-----

--huq684BweRXVnRxX--
