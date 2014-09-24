Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555AbaIXIfr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 04:35:47 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:36571 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575AbaIXIfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 04:35:42 -0400
Date: Wed, 24 Sep 2014 09:35:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Bjorn Andersson <bjorn.andersson@sonymobile.com>
Cc: Rob Herring <robh+dt@kernel.org>, Lee Jones <lee.jones@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Andy Gross <agross@codeaurora.org>,
        Mark Rutland <mark.rutland@arm.com>, Kevin Hilman <khilman@linaro.org>,
        Kumar Gala <galak@codeaurora.org>,
        Josh Cartwright <joshc@codeaurora.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Message-ID: <20140924083518.GB4015@sirena.org.uk>
References: <1411428329-23172-1-git-send-email-bjorn.andersson@sonymobile.com>
 <1411428329-23172-4-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jn9UjnPB79FDtyKu"
Content-Disposition: inline
In-Reply-To: <1411428329-23172-4-git-send-email-bjorn.andersson@sonymobile.com>
X-Cookie: See label for sequence.
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


--jn9UjnPB79FDtyKu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 22, 2014 at 04:25:29PM -0700, Bjorn Andersson wrote:
> Driver for regulators exposed by the Resource Power Manager (RPM) found
> in Qualcomm 8660, 8960 and 8064 based devices.

Applied, thanks.

--jn9UjnPB79FDtyKu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUIoJFAAoJECTWi3JdVIfQhDAH/jXShZUDhiLUAcKYd0rNeozS
7ZMmtMESndvdDiIUMwP3InunByEW9YHQXG0e2Sh/ZEd9chs1ImLIkz8jAwc5IITn
phga8e9Zw5v8UtBaurGcyxZt/Y9IEZqopHJBAYyumDLmkVG49+qTEilburonvSH6
ym4rb9VrWVEXtEG/oQjW0TLdVizUz3+8IHMWPW0hZQDdiEWMX0pq2EKy3nmMeS+5
SJ8PWFnRS59KWF6LKfVoJmkw2c31B6ev6yVUM4Nn1YEafwG5s5Cn2Fhi+2llbiGn
1CVNnabmib2l24U5THEEet79lrIlcgHV/v64+EmWZud+Lz/lejGfOs5rSLb8Sl8=
=LFw3
-----END PGP SIGNATURE-----

--jn9UjnPB79FDtyKu--
