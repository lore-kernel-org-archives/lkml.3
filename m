Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030331AbaGPOsp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 10:48:45 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40361 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030225AbaGPOsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 10:48:13 -0400
Date: Wed, 16 Jul 2014 15:48:03 +0100
From: Mark Brown <broonie@kernel.org>
To: pramod gurav <pramod.gurav.etc@gmail.com>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Pramod Gurav <pramod.gurav@smartplayin.com>,
        Stanimir Varbanov <svarbanov@mm-sol.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Josh Cartwright <joshc@codeaurora.org>
Message-ID: <20140716144803.GP17528@sirena.org.uk>
References: <1405510797-755-1-git-send-email-pramod.gurav.etc@gmail.com>
 <53C66AEB.7030906@mm-sol.com>
 <1405512867.75389776@apps.rackspace.com>
 <53C66F3B.9020507@mm-sol.com>
 <1405515375.452411340@apps.rackspace.com>
 <20140716135345.GA508@sirena.org.uk>
 <1405519254.31919.24.camel@iivanov-dev>
 <20140716141842.GO17528@sirena.org.uk>
 <CAMf-jSnqng1uFazZgxHKvEwaHssNwZJaJaUU7o+81uJ2oA9e5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="kunpHVz1op/+13PW"
Content-Disposition: inline
In-Reply-To: <CAMf-jSnqng1uFazZgxHKvEwaHssNwZJaJaUU7o+81uJ2oA9e5w@mail.gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regmap: Kconfig: Select SPMI when REGMAP_SPMI is selected
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--kunpHVz1op/+13PW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 16, 2014 at 08:12:04PM +0530, pramod gurav wrote:
> On Wed, Jul 16, 2014 at 7:48 PM, Mark Brown <broonie@kernel.org> wrote:

> > A dependency from a selected symbol will have no effect.

> Thanks Mark. So essentially in this case PMIC driver should 'select SPMI'.
> Right?

I would expect it to depend on SPMI and select REGMAP_SPMI, assuming
SPMI is a user-selectable Kconfig symbol.

--kunpHVz1op/+13PW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxpCgAAoJELSic+t+oim9Ts0QAJIaHdWD/Ow0D/dAtJ6k58cM
jAt5YzTAaYFiowgT10IcI+R4jLndR+IElLisd6vBkTmNfbiMi7w82k9oOM0l35SS
ucj8WaOhD1GnlSl3znOBkF7SBw2mGut/0+CWgnhhZX8z/g6b80lrwxK1em8vLdY+
J4g1JfSY/KBx6EGV4q26PhVTLdOuoV4KRs+56J36MKOQEEhVMkGJm0OkG/6auDkZ
K0ye9taFI+HnfoHs1ZeUK/BfwuhY8bhYdMBCg5WsKSDPiVKruVQAcgE2/472F878
X9zjAF2VxtKczz9v5vlCAWeWDdKBRJqwandB/j1rE4Kj/cZT6WzM+ngtLoWHGch0
PmHB2HPvb6uSh89hq3BibytN96rKec48/1WaZTOOcXciuJgGpIrqZG4snSW0yF+Y
s2TUjwRVcF1Tve1Wn/TekY1yQabUmbxaoxkvAHkK9ZRV0s3Kih8RPTmR71EzD3Ud
i/AOFht97SftHwM3wIdpv4INixiGv+Ke/KiIRNHULhRzPhu+XQac/qt04aPNnGtS
wOxxEMtc3RVPynIfyPcUQGlB3Cw97hzXh3BnIb4nepL+eBugwSFbHcdg0LCJvcli
zZ0+QOkdTvEI5l+IJMvQaDPcxRLyLwSnSHt6eiOpHysiR03HzPIa1mqOZPXtv8EZ
/Sbjpu3YOMB8bFoTyPtd
=CGBr
-----END PGP SIGNATURE-----

--kunpHVz1op/+13PW--
