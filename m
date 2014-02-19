Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbaBSQav (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 11:30:51 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55385 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbaBSQau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 11:30:50 -0500
Date: Thu, 20 Feb 2014 01:30:37 +0900
From: Mark Brown <broonie@kernel.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, lgirdwood@gmail.com
Message-ID: <20140219163037.GQ2669@sirena.org.uk>
References: <1392720071-13503-1-git-send-email-sachin.kamat@linaro.org>
 <1392720071-13503-8-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WcP5Mnmq432o9tA/"
Content-Disposition: inline
In-Reply-To: <1392720071-13503-8-git-send-email-sachin.kamat@linaro.org>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 106.188.144.10
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 08/15] regulator: fan53555: Do not hardcode return values
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WcP5Mnmq432o9tA/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 18, 2014 at 04:11:04PM +0530, Sachin Kamat wrote:
> Propagate the error values returned by the function instead.

Applied, thanks.

--WcP5Mnmq432o9tA/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTBNwpAAoJELSic+t+oim9FFgP/RZYHfCyoasPfzdahv24ww7s
AL91zsoNCg6m8kxYTLtxybb/ydNRXIcSuSvDKryjv1+f9QZ7RxHt8qLZwALq7GqY
ib984lSpGJOI6QNpWqDNFmpvTkjU2ncTO1NFuit0vNkjLU1qPmxBFUeG6MUPdGUs
xxDs2czw7Wv2In4UdFsTzmq8Y/5BERZnfbMR6KSjUz9DeumSV0N3dYAcP3tZBKZt
RcpZrA0Dfp0unak6iy3c93ybvH1/Q8UOtXDZDpIHPZV675RdkHcStxKMJmKI3SHb
Zhf2v3D8FM0txafg3bCiBUGqDXZfvf6cLcS8vFO2v2srCiJ4iHhcMpjqtHY+lJUe
Fmhocb4bMJFHHJM9H3O/bpTTMVBBn0a8aHBiRePW4qINILJ7poZblKcBCpzPr72u
Sd91Mf9qvGjJP/BBa/FLqQ+vpw5K9M/R739zwMQ3jCt5n8NNW3QLr487YidAl83I
+bi8+s+VYgxhE3hD5xpTq3g2QUQSfN36U+GXA3Ti+zIyZ/mWHJFpndGPnAAR4CqM
CvgLWIHwsjeoI7zzE0v6w9o/ZAI33Yvi4Rz5vnEVZVtJvOf99N0PQrCIcpBbrvG2
0JySQxETNCeUdw5XPPjeGu0oUebtdqxbCtjnrzWGCLEASQdNAQUTmdabQ7saCjLe
eMQHW66WIFxGlhogQsY0
=k0nY
-----END PGP SIGNATURE-----

--WcP5Mnmq432o9tA/--
