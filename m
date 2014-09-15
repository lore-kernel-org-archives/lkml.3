Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757201AbaIOVyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:54:51 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43626 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbaIOVyt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 17:54:49 -0400
Date: Mon, 15 Sep 2014 14:54:10 -0700
From: Mark Brown <broonie@kernel.org>
To: Heiko Stuebner <heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, linux-rockchip@lists.infradead.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org
Message-ID: <20140915215410.GB7960@sirena.org.uk>
References: <1410722585-13393-1-git-send-email-heiko@sntech.de>
 <1410722585-13393-4-git-send-email-heiko@sntech.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="E6NCJjdg6OUEG/ZU"
Content-Disposition: inline
In-Reply-To: <1410722585-13393-4-git-send-email-heiko@sntech.de>
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


--E6NCJjdg6OUEG/ZU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Sep 14, 2014 at 09:23:03PM +0200, Heiko Stuebner wrote:

> +Optional properties:
> +  - fairchild,suspend-regulator: regulator number to use for suspend voltages
> +		possible values are either <0> or <1>

I'm not sure what this means - What exactly is a "regulator" in this
context?  Are there really two separate regulators?

--E6NCJjdg6OUEG/ZU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUF2ABAAoJECTWi3JdVIfQjPIH/3atNCdIf2+IJbhep7+hDrYu
cgSWqILjCsiafw4x28KkGOiUz2oPbfH04+L7DLKCh655O4sQ5zshKIrL9+V6CBv7
m4dZYBLXSlgU0/u8ZCYxYozrbUkhqAij4GHJQthtG4okfL4HixkH9j45nimTukb+
98fjM5OZsHEMkSXn7LK5d4G0VLUa1hGEtFiVHsY/uWxvUn8lSEfVENX0ItDLeH4b
6wxKeSSdrgQ05TBquRDML+IjqAXW+3kw3UjHvlX4gyRkVjvLjqq5XHcDon3x/1G7
GeE+wvE52So9uspHlih8EjkIH1DHSqxo/Wy6iWmhDigwQVXJGKCgT4Nq+EzF8BQ=
=zIch
-----END PGP SIGNATURE-----

--E6NCJjdg6OUEG/ZU--
