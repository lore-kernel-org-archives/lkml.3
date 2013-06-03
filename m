Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890Ab3FCSsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 14:48:35 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60450 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754989Ab3FCSsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 14:48:31 -0400
Date: Mon, 3 Jun 2013 19:48:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Message-ID: <20130603184807.GR31367@sirena.org.uk>
References: <1370280888-15072-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zHDeOHGDnzKksZSU"
Content-Disposition: inline
In-Reply-To: <1370280888-15072-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: assume registers are volatile iff no cache
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zHDeOHGDnzKksZSU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 03, 2013 at 11:34:48AM -0600, Stephen Warren wrote:

> If a regmap has a cache, it's likely that registers are not volatile,
> perhaps with exceptions. Otherwise, the cache would not be useful. Encode
> this assumption into regmap_volatile()'s default return value, for the
> case where a regmap doesn't specify which registers are volatile.

I already sent out a patch of my own for this.

--zHDeOHGDnzKksZSU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRrOTfAAoJELSic+t+oim9ZCwP/R97vZ424INjyjZwpQuY/7UA
2cOkPHx4oua5c042Cvf+LuqhRTss8djm9182L+eofMQz8B1mFRycTOKYkqlbjOvC
CMICK6+j6vh0Yu49qGV0MLqveNror2zyseoPBQQIVSGLIZwARnr97JRDuSPNlfsi
s+HotGak6SyaYxEl2/6rU35udrcoXQRjesYcEYOsGr1lroJH5RbzwMdrG97k+GLA
5lbvW8ADkIApMKp8mdBE5X/jqtL3TtEy7+gsqFhaQu864/3W1WCd+DZLrrGgKAbG
V/MBVHIVEIH3T/oTH1xmzzi2t/sYzzdFqGmwcIRpp0MpuesLMcn1WXmEkPIRxGa6
YtQZSl11VSM7qnAbEWNkE0Zm2BgtHdq1msmWhKNGhY7mCsJ8iXroOKiikDV9zZz9
MzL89a+KoR59Dl7kAG997hcpfDFSqdKQX+SSfI7uYQKx9KZaWHUgEj7dr8nmlQyg
BcVNKwhuSpVWlLiaCqMa40yAXNadf3G/r/DMc9l0GoMGrWOEqerV8RYu2OhlnPaI
Z6tI8tAInGWs0C0IStkG6B9YwT5ZJ8PsxbuYGTVdMJVFSENFGNDLWX5kEEBnfhHu
9CSmGVPfvc6x6JzP0R53GDImbhRnF7cxQRekJ++tF7uIQRUXLid0p3Pa7PK9W9Kf
gZpocOVgtUVcYDy8Qetj
=17vk
-----END PGP SIGNATURE-----

--zHDeOHGDnzKksZSU--
