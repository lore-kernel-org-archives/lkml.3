Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753420AbaF0MbS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:31:18 -0400
Received: from sauhun.de ([89.238.76.85]:52061 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750858AbaF0MbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:31:16 -0400
Date: Fri, 27 Jun 2014 14:31:09 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Doug Anderson <dianders@chromium.org>
Cc: Lee Jones <lee.jones@linaro.org>,
        Andrew Bresticker <abrestic@chromium.org>, swarren@wwwdotorg.org,
        olof@lixom.net, Sonny Rao <sonnyrao@chromium.org>,
        linux-samsung-soc@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Bill Richardson <wfrichar@chromium.org>, sjg@chromium.org,
        broonie@kernel.org, dmitry.torokhov@gmail.com, sameo@linux.intel.com,
        geert@linux-m68k.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH v2 07/10] mfd: cros_ec: cleanup: Remove EC wrapper
 functions
Message-ID: <20140627123109.GA29156@katana>
References: <1403115247-8853-1-git-send-email-dianders@chromium.org>
 <1403115247-8853-8-git-send-email-dianders@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <1403115247-8853-8-git-send-email-dianders@chromium.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2014 at 11:14:04AM -0700, Doug Anderson wrote:
> From: Bill Richardson <wfrichar@chromium.org>
>=20
> Remove the three wrapper functions that talk to the EC without passing all
> the desired arguments and just use the underlying communication function
> that passes everything in a struct intead.
>=20
> This is internal code refactoring only. Nothing should change.
>=20
> Signed-off-by: Bill Richardson <wfrichar@chromium.org>
> Signed-off-by: Doug Anderson <dianders@chromium.org>
> Acked-by: Lee Jones <lee.jones@linaro.org>
> Reviewed-by: Simon Glass <sjg@chromium.org>

For the I2C part:

Acked-by: Wolfram Sang <wsa@the-dreams.de>


--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTrWQMAAoJEBQN5MwUoCm22xAP/0CrHAEE9+JkDSmZAsY3SNtg
yJLcUySCx0tG+3OwPHCpuhWjQxUgBmfQjI1Z+jcANR6It1xQMbym9KntbjpkDFkn
UIJzO6qANakBKotnfx+baBuIDg5XgTrikaGVkwaUBH8RhzEV+RSFGNar2L/OMS12
L/jRrJv+mB2cRsECxuxm4BQnrUckFza0pSmxVxXoTQh+/6Ip4YobmUnrmfGNxr3Q
uMC6YM2Cqm+rTLaaB3IDHL7xY6B6TEk19baYk8Yj4ayVOrSgTlSdOvmyldCMUbtV
lI29oJaIkg8/keiWJWX5273iRZHDiCodHyYnw5FZ94JR/DUPrFe7WQGZbfzlBrkF
+c5u41mgT8s9FB7gLwdiyHryq2LkHyloHjAF/vNCKRAPuJDdrpAoTo+jmOSuC84i
vHeaeF9nk5kg47K3AihzYc3TY4ivGOMRSzFEcrFSm+li2oZkTHYYvDxwm+nmxdCd
60pLuMXh2tte5ZMpbrZHXJHeHvePemilPK1w6qdxNyyEcIDyz0/4vxERTyxtgvCa
54CXbRnIIOGdgc2H8T6phFbYg4FhtiLaff/JC0fpFPumcrDv96UN+fVWppdJ8oZf
uN881vD3wdtLD993pn8Z5EYklLxsjPhmmcZcYOz2d3D1y0O130Fh/6wsCeVFnVos
LpdIvoj6xSOdD0pM7pae
=qTdx
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
