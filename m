Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754636AbaIXPpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:45:31 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:38239 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050AbaIXPp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:45:28 -0400
Date: Wed, 24 Sep 2014 16:45:07 +0100
From: Mark Brown <broonie@kernel.org>
To: Kumar Gala <galak@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Andy Gross <agross@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Kevin Hilman <khilman@linaro.org>,
        Josh Cartwright <joshc@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Message-ID: <20140924154507.GJ16977@sirena.org.uk>
References: <1411428329-23172-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1411428329-23172-4-git-send-email-bjorn.andersson@sonymobile.com>
 <20140924083518.GB4015@sirena.org.uk>
 <4437DA50-D8BC-4E78-821C-41440A08B9A9@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Xssso5lpTBgMxDfe"
Content-Disposition: inline
In-Reply-To: <4437DA50-D8BC-4E78-821C-41440A08B9A9@codeaurora.org>
X-Cookie: Your own mileage may vary.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v7 3/3] regulator: qcom-rpm: Regulator driver for the
 Qualcomm RPM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Xssso5lpTBgMxDfe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 24, 2014 at 08:50:38AM -0500, Kumar Gala wrote:

Fix your mailer to word wrap within paragraphs please.

> Mark, can you drop this until we see at least an RFC patch for the RPM
> support for b-family SoCs (8074, 8084, etc) chips.  The regulator
> could should either be the same or highly similar for b-family, but
> until we see the core RPM driver on the b-family SoCs we will not know
> that.

No, send incremental patches.  This is the *seventh* resend of this
code, I really don't want to have to reread it again.

--Xssso5lpTBgMxDfe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUIucCAAoJECTWi3JdVIfQ3r0H/1baQ7Em5fhCzTe+DMU3be5R
w8a/f5W5BOA9UAzQMNo7P0EiTG/m9O/LZIdL9uJyo+eR48tf+xendmtYLhXLMqH7
ESHkldfOPLVyDcuChKwfqAfMCxZ+sKHPN4ohuLGNNJID4uLPKsiXqrWihrG3jHBY
83BQmf/P4Casg5hAkbNBYmVpqfjrivcFQ74K+tWyqnJXJbTNI3aX9J+nrRpTccu3
5HOabre0RJh5NoPWDALvjppTLHCoff0TWMyr9p0LTv/AYPrv0BOX4s4pCTDE4Ghj
AJiOMus1cBU1X5mP0HtJYxX/GvFrcBKs2BtLSkfgpxZblzOJvngl6dSFk10FsIs=
=EEp/
-----END PGP SIGNATURE-----

--Xssso5lpTBgMxDfe--
