Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757270AbaGVWWG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 18:22:06 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50188 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757014AbaGVWWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:22:05 -0400
Date: Tue, 22 Jul 2014 23:21:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
Cc: perex@perex.cz, tiwai@suse.de, lgirdwood@gmail.com, Li.Xiubo@freescale.com,
        lars@metafoo.de, patches@opensource.wolfsonmicro.com,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20140722222145.GX17528@sirena.org.uk>
References: <20140722105022.GB19663@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cLlE6j+44ygFdGhU"
Content-Disposition: inline
In-Reply-To: <20140722105022.GB19663@opensource.wolfsonmicro.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/3] ASoC: wm5110: Set symmetric samplebits on AIFs
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cLlE6j+44ygFdGhU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 22, 2014 at 11:50:22AM +0100, Richard Fitzgerald wrote:
> Different playback and capture bits-per-sample
> are not supported on the AIFs

Applied all, thanks.

--cLlE6j+44ygFdGhU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTzuP2AAoJELSic+t+oim9KykP/ibYuP5YiijWULlM1ij5RTzv
XgdH8jkfYXdAOp43rxwiQYYYMYzAl2ve2ZVFBLUEJmSv/qpkVs/jCuezsJg1RXB4
Qsklwg3CI3x+zVzH02S3TYCVtuT4tYFxyw2iboHXLDqpS/bhOn7IwOqR8sRfn+Cr
6uFRNg9148Ie6BWPeCipJMHwhuQivDIM+JPW3QAYyR+YKfP/v/UJ+Nr2mx1wo/uu
g47iVcEsmldKaLhbRLbFKNxXnTKmQo/1v8o0G8YOQBAybSBZSk7FD0+K8+6nnKVX
6b9nKlFe07lE6wxdqYyzV8aEKYNetOK1N7D2n8DpE2sa0QX0xDjK+vq6FN8TN1V6
+A+SmFcnjlLXdlJ9WsOsk5WVx1g3bofJXd6J8mTDl2vkgEoOrbWSE76911CSHNEl
LoM59deRtuQzJ9k2LYJ9cgw1orPvnBphI6lHTI35KGUJ/a8rrHyJZvdcYpENXKYE
mkDA3krTHkdaqE6AwNTIPB8dwINTlR+F6Z4emMLtehVEl3eJ42/cmXDXCxLG90V0
JZnlHYCKEW4oYyXhkR9YAhs6CxdW+nyb4hkFmYCWFXPNlpfQhwosrM9vqeSEg7JU
IqPhiVlK3J0LTtVEelsur10E9FNPDt0BcQOWDbeYDfwF+Ijk1rDAgSNlaGwLtQcs
4W8GSQnmgtVrDhgS+hTz
=MXRW
-----END PGP SIGNATURE-----

--cLlE6j+44ygFdGhU--
