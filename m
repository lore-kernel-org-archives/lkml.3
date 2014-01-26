Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaAZOjg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 09:39:36 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59638 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaAZOjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 09:39:35 -0500
Date: Sun, 26 Jan 2014 14:39:21 +0000
From: Mark Brown <broonie@kernel.org>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: linux-kernel@lists.codethink.co.uk, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20140126143921.GG11727@sirena.org.uk>
References: <1390742939-10695-1-git-send-email-ben.dooks@codethink.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nE/5a/j5SCML90Nq"
Content-Disposition: inline
In-Reply-To: <1390742939-10695-1-git-send-email-ben.dooks@codethink.co.uk>
X-Cookie: Please ignore previous fortune.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: gpio-regulator: warn if unknown regulator type
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nE/5a/j5SCML90Nq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 26, 2014 at 01:28:59PM +0000, Ben Dooks wrote:
> The of_get_gpio_regulator_config() will error out if there is no
> "regulator_type" field in the fdt node hoewver it makes no attempt
> at warning if the contents of said node is not known.

Please sumbit patches against current code, this won't apply since this
code has been restructured since the version you're working with and now
has an improved version of this warning.

--nE/5a/j5SCML90Nq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS5R4WAAoJELSic+t+oim98nUQAJtWDQ+Aq95nDvzr44fwtD64
ILag0V66xZ7oG0Grek09pbSPMjxAn2WTokeCIKMfCQpr6wwl6vgUrpuvnrl0XefL
m2+4bqQQWYH6ka4P7k9gejCMAzVtv1PtJFOzjeOQC11vostE1UnfnyB3NxtPedbz
i+PTUIgBwQxFikovbyTjyVNnUuyOn5fIUIXOhIPHpEb90KEeJ1fWDEC811Kxhlq5
vUo6gU14xu5lWCWuJXBPzwgOaF1mYeRr3PC4dRY31vVpTuBoPgL9BUDmIPuBZTKe
hIHWtID70/mCmKTPAIa36qwZQy4OyPhSFtrxxasBpZYolw14p9N10C36fILvdmS/
zM2d7bgsfMXo3zUkzXmnXW1acECYU1amJp+zStTVLvZT0fPzqkv0F3r8hRLZ1Act
n6cIlRH2630X/DSjFEmLVv2w/6xjY4e/k7dktmDC+xFSC6OzpWRgRJYt8qlChFVL
Sp4o7DcBFI56PgK/WyTM8t8/LkWpmA5tvh5+KygDfy56s2Elv//FCNs/iDPNLNg7
e758mm8i9qm3IdKEop0wSbEmElZK2WheYFSFbkjlf56HSMtiSsEvmKakvMBq3Kvz
VhwjK0h/BWVEFPR7vGRHNz7Hf25o4neaYMDJRfRsSOy+sYdbTTp59Bsx+UG9/gri
HDhsi/QfxdzzCj2XwziD
=+3iy
-----END PGP SIGNATURE-----

--nE/5a/j5SCML90Nq--
