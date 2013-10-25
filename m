Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab3JYXJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 19:09:41 -0400
Received: from ring0.de ([91.143.88.219]:53382 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918Ab3JYXJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 19:09:39 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: lkml.org]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sat, 26 Oct 2013 01:09:07 +0200
From: Sebastian Reichel <sre@debian.org>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-iio@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Jonathan Cameron <jic23@cam.ac.uk>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iio:light:tsl2563: Add DT support
Message-ID: <20131025230906.GB8657@earth.universe>
Mail-Followup-To: Grant Likely <grant.likely@secretlab.ca>,
	linux-iio@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Rob Landley <rob@landley.net>, Jonathan Cameron <jic23@cam.ac.uk>,
	Peter Meerwald <pmeerw@pmeerw.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Bill Pemberton <wfp5p@virginia.edu>,
	Sachin Kamat <sachin.kamat@linaro.org>, devicetree@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1382565063-17083-1-git-send-email-sre@debian.org>
 <20131025191028.8C140C40422@trevor.secretlab.ca>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
In-Reply-To: <20131025191028.8C140C40422@trevor.secretlab.ca>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Fri, Oct 25, 2013 at 08:10:28PM +0100, Grant Likely wrote:
> > +  - cover-comp-gain : integer used as multiplier for gain
> > +                      compensation (default =3D 1)
>=20
> Should be taos,cover-comp-gain

Has been updated to "amstaos,cover-comp-gain" in the latest
patches, see https://lkml.org/lkml/2013/10/25/59

> Otherwise looks fine to me.

Is this an acked-by?

> > +	else if (np)
> > +		of_property_read_u32_index(np, "cover-comp-gain", 0,
> > +							&chip->cover_comp_gain);
>=20
> of_property_read_u32() should be sufficient. You don't need the _index
> variant.

ah, I missed the function when skipping over linux/of.h.
I will sent another update.

-- Sebastian

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSavoSAAoJENju1/PIO/qaPngP/iTc636yeeTXa3PxCxazE3Xm
qTdwUYjgbQlgbNZ0zebN2WZCE+zu95Txeb6Wd6tTS7Nc7FXu3RNFNyazxPxcqjmo
LAtXIRpD9OcDp2HWzxxIzAirRHejkj7KCS16GNlI/TZIbwlU+CPMz8FWFWF4jrJf
5ud0X32XuUFhNI5C9OQ6a9Y/H9e3jny/q6jaIrb0JDo6sVnY8ggfvTXpg212OXPS
a/EbcNw6grtwWFdJZBXDohDlzsBPMKhJVe1Ic1pNp4L1jrHTg1o5NqTf2QEIx61w
TF4u/a0TNSONVi6oOJys5g//u+ETpfvbY70BYc812J4CCcAdUyWivzjc7UWXptpQ
lc+LjI2wglcGr3vulbhxpP2+AbN0Tgmytj1le63SEhG54Nb3gjvBUCFB7ju7j56k
MCmVCZyiLDrFb8lzXr/Sqx/IO3lVBdNTBI/Zu/wLJ7AT0fZXYafuDAkpkHBcFbXs
IoHNi8wY9HDLblltxLbkUuJrPXygmFQBVGvuSRPl87ubK4Ct6Z88YLf6BJqby+kX
b//QprsTk+G3TSjnMLT3Z46cHPGjmO59n5nmVWC38OllugqrGTnZf57rHiBQhdZY
QDUsj7TyW4FpEjfhAl9cdM8pNCQdSdpzWeI72ErBRPgc87IUX34ZaW+LrFwwypro
2jXDswbaTkBOHO+oWrP0
=joN1
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
