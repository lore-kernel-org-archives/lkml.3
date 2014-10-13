Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbaJMNRs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 09:17:48 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:50733 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108AbaJMNRp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 09:17:45 -0400
Date: Mon, 13 Oct 2014 15:17:13 +0200
From: Mark Brown <broonie@kernel.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: devicetree@vger.kernel.org, lgirdwood@gmail.com,
        linux-kernel@vger.kernel.org, heiko@sntech.de, sameo@linux.intel.com,
        lee.jones@linaro.org, grant.likely@linaro.org, robh@kernel.org,
        sre@kernel.org, dbaryshkov@gmail.com, dwmw2@infradead.org,
        anton@enomsg.org, ldewangan@nvidia.com, linux-omap@vger.kernel.org,
        linux-tegra@vger.kernel.org
Message-ID: <20141013131713.GB27755@sirena.org.uk>
References: <1412711104-15902-1-git-send-email-romain.perier@gmail.com>
 <1412711104-15902-4-git-send-email-romain.perier@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+LX889AjxRcAdkww"
Content-Disposition: inline
In-Reply-To: <1412711104-15902-4-git-send-email-romain.perier@gmail.com>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 62.156.150.204
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH v1 4/4] dt-bindings: Document the property
 poweroff-source for act8865 regulator
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+LX889AjxRcAdkww
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 07, 2014 at 07:45:04PM +0000, Romain Perier wrote:
> Signed-off-by: Romain Perier <romain.perier@gmail.com>
> ---
>  Documentation/devicetree/bindings/regulator/act8865-regulator.txt | 4 ++++
>  1 file changed, 4 insertions(+)

Should this documentation be put in some central place (and perhaps
referenced from this binding) given that we're trying to make it a
standard property?  Not sure where it'd fit though...

--+LX889AjxRcAdkww
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUO9DYAAoJECTWi3JdVIfQmWcH/0ht7Wxleu3wCCkeEb0AypXh
/Ke4/qQb3L65oz9BoplJJbfuDpaTaOWz1HEHlRNbL2W/IK1wgpgIHP2gBywg21YA
K4MaAgERBb0sg4hbvDwfivUqZFwCw2YNfrZ/95n7U3SKz38mlX2JotTfXuOJHRBr
+TatlOhDi+YN+55jQD0vzbBXDTtj0M8ssLH6WHpaGna/Syv/oaCLwymrRS936rOl
CdcOegKMc3/qkLmA/S8LaD2hbfY61+0prxFTQxJn7qoW1QUGqTrTW/QqhIvXSgiK
Kv1Hvb8bgB2k5XU5dlNlzDaEoEfZjQxHB8TIKdwdrx6J/Sw96PPaoROe6cCzAMw=
=wwlN
-----END PGP SIGNATURE-----

--+LX889AjxRcAdkww--
