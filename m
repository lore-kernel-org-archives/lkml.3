Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756606AbaCLHQO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 03:16:14 -0400
Received: from sauhun.de ([89.238.76.85]:60382 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756490AbaCLHQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 03:16:12 -0400
Date: Wed, 12 Mar 2014 08:16:05 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Chew Chiau Ee <chiau.ee.chew@intel.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Lim Lee Booi <lee.booi.lim@intel.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv2 RESEND] i2c: designware-pci: set ideal HCNT, LCNT and
 SDA hold time value
Message-ID: <20140312071605.GA2756@katana>
References: <1394537625-27205-1-git-send-email-chiau.ee.chew@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <1394537625-27205-1-git-send-email-chiau.ee.chew@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 11, 2014 at 07:33:45PM +0800, Chew Chiau Ee wrote:
> From: Chew, Chiau Ee <chiau.ee.chew@intel.com>
>=20
> On Intel BayTrail, there was case whereby the resulting fast mode
> bus speed becomes slower (~20% slower compared to expected speed)
> if using the HCNT/LCNT calculated in the core layer. Thus, this
> patch is added to allow pci glue layer to pass in optimal
> HCNT/LCNT/SDA hold time values to core layer since the core
> layer supports cofigurable HCNT/LCNT/SDA hold time values now.
>=20
> Signed-off-by: Chew, Chiau Ee <chiau.ee.chew@intel.com>

Applied to for-next, thanks!


--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTIAm1AAoJEBQN5MwUoCm2Z9YQAJ2OVkWwPt98Dc9jTQNn2oCq
anVEFNneh7S0pc1KPT14ur5rENyUulHOFfUMAvovj3Rtrb/m7Gm4il5Ng3gNoELv
8Y0aflcg/6f9BcHocvMnt5FV73Q4DP9fQUQ0Ob0f1huYQ9OPPk6iQLwJ0xvprbs5
hpNxi1KFBTKU4gbCd+C4MzbUzM2Y/psR5xpT89xBR8ZZdwDbBDqnEA9p/8vLN/MC
VjRmQqII8KvNdwE7IKFMsoRyfzAOKMp77V03K/I6JckOyDYCvYWAwybRMJj5wdvv
Umud/4kn38iOU4S0sobpGtUypRxixSM1rm0ccbHTBTkBu6zJ9rduBNrdxfs5clSO
XVAG89OHPlL3/rvyAMAVtFCYHfIe8qbdxKHdocaFRJZY0X+SSxpRns2nUFNQcIyc
Qn1m6LRUEsPfURyFh+eRgmaF4vowpJ+ZFEw7fXQpXalU/8ZfSr80dIbym/WPpdPH
SEwme9gBviIGs7bPaUFegSwmZUjpw6lG+lFaFnx5HWkRzdyv2HO5RZHsBqXErsZt
y3ih7Myr4Z0/vmbH/GL5KVNZlif2bV4fuaHU16shUAOyRbkKwR6W43vwIgLCLV9s
A6nHZjka1b55WN++m1EOHdeEMT8fNp2txLs7tK6Ut7PPkgS7O+EQK++0QBLpWv4j
Obs4nmKPpaDBSLF2ryp+
=wfh1
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
