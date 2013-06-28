Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab3F1Nub (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:50:31 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33998 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab3F1Nu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:50:29 -0400
Date: Fri, 28 Jun 2013 14:50:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Yi Zhang <yizhang@marvell.com>, Chao Xie <chao.xie@marvell.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Message-ID: <20130628135022.GJ27646@sirena.org.uk>
References: <1372426354.28529.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8YgzrocnpTEFR+6n"
Content-Disposition: inline
In-Reply-To: <1372426354.28529.1.camel@phoenix>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulator: 88pm800: Add missing config.of_node
 setting for regulator register
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8YgzrocnpTEFR+6n
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 28, 2013 at 09:32:34PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
> ---
> Hi,
> Seems current code also needs this patch:
> 	mfd: 88pm800: add regulator sub device [1]

Oh dear.  I've just reverted the patch (my build testing hadn't caught
up yet).  Chao, please resubmit for v3.12 - when you submit patches you
need to either ensure it applies and builds on the relevant branch or
mention the dependencies so that the build doesn't break.  In this case
sending the regulator driver and matching MFD changes as a single patch
series would have been the normal thing.

Please incorporate Axel's feedback into any resubmission.

--8YgzrocnpTEFR+6n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRzZSbAAoJELSic+t+oim9glcQAJarQQhSsdgu/X+4ixWTuGwC
hNdbBSZsZLFLZN3U5scHtQSRkF3eI9A/udR/t6WeL+ieI9uDI/4NlckCioE7+XVh
NwdUwhhNdvGyoZCluMhGiqfcSWa5u7KDPx2ir4iyt3cqJNl4dzVQnASbPs+1CmZO
S6OXpCQUn0BaiEtUbr86HdqShrZa8FKBBQa4aT1SZMd6B5uw77OqwUvA+SUPvQhy
VEa/2sSzANNJphUAeLgtIrVcW/iVebQ1+AHQGfcvJk32aNjJocmvp9duDIfBlc8g
vlzen29PMaRi34hpkxqq39W4pYr4Mf9FDA/fd7rwUnIllrlbAHOlla/u0mBAiO9k
KfMWJEviIHE7tuVvwqge2lquUzFXmqDF4R+DozXgR/eR7HkooNa+0BYlqDZH+kUp
3boauIUTAesybsODAQDb7VyGR6J/86NzZj14Z7vS0W4GvzzUkDKFRMMRRO9L0ax6
eDxaDKvOY04pDRR6wPQRObuLRFydrbNsHW2zr9tD9HRtCwQofqGlYRxud57cr+WL
QDwkPWGRMuhMxXjVUs4f3m0UD2dNMvZC+oqis+W1j+1MPyHD0cgAmw79k38WOW/q
e+MtPzTDRlGgzg0i+BBs9Exa32earQUI63DgQ0IzBvsl6oscA6X6qQv1LdNM2ThA
3NElN0aaZtdR77eLiY7q
=3ZJA
-----END PGP SIGNATURE-----

--8YgzrocnpTEFR+6n--
