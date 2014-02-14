Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaBOKJb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:09:31 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60585 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaBOKJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:09:28 -0500
Date: Fri, 14 Feb 2014 21:21:13 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140214212113.GM4451@sirena.org.uk>
References: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
 <1392378602-32302-15-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GcuyunM1iFaMYZNm"
Content-Disposition: inline
In-Reply-To: <1392378602-32302-15-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 15/16] regulator: tps6507x: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GcuyunM1iFaMYZNm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 05:20:01PM +0530, Sachin Kamat wrote:
> of_find_node_by_name walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name instead.

Applied, thanks.

--GcuyunM1iFaMYZNm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/ojGAAoJELSic+t+oim9ErYP/jXOxf3TKAnpQkdhKNte3tiC
z6r4c4QKI1t2RJSYkzmu4A4G2wNQSfZtTdjLjDtoj53Aa6MOH+jpZbXnSrp35tN5
MeH+FAUoZi/1TONds806Wlx7lX+E5Xus6HEWB75QWFCIhiUyhoJgHhGwOA+Bxadl
lJ39Irj6ssQznJUdg3bcWjoPhCoAeP3pbJq0DrZT07tB0Fknko6slKBCeCRfYBSS
rRgVO0qDJUxiHfIqJizg/yMKZDbLmX9MdkqFAIlH5X1tUs1XGF4WylVook9idSzs
o0xbmaIvLVr16yeMyJsO/+buwm6Dhby6VeuPnIZngKMKgU7z7aCr7moJ3IYhW5CL
OGEDH7K+CBtjDZnF1PxiEigBkhheXCiO4x2XjhWS3LSeiwUlT41C3tM2y9N/JIc1
KrMpOEP8i7oH85Bnu4iupdisZYKfMaH82h+tzBVy5VLCTQQ+ys3T3LoFrN+Xj7vC
bXZi6RS/Ow2KKdIniqdjZtBBnBQfa7eObiVUvVuLcbvisNPIx8u/HZ5xRCa/4DxX
G3k45ISjMDM4x6RWoV0Un+VzV9zw43eHyIoKrc4OBXsqGqCIizuVom6SUmgTMMJl
QP9bHjpQcGSBxZxmQnL1vOUn8AdnccQ7e9hhnPipPF6wHDgzDzEhw2e24uI6Ef35
WuA4tHe+1f6tUzX+1sfb
=G3JT
-----END PGP SIGNATURE-----

--GcuyunM1iFaMYZNm--
