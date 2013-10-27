Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815Ab3J0LcB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 07:32:01 -0400
Received: from ring0.de ([91.143.88.219]:58284 "EHLO smtp.ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab3J0Lb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 07:31:59 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Spamwahrscheinlichkeit nach Bayes-Test: 0-1%
	*      [score: 0.0000]
	*  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was blocked.
	*       See http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
	*      for more information.
	*      [URIs: ucw.cz]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Sun, 27 Oct 2013 12:31:48 +0100
From: Sebastian Reichel <sre@debian.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Beno?t Cousson <bcousson@baylibre.com>, Tony Lindgren <tony@atomide.com>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dts: N900: GPIO key definitions
Message-ID: <20131027113147.GA14091@earth.universe>
Mail-Followup-To: Pavel Machek <pavel@ucw.cz>,
	Beno?t Cousson <bcousson@baylibre.com>,
	Tony Lindgren <tony@atomide.com>,
	Rob Herring <rob.herring@calxeda.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Stephen Warren <swarren@wwwdotorg.org>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Russell King <linux@arm.linux.org.uk>, linux-omap@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
References: <1382446178-27638-1-git-send-email-sre@debian.org>
 <20131027111728.GB2437@xo-6d-61-c0.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <20131027111728.GB2437@xo-6d-61-c0.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 27, 2013 at 12:17:28PM +0100, Pavel Machek wrote:
> On Tue 2013-10-22 14:49:38, Sebastian Reichel wrote:
> > Add device tree node for the GPIO keys provided by the
> > N900 board. This is a simple conversion of the existing
> > board code.
> >=20
> > Signed-off-by: Sebastian Reichel <sre@debian.org>
>=20
> Reviewed-by: Pavel Machek <pavel@ucw.cz>

This patch has already been merged by Benoit.

-- Sebastian

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBCAAGBQJSbPmjAAoJENju1/PIO/qat1cP/0E5InWrRZP9fQM+nDdJGVBY
I16/CBpGUU3aPozsq+X7yrHX1TsyGmbAiwL1GFV4bbmfn6lclMv9QTUTOUmAV7uZ
vUJ7LpVfw3VXjVvhq4AY3KivQlDLzHJG4DhwRlzgUqlsijARsn2OUPQ2Hr5HRoZY
xvo7FdxBNamclb39NA38cB5j6kc9i+fcTIgwFa5UvrvmUAMKdOoh1MvFqr9woVih
U5iz6JThK1BJ53lHc6bElkXBxtb6R8j5AiEQXm6OvtaclKBrnLqf7uUCkUipqyrF
MAl03I6HQbRvr66pVq6agifHA9u/cU1aAIsGcbbAazhkcvYBi15+Lc7C+i3DgA26
wUgAEcWnCbkCsMDy69PoAirwLRztjAeH0Zb6Sz7cwg6WpokRdx0wtc3Zst4ZYYrK
Rh39Mb6UExo/h1wAD4qmKHAQECyxEHIGDmC+38ypR8P3X1+GQhOFRnCuQTJ5/e1s
SBEouXVOAvDCqz+N3+o5F2/oS7rDMaghMUpn1LgJjCuTow0HTVNfclk9knrLckkf
Zm8fgbQM2kOQjqbsquoZgznjNCtn5fPFVhr6a90QGFrmKZihM1Ma/HHIRMdl4gMK
Iyr5khkNgdMFBCMUovg/QV2n0b15h6L9aT0oaMbnKl6nWvgsrkF8Wxbg4jYVqKg9
pO8hV0jGWQZrllvLdVmc
=+grt
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
