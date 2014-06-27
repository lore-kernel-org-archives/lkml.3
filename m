Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753757AbaF0Lvz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 07:51:55 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:32890 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728AbaF0Lvx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 07:51:53 -0400
Date: Fri, 27 Jun 2014 12:51:42 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140627115142.GL23300@sirena.org.uk>
References: <1402884745.16047.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pW9qtIr+3H2OZPIR"
Content-Disposition: inline
In-Reply-To: <1402884745.16047.2.camel@phoenix>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: max8952: Convert to devm_gpio_request_one()
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pW9qtIr+3H2OZPIR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 16, 2014 at 10:12:25AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied, thanks.

--pW9qtIr+3H2OZPIR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrVrLAAoJELSic+t+oim963YP/35JnBqdJb16ou/RT9uFj5sV
bo6vqWQzZ88cwKuoVVQP/2CK/GTDz/kkMTUDvrfT+Gcq5NXXGwU2QAAG5Ct/A1S7
uo8LxqzPaEon+dM8rVirSAP2sj2AC6tNTaH7J2/Os3WDgsLsQuTf0d+wsN/NxuGa
XH2SlLYKeIOfNCPsVr+QutEncD/HS1usQHzej/qc98bjBlTKdQUEKmlpqz1VMAMJ
RhhXFMMxjhlWUCqvXYI+9OOdsL//LDsZEJA2QMN5pZurcLTDHTujMGSrnJAB/kbY
Z7nXQTew4aT23h6aIhxQyupJjGLugXC65IkxBE5xZl6hdBIecuYZsbsp5cYlLwcL
zH+WRToo25IoAibVk4cKHQPODp7Pb4M1SBrIu4xSBm0P0f2YWMPOpLBudLEGJ50N
Lk7cRrGYjGaUX94sgAlB02OF5+acxkJEOHZrcyk6JqwvwUJhAI4uQSGLoO/D8K7G
PJJn7JgntYqfmPdqB1B0pzxmDOdxI4fEDW76PpLiF4eYewP0XJx+Vz+2lwDUoBOP
qAscHpFUIbgXkOYeIA1/sIxl0W5yWfq0r74R4FiIdW+nWGAn0J7J06R0KuOT1PmX
Dr0IvQ+uSsuktudz4XScKoViX7Jf5Sj6vil43+hzLojexLCV1PnmzYb1dR04ZG4k
xlPg5JZKz++CdkGtyMgc
=jbeC
-----END PGP SIGNATURE-----

--pW9qtIr+3H2OZPIR--
