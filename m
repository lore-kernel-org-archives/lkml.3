Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752590Ab3GXOrt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:47:49 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40990 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab3GXOrr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:47:47 -0400
Date: Wed, 24 Jul 2013 15:47:23 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130724144723.GK9858@sirena.org.uk>
References: <1373963679.27956.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gsknP8gbNnI51S+b"
Content-Disposition: inline
In-Reply-To: <1373963679.27956.2.camel@phoenix>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH RFT] regulator: as3711: Convert to use linear ranges
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gsknP8gbNnI51S+b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 16, 2013 at 04:34:39PM +0800, Axel Lin wrote:
> The SD, ALDO, and DLDO vlotage tables are composed of linear ranges.
> This patch converts as3711 to use newly introduced helpers for multiple
> linear ranges.

Applied, thanks.

--gsknP8gbNnI51S+b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR7+j4AAoJELSic+t+oim98+0P/2o7fd/Yn7a9a3oUksbwP0Ry
i5GQEa3zBoTglPCP3vsjGg2PhaPcsJgV9/jaZ2YiUn/B4KgNaiQPARF7NP+tPcJM
9H9J/GnQq2wv87ejbZ5Zi9DxQY52LuU3W+6CnKlxFSB1zGOJiyv9h8j1DxOYFTYQ
fW4xrQMdtGaK89Ni8c6l/aDw4daj1QItPb49joiEph1X0iXI9yc1aiG+IL1QCZ17
ooIRSbUegkpr6KwwN5ql4P4BXhacN7vP5ha/YLMwzDFF20yjdNgKOnNVzVTBCCiV
KMw+yV/8a06x8znJlcbQC+9m66L2/daAAjhz1P2atE8xJTfMR0moViq4YSsQWIJM
ZuDIaACynUVNIoJU6GsSolVMbaIdlZ0DlWtUhoPPTGE8rxzBj7tu5fijyri8XYYA
t057tU39AM/zicGBlJR9a3GVTjML4qC2c9TSiZLFKfZ/aif8qtRQS145i+TuVUBM
uTYBBRCnPbQyXCiiEScxcoAAvnCzQrSddnsu7s1mo/BjXQleCCcBnfW9b44HV/4F
Cpc3YfOW6bs7WMB0Mv5IudU8eBckkNs5TfEJMf24wXiWXoZ+ueilhjX/E0znwt1X
7bumHPpjyPYqcvaZESm9ggQmJqEwvuxFr9fueyusr0tDQ+j7JMM2QIzgg1WsxWoq
HhQcxTSF+G4HjHC8GYpJ
=BKNN
-----END PGP SIGNATURE-----

--gsknP8gbNnI51S+b--
