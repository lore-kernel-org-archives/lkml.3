Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab3KWMKH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 07:10:07 -0500
Received: from ring0.de ([91.143.88.219]:55671 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752898Ab3KWMKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 07:10:01 -0500
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: spinics.net]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sat, 23 Nov 2013 13:09:52 +0100
From: Sebastian Reichel <sre@ring0.de>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Herbert Xu <herbert@gondor.hengli.com.au>,
        Tony Lindgren <tony@atomide.com>, Matt Mackall <mpm@selenic.com>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/3] hwrng: OMAP3 ROM Random Number Generator support
Message-ID: <20131123120951.GB21861@earth.universe>
Mail-Followup-To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
	Herbert Xu <herbert@gondor.hengli.com.au>,
	Tony Lindgren <tony@atomide.com>, Matt Mackall <mpm@selenic.com>,
	Russell King <linux@arm.linux.org.uk>,
	Joe Perches <joe@perches.com>, Aaro Koskinen <aaro.koskinen@iki.fi>,
	linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1379534757-20870-1-git-send-email-pali.rohar@gmail.com>
 <201311182251.35704@pali>
 <20131119021409.GA2820@gondor.apana.org.au>
 <201311231037.13908@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
In-Reply-To: <201311231037.13908@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 23, 2013 at 10:37:13AM +0100, Pali Roh=E1r wrote:
> Now 3.13-rc1 is out, but your tree was not merged. Can you=20
> try to ping Linus what happened?

See here: http://www.spinics.net/lists/arm-kernel/msg288508.html

-- Sebastian

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSkJsPAAoJENju1/PIO/qaHpoP/jq80GqizwWhSWhR7YxDOlCD
WGKMO0xGqIazW+EN0jjx9Ol1MnAJKZgKeKIv1hykHo9vXZIqJrGOsI/jA0IrofEG
XdLwqwvj7xAoFWYXMIsrKA98fn2/1FsVr52kKU0Wbr9OZQ7W/25lCkablcbX2cI5
4xCxNMtPgoBk9MZ+g6pGbEqnV3VWamBfBzDa9UpDgywOr9PLvbtzelROkdBkjQKd
mlnSQ0JnCD1we6eDS1OVPfvnSuOXXW1Gcj4KrWfJC44FyYUl4fq4mwcCA12wT/ts
o+ecpqk+R76Kq8y9oFZ8lzPJuYU0OyLjZyp2g786i9VPu0xX7zD04T3eCUierESA
jfmrn5aYmXATnq34ZDSn8RjXFv1qG+Q85sK8lHDjLnm2ctVuxO48z1yKEKVf0c1X
Q9fB4QDv9aqvGMlEjEiRCVNWBJWarAfKeQrZpM9vIvPpRov+ICfcBi73cXG8K87P
89Mv3zN/9DPTdJOQAsd6d8xiaOvWabRSE9RPCht3GZYmQ7Zw46A+D+X67SzlmEZw
gheO2/0nR+1d9gbdCrZ2lkvI+wX1diOtfDq5FBXZbZBT1sxiWpeMVWET0+WHEj3g
fuNo3SlkEskeREXRlhcQeM2Puoy6GNHAYj8qx7PVwWCu38sSXP49ws6lXnrUACTJ
OZQ2rBEhabAzg4wBBJad
=9/GX
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
