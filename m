Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754908AbaFPO5I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 10:57:08 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:44032 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbaFPO5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 10:57:06 -0400
Date: Mon, 16 Jun 2014 15:56:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20140616145652.GG5099@sirena.org.uk>
References: <1401929039.16832.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h89hLpb1RLJts0lt"
Content-Disposition: inline
In-Reply-To: <1401929039.16832.1.camel@phoenix>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: ltc3589: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h89hLpb1RLJts0lt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 05, 2014 at 08:43:59AM +0800, Axel Lin wrote:
> of_find_node_by_name() walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name() instead.

Applied, thanks.

--h89hLpb1RLJts0lt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTnwWxAAoJELSic+t+oim9bG8P/REFYxcbaozVIxg3tWPgwnCz
ii4FdCjh2NClw/T9bouCgN1VwNEPjVHA+JavpzuoTAvP0l7//JJlht4xokYcuAXH
BPEX7C0anSfq7/jIiRz5NdQiYXcE/U24TLTpDKpgy4KECURjru37GGR/Almw3asX
doUxxclqdXsBCNK87U6WecNq6wre6t6Oe89GBbUUAVuonEaMjbcoHFGpSm2dFro0
ER4z4j6DL3iE1cc5/iTSf6QOFrD96uIkSmzpuwMlBpXd/7HqHAczkkO0LdXprgMt
npJU7j+bk58BpJOrpUCXjf/yNR85q2GNupNJVer/EGSv8jhFtOrSGeYpt/OrUzI3
iscLF3yF+1Ym5wyKRnn0kPJNHtbgHN3l5MCyCOeGPAmu3w5uQjuRv0nCZ5rV1Pyn
xbHPbwx6yateQGuLEVGrSCkUWmNr39Gf7v+HSIId9xF2YZL35mibZ25i3XUFWqtN
oZBRE9ifcl3mTbmF5cIz0te1oawlrfL6vM7br8mcb+DP7E6TWswRWdkKtH6S/vfA
q9VbovYeflFXOdqNQ5H9rVa7eNrSmOToQzE/yqypLwIpkd52SRfehfId6s8V7m4n
57cB5Hd0Ae9CqmBPR8j1c1ckubt+N+MHWMh4cLouKUIR1swzABJHT2I0twZ97toQ
3tQXarguT+xCP2yUA6PA
=YB/Q
-----END PGP SIGNATURE-----

--h89hLpb1RLJts0lt--
