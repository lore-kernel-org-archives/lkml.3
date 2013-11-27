Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab3K0PQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 10:16:48 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:36573 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3K0PQo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 10:16:44 -0500
Date: Wed, 27 Nov 2013 15:16:39 +0000
From: Mark Brown <broonie@kernel.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Message-ID: <20131127151639.GX14725@sirena.org.uk>
References: <1385556677-5244-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <20131127132442.GJ3296@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WiuFC6bSmcjanUfV"
Content-Disposition: inline
In-Reply-To: <20131127132442.GJ3296@lee--X1>
X-Cookie: Your supervisor is thinking about you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] mfd: wm5110: Give new AIF2 registers defaults and mark
 as readable
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WiuFC6bSmcjanUfV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 27, 2013 at 01:24:42PM +0000, Lee Jones wrote:

> I'm not keen on this patch going through ASoC, as it might make things
> equally as awkward later in the cycle. We should have created an
> immutable branch for that really. I guess this will have to wait for
> the next cycle now...

That seems excessive and it probably ought to go in as a bug fix
afterwards.  Given that it's just an addition of data to the table I'd
expect we could cope, we've routinely done that with similar updates in
the past without incident.

--WiuFC6bSmcjanUfV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSlgzUAAoJELSic+t+oim91+wP/i8uqsS+CBIKvtktagT4SkNp
sRGYHQoqfzFBA0WQjWASSvTKcr/y48zwmhX34pacpuqHiaxaMB5hEFuAnyBh6gZN
2y4ZOwtgJlvQ06tbF1YAcpUa2yfZmoJzZjjfATrrq0KjLx+wI4AUIme/AF8J+ncA
rmJnHuTvCv3IOW6NKihrI2bGBPmwl3xGzO0pV0tMVysC4dKg+WK2AUm97Bov3knu
y5AqXmMiZMgTMFYdnDpp5rPJLpsikISce8GrTZdSG1mG6pXPHbsJzd8P2M+ao/D1
J2cbo/d6JLmtUwYMTyTZ6ddsJq6GUPWdJceGgXlWq3dwnW6CyzGPahEThvfsttGL
fsi+Yqu0+bLyl86MalEC/lyQDFhAdBKh4D+5S7AxbnOY76f0Sep+wFwV55NGGSyf
LMFLIb9US04zphyj7R3zAu/yykhRDGtfnYitb0qlpb6p9rNqcpP0eGs0hO0n88vg
pFfQ9msBeayflxdKNRCwKxNtS99/gs4TQ98qhiB7WMixl9HSAFvuyHciNdNo4sUR
uvkIyyUIg2hYMWF6bnG8lBdfTG0i40cqou5pKiukVvLPMtyephFwznPtjH1pxCZp
2BXjY4tKKaQOYU7AFlroU/Hxi03nLjQ1iA1fEhXTFgWcNJpBMg/gRLnQwWmUQKI5
gfRRd3XXr7OP1/WPKGdo
=dkni
-----END PGP SIGNATURE-----

--WiuFC6bSmcjanUfV--
