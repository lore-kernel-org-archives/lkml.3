Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058AbaDBTnA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 15:43:00 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50456 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932571AbaDBTm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 15:42:58 -0400
Date: Wed, 2 Apr 2014 20:42:47 +0100
From: Mark Brown <broonie@kernel.org>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20140402194247.GJ14763@sirena.org.uk>
References: <1396433349-31470-1-git-send-email-Li.Xiubo@freescale.com>
 <1396433349-31470-2-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AXxEqdD4tcVTjWte"
Content-Disposition: inline
In-Reply-To: <1396433349-31470-2-git-send-email-Li.Xiubo@freescale.com>
X-Cookie: To make an enemy, do someone a favor.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2 1/3] regmap: implement LE formatting/parsing for
 16/32-bit values.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AXxEqdD4tcVTjWte
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 02, 2014 at 06:09:07PM +0800, Xiubo Li wrote:
> Allow busses to request little endianness formatting and
> parsing for 16- and 32-bit values. This will be useful to
> support regmap-mmio.

Applied, thanks.

--AXxEqdD4tcVTjWte
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTPGg0AAoJELSic+t+oim9SVgP/1nQeGJX/O+gkZ3kPaC9lTUB
KRdXCgtnnej+NNGufImwR04ODG8YRpohLmhep8xmV79S3NSsSFbTOW6TSnOuDzPt
QV9LNr/NVjJCQwN8/VNiYEeTAYxVmtH2a2KJlZg5A+ppdJiefvekK8aENZtULlwn
4KZbuSqEpr63CzFCKezV/yKzw4Aib/JuW98uAX6kn7vsYFBZIdY7CWkYeA4uld6O
g9foezINaH+0xY29QvkeH+1GNGKXqwO9pfbVbWUwO++SE2RgYrkqbDrTCvcpeuvK
kPdAa/KqwOi+uoI+abs1jMT1IpvvS3oMeefOeX1/4yAZdvZ99t+DUfnIxj5PYYVO
/PLG6+IXWwpZ3gS7FQLs8tRACyVesfh0qy+34Td9IeWM/E2b452DsYQduqeCF9l2
TfYmJIyPaJZjxHCm+nC76K5kcobedQW97gVSOa0GFkf4Ozioiae+gtz5VIhnWlo6
2YDDC98/+Xu+HhmZ4BcwR6N4oAUOV7yHKvb6kC1lu03gpJgdqhrx3IfBsaDLOgUn
at5Kw5TEFh5WKvuglNloaDEI0j76Od3VuromrHIMZnf29TKiqXT6UEjLJp6FGrXM
+nhU4YZ5RwoGuEH7g929udmJfz16RZm1K6eOGBBhddLQVFTqMrnGOhurlKqXa7ar
EwwZTj//4v+2vDH92+F+
=L2RS
-----END PGP SIGNATURE-----

--AXxEqdD4tcVTjWte--
