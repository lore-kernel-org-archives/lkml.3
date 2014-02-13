Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752006AbaBMVKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:10:05 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:43406 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751516AbaBMVKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:10:03 -0500
Date: Thu, 13 Feb 2014 21:09:56 +0000
From: Mark Brown <broonie@kernel.org>
To: Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140213210956.GE28112@sirena.org.uk>
References: <9348920.79Ktlcbcai@phil>
 <20140213190322.GA28112@sirena.org.uk>
 <1528469.iBzMKAUgWB@phil>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="klLku2wdS+WFztDq"
Content-Disposition: inline
In-Reply-To: <1528469.iBzMKAUgWB@phil>
X-Cookie: Oh no, not again.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: gpio-regulator: fix forgotten gpios-states
 reading
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--klLku2wdS+WFztDq
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 13, 2014 at 08:17:54PM +0100, Heiko St=FCbner wrote:

> So I would argue for removing this commit again in favor of my v2 sent 16=
:34.

Yes, that's fine - it hasn't arrived here yet though and I wanted to get
a proper fix in.

--klLku2wdS+WFztDq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/TShAAoJELSic+t+oim9r+UP/iDA1OyaALQfIqsbaq6ah1uf
4FXWYlZR9pA8ax2tn1P9hqdy8Cx/mcwCB/LtOX8v4y/MG7HHGaBNPLPFqWJG58JS
oBRxecBq1i81EY6VifMJ4aigoQI+Fmq5fYMRoce2zETE+pvgXFffJMyG0vOvu6kw
/BREneDq+vrsEU9JrKgp9Rj2NTxlksdB0g76XWq9fJwc4yZBH19wa+dx4x16l21r
Ji3VleaSEFWNZbTJJlcH59OBJEjEB4D+sN12VAkiEWaDd09n9RMN0PcDld3mmnsd
jpHaKl8/Q6yAzzAUO0tZO8pbivtartRhn1OBGb+JVAU7OLss28uvB1O09TWkUWUx
rirwnMyDyeJ8O/Hlj+GNDCeHx0MZn52A3fR2/MaslllCGNbrz/K08TFTnxuQJqYK
xTYtPjD3NNFN7dxmMCI1KPpmvuCNvfCOUvZYUedvcaIjiy+xisGuz2VR+Ympn6vR
8MZgPiGYu7YNnSBi9VmcJGteV2jLGKMeQHdmFAPqWIxhrcqszyBUZJnB22s75aaN
1OFLkoBrjT1TO8MgRmySfG9+2nj60cAzC0Mf99WeohpCMHNVwvF2khPewbOdryQ8
Eo4NMI7TqcBaIwcp9BkhinkK5N5bOaj/sOlc15w7eV2c7o3qD0OqEtpbNCd6VQeY
i+2oNXRNtJ/C6M5jYpeS
=/dZk
-----END PGP SIGNATURE-----

--klLku2wdS+WFztDq--
