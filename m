Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753681AbaF0QJg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 12:09:36 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:33098 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbaF0QJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 12:09:34 -0400
Date: Fri, 27 Jun 2014 17:09:02 +0100
From: Mark Brown <broonie@kernel.org>
To: Beniamino Galvani <b.galvani@gmail.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>, Wenyou Yang <wenyou.yang@atmel.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Heiko Stuebner <heiko@sntech.de>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Message-ID: <20140627160902.GR23300@sirena.org.uk>
References: <1403451105-31929-1-git-send-email-b.galvani@gmail.com>
 <1403451105-31929-2-git-send-email-b.galvani@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jIKIjq1mcf2dngXY"
Content-Disposition: inline
In-Reply-To: <1403451105-31929-2-git-send-email-b.galvani@gmail.com>
X-Cookie: But it does move!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/5] regulator: act8865: fix parsing of platform data
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jIKIjq1mcf2dngXY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 22, 2014 at 05:31:41PM +0200, Beniamino Galvani wrote:
> The driver loops through all available regulators (ACT8865_REG_NUM)
> and accesses pdata->regulators[i].platform_data without checking the
> actual value of num_regulators in platform data, potentially causing a
> invalid memory access.

Applied, thanks.

--jIKIjq1mcf2dngXY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTrZcbAAoJELSic+t+oim9pccP/1JEECFhxMIuuJIwGyPgTRcE
Y9AF6y90pqSTlKjvctCRag2nVzpD9l8XGqdGASsagIaZFrsFi+McxARz7iVFguvP
2v2CtnA6UOOvXJFC3xvpI0X+WCDl95wj2CfTCrX4QXF4/pxIkArEfxO05UsRW1os
ucgz1xY9G7hjA5QRYsJ/aCBM2W/ZZ87p58X+NBMZ/P3akV/JZv6WxNfDdaEmZZYm
lH7aBOCooMkU+j9p4N/tiqs59c3uwu28kz+rF/ehsxtH8bcBwQ2Qnr+JX1zLwlya
3odHFP8hSQhdFWIrfxVaSaFBgsRcRb4hQZnnNbXgf4i1dFBz2SoMoJa5TUTwugaz
4iDLzAwFnlZm72sMwYq+RXvT1JrpQu08Gh1iYB4I+UCuGYB1PscIngddGwx+d24C
2kq6qbj+5/kQKEMOLdY2o7oidQe4BdsNNifwHIIE6WLfS6bIiyr76ctatjRol2qZ
GOvDfynBPEZ81aKOi8biB3JfOnUCV7+qACTHBWEM54A3Fm4ZZsZQSNQeBFNLk6da
r5QyG6d7k3p2FGkTh2jm5kGjwTzAya9HRpq5miB3s9m6GIGxNnX1nq2mClWX2j7F
ZCjdEv2vPoN602xlahkRah7PCAxAAg5YXEze7vKXuUjfmjXtwdSZLAa0wUPzrCZX
XYaNAUgIjYVkboSn4K6j
=0ZDs
-----END PGP SIGNATURE-----

--jIKIjq1mcf2dngXY--
