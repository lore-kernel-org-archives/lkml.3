Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814AbaIPQ4K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 12:56:10 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45341 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081AbaIPQ4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 12:56:08 -0400
Date: Tue, 16 Sep 2014 09:55:54 -0700
From: Mark Brown <broonie@kernel.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Message-ID: <20140916165554.GQ7960@sirena.org.uk>
References: <1410882844-10349-1-git-send-email-heiko@sntech.de>
 <1410882844-10349-3-git-send-email-heiko@sntech.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uvVZtPvgEsTJmsHL"
Content-Disposition: inline
In-Reply-To: <1410882844-10349-3-git-send-email-heiko@sntech.de>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 70.35.38.154
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 2/4] dt-bindings: add devicetree bindings for
 Fairchild FAN53555 regulators
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uvVZtPvgEsTJmsHL
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2014 at 05:54:02PM +0200, Heiko Stuebner wrote:

> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -49,6 +49,7 @@ epson	Seiko Epson Corp.
>  est	ESTeem Wireless Modems
>  eukrea  Eukr=E9a Electromatique
>  excito	Excito
> +fairchild	Fairchild Semiconductor
>  fsl	Freescale Semiconductor
>  GEFanuc	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
>  gef	GE Fanuc Intelligent Platforms Embedded Systems, Inc.

Google tells me that the stock ticker symbol for Fairchild is FCS
(sorry, should've spotted this on the previous version).

--uvVZtPvgEsTJmsHL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUGGuZAAoJECTWi3JdVIfQSf8H/AuetSC7i2wwfoM+atzBDv3z
iFqBtl1/Z/+Mp5KOBNjsXUR5PjYTeCseleGZj5cchDkSCle9BTuIetoB0u59DQSz
xIzq6qQGBuP67DzpichY4W0hv3EQ1QPfsgHJPFFlEfYU8I1Z9CoyeBuxtoVAHEqt
+4f7iSmyYeH8eKDMHeZN43/RYxuTRhiziZ5Hr+fI4UawKQOWqEOJ7GIrOPpukHul
D6LwMsarLLe2T0VP6UZ30Ph1pTwv5hcY8ogIW7D2+dvOvhll1kbWcjJUbjsKNEC4
gQsQVyh5ncLXBqNBXn2/VF5g//hNtYT86nX/A7YeRP5G4qCLndV3FiJG43uTlww=
=6dNL
-----END PGP SIGNATURE-----

--uvVZtPvgEsTJmsHL--
