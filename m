Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755324AbaCRLV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 07:21:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:49671 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbaCRLV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 07:21:27 -0400
Date: Tue, 18 Mar 2014 11:21:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, rob@landley.net,
        sameo@linux.intel.com, lee.jones@linaro.org, lgirdwood@gmail.com,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Message-ID: <20140318112112.GL11706@sirena.org.uk>
References: <1395139757-6907-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <1395139757-6907-9-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+HaDSJYnsYzHewVa"
Content-Disposition: inline
In-Reply-To: <1395139757-6907-9-git-send-email-ckeepax@opensource.wolfsonmicro.com>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 8/8] regulator: arizona-ldo1: Correct default regulator
 init_data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+HaDSJYnsYzHewVa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 18, 2014 at 10:49:17AM +0000, Charles Keepax wrote:
> Both 5102 and 8997 have the regulator capable of supplying 1.8V, and the
> voltage step from the 5110 regulator is different from what is specified
> in the default description. This patch updates the default regulator
> description to match 5110 and selects the 1.8V capable description for
> 8997.

Applied, thanks.  This should probably have been two patches.

--+HaDSJYnsYzHewVa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKCwkAAoJELSic+t+oim9m5cP/2ezk1PH5TJSgyZDjO1qcR2d
dXwY5qzXl59av/3i9qkiFWKY7RmRgubxgOSiIhLvwP6ga86CwoJm6BTEGni1EBk5
cDyPiur/TIhkSkKnguht5poIj181e2pTF65R3MhbzKxoBZenWOZFk4kYqA/IHWlN
R0Nc6s1HCBFlulGha3PWPFVJXWepL1Slik6XQPVjPErPV0Hngw8XOzr4IDZOh0tV
KJEZeMMW7pTKuywFpIM6UsTmHsBj55gkvGhd9N7VXcKUR2hT79O8JS0Ml9/hvlgp
nIMo6HhkK0x9lxFvLdBAQ6C9Rq4BCzCf/Ssawu6Uf57z2w4WfW9c4kG+tVmY2Wfw
JreuO5PhAHKiCf/jqay7XJRFhIEooKB11laa67IZwRPMpqbnQQWzdhNwHe1nTckr
SwPMZb70mnnGl5cnfCAQiTGmLdoTWVPcnYBD+97iqIR4DUn+fCWGSqvhAOShtp8x
dGvPbWSfUNld4h9l22fejODA1+9aNlpQrKf57FaTSWYJ+mwQEja8Bttx9cfDOk5r
rQpuFOTlVhG9tCbWmvNKB4R+1KMcjgyw/jfLuhUxlIvPSYROxzoq+HSgNsK2tZwA
NCzZd0D/0IZMkV6u0zZaOrmizmVWgPEhRpJWMk/dokUd2F3cw/SKd4zlG3DGobeO
sGQUSGVgzLG++dGuzERo
=gZBs
-----END PGP SIGNATURE-----

--+HaDSJYnsYzHewVa--
