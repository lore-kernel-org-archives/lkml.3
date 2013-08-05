Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab3HEIfU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 04:35:20 -0400
Received: from sauhun.de ([89.238.76.85]:57689 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755065Ab3HEIfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 04:35:18 -0400
Date: Mon, 5 Aug 2013 10:35:13 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Michael Brunner <mibru@gmx.de>
Cc: linux-kernel@vger.kernel.org,
        Kevin Strasser <kevin.strasser@linux.intel.com>,
        Kevin Strasser <strassek@engr.orst.edu>,
        Darren Hart <dvhart@linux.intel.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Michael Brunner <Michael.Brunner@kontron.com>,
        Chris Healy <chealy@imsco-us.com>,
        Dirk Hohndel <Dirk.Hohndel@intel.com>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: Fix Kontron PLD prescaler calculation
Message-ID: <20130805083513.GB2980@katana>
References: <20130726140455.40b4b86b@hyperion>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
In-Reply-To: <20130726140455.40b4b86b@hyperion>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 26, 2013 at 02:04:55PM +0200, Michael Brunner wrote:
> Add some necessary braces that have been removed during driver cleanup.
> This fixes the I2C prescaler calculation.
>=20
> Signed-off-by: Michael Brunner <michael.brunner@kontron.com>

Applied to for-current, thanks!


--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR/2PAAAoJEBQN5MwUoCm20ckQAKykhf0wV5v27MVU2fwvyK2a
tKA+Rea/h5R0t5uFJhPd2K7q/z7M8c1XVkM7i1ekiViQaaqVuWXOuHkp2I3ebcID
ptMWC/PcNAq4YZAgvyccGq1L2r4M2g1BVjaKSNu574lXd2JlvqrGE4tY2qj+qgfk
giKA+dAlx+uj1PG7OxhS4ZbTUH0w9r/qemwYCUjr9mfU7NMamvoKMADx+2Ahik1b
8pUO1CRggGx3VTq/9jJpCKPYoYrq4G+7CuFH5bDwDtSdXw8tej0kkMJhRnt6xPRb
PU+mL+j9mJiy7a5hID5+/fwktNZiGxymcwfRT9k5fovUSoHb//IhzlFOv33vcaxj
56PI2PPqZlCoKQTj4xxv5PXyJIgd4jBd0ZHkvlicqBIkPxsnj8tRnkbGsgX/P5Fz
WJxDRCMk04U4VAIhR8A3dAV2L5TG0QAgYftc5HaFpL2oksVSps8QZel8xSKV1f5h
+7mW29HtbPvZ7BJhUESsnssJhV8FpNNahuRL0H/ut+hMOTHX3g9urPHXUQF2hdg1
pVSzV9IUy7XCGnZjSwmNsU1in1lhFAuWV3fDYuyYefhIe1Dy7U8s6eilrm8P/DRL
V5InXmfW3XpznTJzOA/I9nNIT6+W2wI3jwh0CHuaXYBE/N2jtXiwslgTP+VVHRHs
/zT/hdF+AzCUQiKYEjL5
=dfMW
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
