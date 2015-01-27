Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758944AbbA0Rel (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 12:34:41 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36523 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757815AbbA0Rej (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 12:34:39 -0500
Date: Tue, 27 Jan 2015 17:34:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Bo Shen <voice.shen@atmel.com>
Cc: nicolas.ferre@atmel.com, Songjun.Wu@atmel.com, peda@lysator.liu.se,
        alsa-devel@alsa-project.org, linux-sound@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-ID: <20150127173419.GB21293@sirena.org.uk>
References: <1421739797-25988-1-git-send-email-voice.shen@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="ORQ7wZOtrZMMlBRp"
Content-Disposition: inline
In-Reply-To: <1421739797-25988-1-git-send-email-voice.shen@atmel.com>
X-Cookie: My LESLIE GORE record is BROKEN ...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 1/2] ASoC: atmel_ssc_dai: fix start event for I2S mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ORQ7wZOtrZMMlBRp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jan 20, 2015 at 03:43:16PM +0800, Bo Shen wrote:
> According to the I2S specification information as following:
>   - WS = 0, channel 1 (left)
>   - WS = 1, channel 2 (right)
> So, the start event should be TF/RF falling edge.

applied, thanks.

--ORQ7wZOtrZMMlBRp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUx8waAAoJECTWi3JdVIfQkR4H/A9P2fsnUCnAEbiDDJk1U/N/
kPzDiSJ5qfXs9iy5Mm4UzkZ7wuzQiNQ3ei6BSpyRjfq8H3uWcnteYoT2C69WsT86
vZWp5mhS0eNgRn+kPE2MvSOJWB2yRZLce0Zpde/89iSKPVIZClkz/om0Qi9fOHsp
OClR2u32J9urS991BZofVaNpEQKxs4M7jccWZnNii3GQWkLaMUszagLsP9KC71ZM
e9KzOU55/h7OE7YOiGkNKL2uvIvyP91Ge8BQFAOJswuGvDrTbT4OfWJmoAPzR4h3
DwYuytWl3j2/Kd7QYqT6BM1sNoxv+gBNFM61oQM4nYDdChaanW6g41nIqwkoJt0=
=iV6x
-----END PGP SIGNATURE-----

--ORQ7wZOtrZMMlBRp--
