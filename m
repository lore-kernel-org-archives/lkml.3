Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138Ab3IBWhm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 18:37:42 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:48482 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758993Ab3IBWhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 18:37:41 -0400
Date: Mon, 2 Sep 2013 23:37:37 +0100
From: Mark Brown <broonie@kernel.org>
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: kernel-janitors@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Message-ID: <20130902223737.GA14209@sirena.org.uk>
References: <1378115661-5371-1-git-send-email-Julia.Lawall@lip6.fr>
 <1378115661-5371-2-git-send-email-Julia.Lawall@lip6.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <1378115661-5371-2-git-send-email-Julia.Lawall@lip6.fr>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] spi: delete premature free_irq
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 02, 2013 at 11:54:20AM +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Free_irq is not needed if there has been no request_irq.  Free_irq is
> removed from both the probe and remove functions.  The correct request_irq
> and free_irq appear to be in the add_host and remove_host functions in
> spi-dw.c.

Applied, thanks.

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.21 (GNU/Linux)

iQIcBAEBAgAGBQJSJRMuAAoJELSic+t+oim9GxsP/A1zIlV32D5Zc0jVpwki24G4
JXTJV7fNMkJUj+SgMBuiRZmgK4KU1MrnwfR82/PmCir6gEJKZmb9z4EffPmt7rUF
V9jr4wIBeC17/tQIS19hzlm4GlGAqtN95mdWxsiYlHLAAtl1oS/51EZdvuazNTG0
MyTHq4RwlCvHdCz3tvDRLwaXBHtwaVIQKO/pv1tjOCVthNfFhzxO+b0P7rIgb5nQ
oz4TrGOFupCF8TSwx8Z0G3406H3qSIVIMsaOPn985qHxzTgIKbArCvdFEzBwLGTc
RMCTIBbQNkL3AcIEJ50myp92YFFlHH0ahw7XHUlV0uYAmqKllmaIM+6fxfX/xVsX
DV3NP7FYcpBh5v2SgtnaZuLjyBJlU3jHP27UhcGd2ZGETThZ1xLAm4wa/pMxCZDn
/vli/wEwKFpiK/ruKTQSNf6tkEC3pFesKOlxy0VNjNgZWpWGF3bKEt2tWQkltmld
wBzwWI8PPjpwSDbw2qD63Erl/CDfH+a9epRMS06dX1rG5IbXpubCYi3P9tCGwtsX
HvvwFyJZY07Vu7Y5zyUKyWDTBOpp8+V//tvV0xtyJ1J16v2Vn9GZXduSTusRglKj
a+4ijpnb1IXiLhDQCN0W9l4SY511QtlJEw+Fw4WHCjp0FggGwgybohm6/H1iEzmB
dOTKr94YhHkPJVUDndmx
=ETsu
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
