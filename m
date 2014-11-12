Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaKLWLC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 17:11:02 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35533 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753534AbaKLWK7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 17:10:59 -0500
Date: Wed, 12 Nov 2014 22:09:35 +0000
From: Mark Brown <broonie@kernel.org>
To: Andrew Bresticker <abrestic@chromium.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        James Hartley <James.Hartley@imgtec.com>,
        Ezequiel Garcia <Ezequiel.Garcia@imgtec.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org
Message-ID: <20141112220935.GS3815@sirena.org.uk>
References: <1415828274-24727-1-git-send-email-abrestic@chromium.org>
 <1415828274-24727-2-git-send-email-abrestic@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pJCrgSoq0Ldj8RFP"
Content-Disposition: inline
In-Reply-To: <1415828274-24727-2-git-send-email-abrestic@chromium.org>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] of: Add binding document for IMG SPFI controller
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pJCrgSoq0Ldj8RFP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 12, 2014 at 01:37:53PM -0800, Andrew Bresticker wrote:
> The Synchronous Peripheral Flash Interface (SPFI) controller found
> on IMG SoCs supports single, dual, and (optionally) quad mode SPI
> transfers.

This is OK but please use subject lines matching the style for the
subsystem; people often filter on subject line when describing what to
read.  I do note that the binding lists the DMA as mandatory but the
implementation tolerates it being missing, this is fine since the code
is more liberal.

--pJCrgSoq0Ldj8RFP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUY9qeAAoJECTWi3JdVIfQud8H/3pe3bHtN5f7+tljerf9qKWv
6hgAKEORrHS9mMieTqb0bAKsv7WSAP7P1sZt8+eRVNHBiPAQ5KWB4BNk6JGpGTEd
zChO11UDiLT0bwhLmWn5flvtvfqypHKjsGrBER2EopuWZkYAglapjohwEf8rRdh7
J8d77YzYXuq6PGwXxG53Fn49T3I6iDi6sFchTjloHnr0ztJr3T0lTHE4fh9TKQIP
cPkB/5r1xAbSkyTLUlJwOoKiyYQ63fe/+QNIX6I9jUGMySupeoIJLGvCA90MRl2e
FmEEx56hVIszyHlzXxq/o2gZrCP+FiL47m6HZMRmXCs3mvST6p7TILTuw9kML3Q=
=YnDi
-----END PGP SIGNATURE-----

--pJCrgSoq0Ldj8RFP--
