Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757697Ab3FTKfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:35:47 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:41077 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753845Ab3FTKfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:35:45 -0400
Date: Thu, 20 Jun 2013 11:35:32 +0100
From: Mark Brown <broonie@kernel.org>
To: Phil Carmody <phil.carmody@partner.samsung.com>
Cc: "'Tomasz Figa'" <tomasz.figa@gmail.com>, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, alsa-devel@alsa-project.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Vinod Koul'" <vinod.koul@intel.com>, "'Dan Williams'" <djbw@fb.co>
Message-ID: <20130620103532.GA27646@sirena.org.uk>
References: <1371416058-22047-1-git-send-email-tomasz.figa@gmail.com>
 <20130619174047.GB1403@sirena.org.uk>
 <3697657.tZFV7pR81Q@flatron>
 <20130619192211.GH1403@sirena.org.uk>
 <001201ce6d98$03d9b920$0b8d2b60$%carmody@partner.samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <001201ce6d98$03d9b920$0b8d2b60$%carmody@partner.samsung.com>
X-Cookie: You will contract a rare disease.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RFC PATCH 00/11] ARM: s3c64xx: Let amba-pl08x driver handle DMA
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 20, 2013 at 12:24:47PM +0300, Phil Carmody wrote:

> Can you just make that minimal change, and diff the objdump of the two .o=
's?
> It would be worth a bug-report against the toolchain if different code was
> being generated. If objdump spews huge numbers of diffs (due to one addre=
ss
> changing and pushing everything else out of kilter), then feel free to
> forward both .o's or both objdumps to me, and I can run a script over the=
m,
> which knows to ignore unimportant address changes.=20

See Arnd's followup - this looks like a collision with the get_signal
macro in signal.h.

--7JfCtLOvnd9MIVvH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwtrxAAoJELSic+t+oim9ytUP/iaXkxamNtAxJCrJS8P3m93W
ZUPZaMCU41/G63MIK93SQY6CoyWa/9vouACdzxZXv0SG+IWAmiLM1+NP/B5S2HAq
uY+SEoRhrB3tlAJqNs7HXZTQCLVe0eaSkAFPLtsvR19BxrGYv0gQZ4vvpYJlspMR
KngeUEN73bjJXdyRVW7D2fGt3r4pSmyps15EU4wOTMfgzSxJXs1BWchzq09eEBbs
J6rsDZU6Sh/7iinWV6/7j3ip1jDWSblb7DDH1kHim/0+J2qoSIwOUCWnzDpV3xpp
RCxFZAImyqVfvY2kKTt5b2HusLDVN+ySN1HN6gMsd/uQ2FaYZtKiDFa0Ms2NBC4o
BAKGrztdoXu72+3bQSwAvcBxbXUHHKnwXltoBFqfEgdGubkA8CI234/JFYKUkvzp
e3WkQBFQ4v4Wafcerh1YXpdusB5x0mCySriVndpmypnO16VO7J4XIzeD9b5VC9DP
V9QdH8yuKDuTIVVXQ5HsX1UGBVWqIiwyKhhsIO4eArLTiFO9NktP6Vejcaq0H2av
Y4VbW8Lv0qMsYmDOKvZsMBqNMt8z0+oOB4cXopkAzHGi2Ks7Hori7QJ2cbt/AeoO
XLsIUnMVGvWf+pCsqOUnCORLEDmecqkMxMovFao++yYhBMA1arxi396qwD6m+REn
JMlx0IVUWCLiwvKbuG+S
=2NXl
-----END PGP SIGNATURE-----

--7JfCtLOvnd9MIVvH--
