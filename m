Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255AbaIXRH7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 13:07:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:63683 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994AbaIXRH6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 13:07:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,590,1406617200"; 
   d="asc'?scan'208";a="607951880"
Date: Wed, 24 Sep 2014 22:09:31 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, subhransu.s.prusty@intel.com,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH 21/27] spi: omap2-mcspi: use
 pm_runtime_last_busy_and_autosuspend helper
Message-ID: <20140924163931.GU24663@intel.com>
References: <1411575342-31048-1-git-send-email-vinod.koul@intel.com>
 <1411575342-31048-22-git-send-email-vinod.koul@intel.com>
 <20140924165855.GK16977@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6Vw0j8UKbyX0bfpA"
Content-Disposition: inline
In-Reply-To: <20140924165855.GK16977@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6Vw0j8UKbyX0bfpA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 24, 2014 at 05:58:55PM +0100, Mark Brown wrote:
> On Wed, Sep 24, 2014 at 09:45:11PM +0530, Vinod Koul wrote:
> > Use the new pm_runtime_last_busy_and_autosuspend helper instead of open
> > coding the same code
>=20
> You haven't CCed me on anything earlier in the series so I've no idea
> what's going on here but it looks like there is probably some
> dependency?
And thats very surprsing :(

I used the Wolfram's cocci_cc script to auto cc and add everyone to cover
letter . Looks like it missed some. Sorry about that I should have been more
careful

FWIW here is cover letter https://lkml.org/lkml/2014/9/24/862

Thanks
--=20
~Vinod

--6Vw0j8UKbyX0bfpA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJUIvPDAAoJEHwUBw8lI4NH2A0QAKfmNRQwNx8qA6ctkD+H+sWB
9X9AksVTsVje/1PB8qhkdCp2JM/wd97CBJdlJLbRzck4rw5aXGKtdtmalQB3F8/6
mD1OvqVJxF4WP35xQdGvNJAT7ZmnOMWsvMc6HF0T4+rgd45gSWRdKVZl+T2cs7hj
UkLCK+RxdJbR5ZW84/3doHI1a4NMHmSBB/aRbMyYDBgTsybkhgA14uEIQOMrVxp7
dEiQmSN6T/uiYAxII5DyzOpp8iuMmPFl8U5twmQ3lnPVK/CfR9m2LIu2vRhtIpbR
g+MlvKzLwbnsUuZbOEWQ11bj+y14krO5TxAIRPYZWFasbKHiAy0xCiSmHt4imv/v
FOYi4xb/GtMRYCU6vYWmMo8UzHoexrlJO83TL4KaMfwfByoP2Z+p7tzSYp2bpaZV
gQrATpL0cMn79QaXSc3qc7xaUzQCjK6jz9P7M0RwldbjSg1fW1OkiGmKbViG2P9V
bEkJJS2foN+Kx+IPiAwmthnKFX97uANxB065ZBqXV+JzRaCfbcCijFs+iwVvIzmW
Y/EUTvOU5sbnw9BBVPv/2tkeDDoeU3CN0ODIarbTblBVq7knTefoaVYS6qGB3Hv7
F7uAypLKWV6UW7vpS7jXweBio6s/Xw0nlHq8BTkItKvPsSidjDhCA1ns8T0WtMLH
F9xM3OXDD+F0JhMeCRrG
=XSZK
-----END PGP SIGNATURE-----

--6Vw0j8UKbyX0bfpA--
