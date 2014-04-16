Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756726AbaDPVAm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:00:42 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35396 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaDPVAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:00:40 -0400
Date: Wed, 16 Apr 2014 22:00:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Shuge <shuge@allwinnertech.com>, kevin@allwinnertech.com,
        Chen-Yu Tsai <wens@csie.org>, Hans de Goede <hdegoede@redhat.com>,
        Carlo Caione <carlo@caione.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, dev@linux-sunxi.org
Message-ID: <20140416210001.GA12304@sirena.org.uk>
References: <20140415223849.GJ12304@sirena.org.uk>
 <1397636170-664-1-git-send-email-boris.brezillon@free-electrons.com>
 <20140416170638.GT12304@sirena.org.uk>
 <534EBADE.1000608@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wtO4+9l+3RkKLqxD"
Content-Disposition: inline
In-Reply-To: <534EBADE.1000608@free-electrons.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: i2c: fallback to SMBus if the adapter does not
 support standard I2C
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wtO4+9l+3RkKLqxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 16, 2014 at 07:16:14PM +0200, Boris BREZILLON wrote:

> Actually I do not modify the passed config struct, I copy the config
> values into a local instance and then modify this local instance
> appropriately.
> But I agree that having a proper way to overload config parameters would
> be better.
> Any suggestion on how this should be done ?

I think just adding them as operations in the bus struct should work,
though I only had a fairly quick scan through so I might have missed a
case where it's more than just the init that needs updating to take
account of there being a bus with these ops.

--wtO4+9l+3RkKLqxD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTu9NAAoJELSic+t+oim9EAoP/2uJuCVK8NpaLzqIS1n/JKFT
9n+Llpi1nl7e3CLBkiMqN1dZVSKmlmf54c/BaYbYPiVj5dgmXo3PZLas7nSnkL2d
8RFd6kQmUO0uLV8vNws9cttuVcnkuLaPfB8Br/aatZsXeIIQ0/vL9GLNuVV2Hq4C
SsQMlrdaZy4dYAaihgou8qPvHngKDsw3TWB+neRuYRLkCxhjjrnWnpiyNgc49oWi
Q1DTQzjcCyIhgiPm3KYVsXO383DsHtQPkK19egLitrCXQriNfgIAKmEjGkXPFW+T
zWcPVEf7pl1H1gbAdoGfxMWTciDZ172OjAKqle6cUJdiSen2PKIsQzPiMSeAsU7R
8rEnBoGGzcWBrITZG6AV/+zyz68fWjX015ts7EGvIL8FZKHZ23hjgEH26Ev7ovBB
A030tjPgfx5v9JAE+ZGZZe/Ry6SoMVBEHryITpRRJKUnKuQoOszxgVEsZ48ejsKP
RnhEzYzypDKsy7B8l6H3agV6eVQrzHfBnwTN2htMp7NPN0Zyw/YNbPa+deiNYIVo
MzsIL06bZ1Sfk2bBO1ygdGLs5JAl/y8CZ9Gu0vB1MXZCV+5v6TNDpkPMjH+os6TL
rJD5R1Gx9VfeaBblmEy6glUa5vzwRYh0gezxEgE/n8/MM2Cmq3RIcvbFKcSv20fu
rZlwuZvP2op2Uyt4yjrh
=it0v
-----END PGP SIGNATURE-----

--wtO4+9l+3RkKLqxD--
