Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaDRR2P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 13:28:15 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38117 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982AbaDRR1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 13:27:31 -0400
Date: Fri, 18 Apr 2014 18:27:03 +0100
From: Mark Brown <broonie@kernel.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sachin Kamat <sachin.kamat@linaro.org>, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>
Message-ID: <20140418172703.GQ12304@sirena.org.uk>
References: <1397462949-22379-1-git-send-email-k.kozlowski@samsung.com>
 <1397462949-22379-5-git-send-email-k.kozlowski@samsung.com>
 <20140414211106.GC12304@sirena.org.uk>
 <CAK9yfHwL4o7-7Q03dw9JdD1UDsP_v2=we1kadRXaGAuaN1de_g@mail.gmail.com>
 <1397549539.29169.2.camel@AMDC1943>
 <CAK9yfHwUwjMEXisi5Jf+nAkS7CLnAUt-REkekns9JrRTAGQ=WQ@mail.gmail.com>
 <1397552145.29169.17.camel@AMDC1943>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/bsb8NL1xGjb+j1a"
Content-Disposition: inline
In-Reply-To: <1397552145.29169.17.camel@AMDC1943>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 4/4] regulator: s5m8767: Use same binding for external
 control as in s2mps11
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/bsb8NL1xGjb+j1a
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 15, 2014 at 10:55:45AM +0200, Krzysztof Kozlowski wrote:

> Anyway more drivers seem to use this kind of binding (tps65090, max8952,
> da9055, arizona) so maybe there is a point in making this generic?

Yes.

--/bsb8NL1xGjb+j1a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTUWBkAAoJELSic+t+oim9978QAIMvncocAH9uIIwBswslfwBi
EiM6DaMbq515j5Jd/SUjlagyxRGRDTm9T2Z2pl1dgboPe7hLzWqh/3f20ZTkqlWh
l4rQBG6N4LHG/Ua4cRi0n4km2McFwy69jxnCH9aJfVwF9CGdVm9IxxkjsAh0N9TU
zxsQGIoK5Y08bvnvCuzqEEQEOgMFd5EUi7jH+xyUIQS5x6/kzTqhn6MEh3bc5IOU
Gle2OYMrWFBb0xEr0d+8U29WoMpjBvFWrId00n8eoQxaKcXPnR2SC//5MzjVfne7
SIu1VO6CrHg2HMQgxd2aBYr0259+tL5fP1BBTDGS7GASl1ph77kDmBJ1bv3ixzN8
08itHPhzCh0YamMbN4/2DWgaKdO43G2SN1z1kJp4VZOyRgi9UKNoagPFoVP3ObT2
8QN+5edDvp0qkAS3mYcNY0YQFtegWrDFbPntutExvSaj/5B4tNbkRrFc4sVV5ZRw
XsodmYJKp/b5lyE8cN4kojxTOBZoa9VJD2eivSRzzd8gO/bcQE6BiWAByt6ysEiJ
fy0btf+MfhSn7kjUt8nt1iu2fuXy+a/NP+kDiZFyGaUbk2M3TLtXisBPI+nbXAls
hkHZofN+N8CEUsrJ51PoiMfTXpD2Z4sCVcwm5VhfSRo7k5nCXtbouiD/QfmEMju+
0+65QGUVo8vFLuUpLUqu
=WgYA
-----END PGP SIGNATURE-----

--/bsb8NL1xGjb+j1a--
