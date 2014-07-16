Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbaGPWa2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:30:28 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40890 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179AbaGPWaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:30:25 -0400
Date: Wed, 16 Jul 2014 23:30:10 +0100
From: Mark Brown <broonie@kernel.org>
To: Bjorn Andersson <bjorn@kryo.se>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>
Message-ID: <20140716223010.GP17528@sirena.org.uk>
References: <1405465241-28684-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1405465241-28684-4-git-send-email-bjorn.andersson@sonymobile.com>
 <20140716000848.GG17528@sirena.org.uk>
 <CAJAp7OjzWw6uBVsMXEvx0Lc1v_UJ+hGa2UeaQCtdfzsm+nAMDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Tw5XVHq4jmAOFG53"
Content-Disposition: inline
In-Reply-To: <CAJAp7OjzWw6uBVsMXEvx0Lc1v_UJ+hGa2UeaQCtdfzsm+nAMDQ@mail.gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v4 3/3] regulator: qcom-rpm: Regulator driver for the
 Qualcomm RPM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Tw5XVHq4jmAOFG53
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 16, 2014 at 03:15:16PM -0700, Bjorn Andersson wrote:
> On Tue, Jul 15, 2014 at 5:08 PM, Mark Brown <broonie@kernel.org> wrote:

> > I have patch 3/3 here but no cover or other patches - what is the story
> > there?

> I forgot to add you as explicit recipient of the other mails in the
> series, sorry about that. Please let me know if you would like to have
> them resent.

I mostly want to know about the dependencies - I guess the first couple
of patches define the QCOM_RPM interface, is that stable enough to go
ahead with the regulator driver for example?

--Tw5XVHq4jmAOFG53
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxvzvAAoJELSic+t+oim9w8cP+wbLEMizjpQALZs1ONu99Wew
gqYNe4ncbnSctYTpYXxG10GVgA0Zbmh+OBAm8uEg+vJqaQdOakLiBPWaQMq9PNB5
N30cssHbJddNilT0ocvtm6gzcrRfDb4b0zeeBvXku1cWkIR6dqLrtmXhzsi3yi+G
f459om1L1t3DexA6NpKB5qU4NZguaRijzoChzDbLuMk0MyrH4Dz8dJevmSyNhsqr
6g8jusmPyoa9U03g2gUKYjkGpJdPJn5Zox0/sN3u1wS8XcwgFWq+doRMdxNPidCZ
WcvI9doZg0ahorM38Hka0ySg6Ppvsyghcnmm9BgweCpwrCMJ5FbrsfyanfYXGt7x
AX/v2GCJKi5P072CYFkzFMR6vqYrgXtgLlqz6bXY3zSuoSFqRKSVtI6gLSNsfDHI
XDQcOKDEXTWIIvVnGnahz+NC8b2Ru/sFzRrcfLgq0yTt3HvJ5JM6t5Ge8f2DtY53
xRYaBu0U3tokIsC+sj0YJOIFF2eTdd5/ihcasYmLiZ+49Wyke1662o3f+SzhbqhR
2GAlWEkqvUyeuxCemnCoF+z13K54BMVNvcWrlmjQuSSO0pIB3saC2VNVBD7abI1n
uiqwEOij919lpcXPSSA7eNq8HEZl70EoEisheSGlLVNUJE7ZYDf3q6FuDExNhizQ
A4HN10+kzpPhAdY7Qr1R
=EPSR
-----END PGP SIGNATURE-----

--Tw5XVHq4jmAOFG53--
