Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305AbaCSKj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:39:26 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:46997 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758917AbaCSKjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:39:25 -0400
Date: Wed, 19 Mar 2014 10:39:19 +0000
From: Mark Brown <broonie@kernel.org>
To: Dylan Reid <dgreid@chromium.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20140319103918.GY11706@sirena.org.uk>
References: <1395175509-19113-1-git-send-email-dgreid@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AP/GsP9hRuG68Z8E"
Content-Disposition: inline
In-Reply-To: <1395175509-19113-1-git-send-email-dgreid@chromium.org>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regmap: cache: Step by stride in default sync.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AP/GsP9hRuG68Z8E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 18, 2014 at 01:45:08PM -0700, Dylan Reid wrote:
> The default sync operation was still assuming a stride of one, fix it
> to respect the reg_stride set in the map.

Applied, thanks.

--AP/GsP9hRuG68Z8E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKXPTAAoJELSic+t+oim98IAP/2mz82NN4eu4e55X1G/E+v+b
bzhTp0lIV5MDy0JRuIYQLjKBz37AXRWnKyn1MCxZdwoy8ENmW3zcUYACsO2og3hi
BENxAAPb/JE2rawzYwc9xet1+THLfIaljVtB/CyVGzvQ/4CQqZi6YF4IEvsHJYST
6RLICWjGFX5+Zotk6kKawL+xVcrCE/sPqKiBg2KnqA+VizNqh40f8egKM2qKfFNd
RnzlWJhVlEYTVrs8yVVpEpfxLHfdMy4fi1Qy3pjFQHEhtDGQTQ7BN76jCqd6+47A
enNKKRp6GOx92NVY/pVeVnYk5ZREUpMRm5O9bqu//JqC9KFuufGRdrqZR82mq/pt
h5DQ9fkyDbIDCY20yEhsMjdPwzYZXcypDaoBSAy+YV+SOZoXNrDfG2gBH4byMSbk
+QwopNeGNUq1mTRMmnsDw4S9AYH2009MVTgFYYvLEvVnRPUxv8FZrawu3Df/Rl86
NruWTZkJFT8+kqbW7QuTyUam+A5JFjK8oUnI8O9ibJCyyqvATrgLvcNchrqniCbD
p9J2dlyj26mVzdb1Immy2TzrrDj1VaRS6rOfYsi3W+AqHKN1VZT44fa5jL6kRtqJ
9M31ZD2XYBPKzE8sznKOUMv43Cg/deaqi+ygj//M+yFa7BquVSnQIkex3B90LuKk
r0+iaVK2FrYtUpSVGujL
=9aUb
-----END PGP SIGNATURE-----

--AP/GsP9hRuG68Z8E--
