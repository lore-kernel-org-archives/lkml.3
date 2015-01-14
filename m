Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754245AbbANRWc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 12:22:32 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57175 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109AbbANRWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 12:22:30 -0500
Date: Wed, 14 Jan 2015 17:22:06 +0000
From: Mark Brown <broonie@kernel.org>
To: Ken Wilson <ken.wilson@opengear.com>
Cc: thomas.petazzoni@free-electrons.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        ezequiel.garcia@free-electrons.com, gerg@uclinux.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org
Message-ID: <20150114172206.GA4160@sirena.org.uk>
References: <1421032440-15335-1-git-send-email-ken.wilson@opengear.com>
 <1421032440-15335-2-git-send-email-ken.wilson@opengear.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="8p/3hdGJBHAENZPK"
Content-Disposition: inline
In-Reply-To: <1421032440-15335-2-git-send-email-ken.wilson@opengear.com>
X-Cookie: Keep out of reach of children.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 1/2] spi: orion: Change spi-orion to use transfer_one()
 semantics for SPI transfers
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8p/3hdGJBHAENZPK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 12, 2015 at 01:13:59PM +1000, Ken Wilson wrote:
> This commit changes spi-orion to provide setup, set_cs, and transfer_one
> functions instead of transfer_one_message. This allows chip select support
> for both native and GPIO chip selects to be added.

Applied, thanks.

--8p/3hdGJBHAENZPK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUtqW+AAoJECTWi3JdVIfQyKcH/1rOfEb5pMLI95Y+6L6Tb+x/
qneOjSR10GZMk9ScRs9TMrnCESTVqiv1SU5nTbQsB56zvvLBoZ5X2WnXx2kEMC4O
hHdAjjz46e4WBrmRTgt52Zbn/sbucKDtLAbiY2FSkLFEIclkVhlkuQgAmBkPi9jZ
xk699s91Qp0FwefqN9pSLNJMLIuILUMynzf9VC+5XKbXaGErFOhlgjiZ34YCD8Du
CU9GOwf91TR6XuML4eNGs5QKdKFmmEyJ5l9PH9lk4Cbg026hMpkbp8KQVx2jakTR
4U45Qd6n5oHqq3jT5znuXYklm8xLXBuJlctOZAWJUoKVEWw5HtxZB/kLQT7nj7w=
=7J8p
-----END PGP SIGNATURE-----

--8p/3hdGJBHAENZPK--
