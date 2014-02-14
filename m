Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753389AbaBOKJg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 05:09:36 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:60598 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760AbaBOKJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 05:09:33 -0500
Date: Fri, 14 Feb 2014 21:11:05 +0000
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140214211105.GC4451@sirena.org.uk>
References: <1392378602-32302-1-git-send-email-sachin.kamat@linaro.org>
 <1392378602-32302-5-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CFO0SFgG+t1lcV5s"
Content-Disposition: inline
In-Reply-To: <1392378602-32302-5-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Your lucky color has faded.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 175.45.49.105
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 05/16] regulator: max8925: Use of_get_child_by_name
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CFO0SFgG+t1lcV5s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 14, 2014 at 05:19:51PM +0530, Sachin Kamat wrote:
> of_find_node_by_name walks the allnodes list, and can thus walk
> outside of the parent node. Use of_get_child_by_name instead.

Applied, thanks.

--CFO0SFgG+t1lcV5s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS/oZmAAoJELSic+t+oim9mv8P/09aNYOWBXryPAkaO82lkqNy
jMH5QPIvq2TcL3ct87abeqh+hvY0YjoSju8FTYbE16uLSjMCwWFgbqVsBdJWbCry
GfiOr+lxrnRcbJnxduD+hcboA24xZUAE9UP6662TzOblweEiqfvj7eB+um6DMtUB
RhuH2DOUtII0uc+Mf/vWBX+JBgL9sbG4zoopcVsedM/D7FYSr9zcYCMm2BjFDgHT
IHEXiknQXvmM5g9AxjrhIdMQfrxxcT93o2o+usKJwRQ9fVRlirCglvmYeqdbVLln
jr8S0cNh6M8zh8NGO0+g/spJTbswn3ryYjzcqIShxNVqjTO60q8yk3KziedJYzJ+
3LB8Zcafk3YAPfBzoRCbfj2bSiRIVf4YZVObOwLvnUuW7Lto7U88gQ4OtTlnyIT6
vBKimDiSMTwAF2Dlbv2/f0Vs7OJxFmsF0aEpWtMOtwqh3QBqeMmLPIuofQNT7G4x
YGgcb0LDFgUn2Hy/0ytybBhWNQyrtudBPWmGcKarZYEXdkuICt0VBn8rqCMJbHu1
3VAlHJvYDAdOG7IbEk88ZZQ6oBZuFCe60MprCaLgdz+KBisoz6PqOVbRgkwsyiwk
smifOEJQe235viq7+gUtxtPoCfOoh4o698MSfAKxRkoHvVgzYRT/Z01OFuwc4G75
dvctDz6mdugSOooCgDU9
=55M+
-----END PGP SIGNATURE-----

--CFO0SFgG+t1lcV5s--
