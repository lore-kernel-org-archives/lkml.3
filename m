Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbaL2RKR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:10:17 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:54535 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020AbaL2RKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:10:15 -0500
Date: Mon, 29 Dec 2014 17:10:04 +0000
From: Mark Brown <broonie@kernel.org>
To: Aniroop Mathur <aniroop.mathur@gmail.com>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org, a.mathur@samsung.com
Message-ID: <20141229171004.GC17800@sirena.org.uk>
References: <1419872808-11958-1-git-send-email-aniroop.mathur@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lEkl9o9W2JhK2ndV"
Content-Disposition: inline
In-Reply-To: <1419872808-11958-1-git-send-email-aniroop.mathur@gmail.com>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 86.128.155.20
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: core: Fix format specifier warning
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lEkl9o9W2JhK2ndV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Dec 29, 2014 at 10:36:48PM +0530, Aniroop Mathur wrote:
> Signed-off-by: Aniroop Mathur <a.mathur@samsung.com>

Applied, thanks.  Please check what you're generating your patches
against - they aren't applying cleanly, you should be using current
development code.

--lEkl9o9W2JhK2ndV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUoYrrAAoJECTWi3JdVIfQG+cH/iT4p8+c05LgpkGZC8Vbx6VH
g0vlDK+3OvFJsCmjUJ1ymyYr2z//G3mhxqQKfUy3TBWwL4JFKswM89f2NTTWIF/l
9fIIhvD6BZ07aZSr3rIXe9GY4UV9iCxAPTh4iP+YCXHPfFyfVA1f7pbknHYNFA6o
l5uHsz1MyHpI5Ub2g1rhfnbCXSMARmUTVfmNX56/Non/60sCdVH5B0gfOimqSfcY
651tgO6kFKNNbIODqm6kurdiM/BVZ5TjW07bpQGes0DjCJOFFtOU5zsdbVwZqhyY
gMR7W50mm8Znz2a6zF8V0seLxF9IrF8/VxzXLNglQqlrNuEEnI7sgaJWmbpuNE4=
=bGTm
-----END PGP SIGNATURE-----

--lEkl9o9W2JhK2ndV--
