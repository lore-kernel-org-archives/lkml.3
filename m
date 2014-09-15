Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbaIOW0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:26:09 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43802 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755437AbaIOW0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:26:05 -0400
Date: Mon, 15 Sep 2014 15:25:47 -0700
From: Mark Brown <broonie@kernel.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Message-ID: <20140915222547.GC7960@sirena.org.uk>
References: <1410722585-13393-1-git-send-email-heiko@sntech.de>
 <1410722585-13393-4-git-send-email-heiko@sntech.de>
 <20140915215410.GB7960@sirena.org.uk>
 <2217201.MLW1SzL0fz@diego>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hWmTLTlw74j3oMzq"
Content-Disposition: inline
In-Reply-To: <2217201.MLW1SzL0fz@diego>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] dt-bindings: add devicetree bindings for Fairchild
 FAN53555 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hWmTLTlw74j3oMzq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2014 at 12:14:43AM +0200, Heiko St=FCbner wrote:
> Am Montag, 15. September 2014, 14:54:10 schrieb Mark Brown:

> > I'm not sure what this means - What exactly is a "regulator" in this
> > context?  Are there really two separate regulators?

> The fan53555 has two voltage selection registers (VSEL0 and VSEL1) which =
can=20
> be switched through a gpio ... to use one as suspend voltage.

> So it's just one regulator output but can select one of two voltages.

OK, that's what I thought was going on - please fix this to be described
in terms of voltage selector registers rather than regulators as what's
there now seems confusing.

--hWmTLTlw74j3oMzq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUF2dqAAoJECTWi3JdVIfQKkIH/3vOT8t38Auh8hSGl3Z5uZvF
zyqXnF2lC+u0pUvez8g3dMafNjgBnrJJjaN1Yf8+ntr+Z7kVdEVdwFFkZvgpFTbR
XkZX5dhFxIeC42mWMOqQsLzF9LcKOE0lmZGKHEH5AZEBbXgyKXUitAT0ciJij/s8
Cvfdou0zkjcdwPge6QIU5l/ViavKoZjJMW1pa6raB1TL5N9ENfZCwqgYzVEMf/oL
bNsqx62amxUMTmgq7ubqorAPTsMFRnzAU5pBniCgWJtpbWgzCZOI9pnEe8S6igd4
1N3QVnch/Sk0E+zyHSUO6sH8mlrcpdNMtjb3y9+70in40uj9tWwSPlJ+g+WB7lM=
=C/B1
-----END PGP SIGNATURE-----

--hWmTLTlw74j3oMzq--
