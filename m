Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbaHSOtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 10:49:14 -0400
Received: from sauhun.de ([89.238.76.85]:38232 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752847AbaHSOtJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 10:49:09 -0400
Date: Tue, 19 Aug 2014 09:49:04 -0500
From: Wolfram Sang <wsa@the-dreams.de>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Jean Delvare <jdelvare@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: i801: Add PCI ID for Intel Braswell
Message-ID: <20140819144904.GB15371@katana>
References: <1408459048-7470-1-git-send-email-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wq9mPyueHGvFACwf"
Content-Disposition: inline
In-Reply-To: <1408459048-7470-1-git-send-email-mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wq9mPyueHGvFACwf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 19, 2014 at 05:37:28PM +0300, Mika Westerberg wrote:
> From: Alan Cox <alan@linux.intel.com>
>=20
> The SMBus host controller is the same as used in Baytrail so add the new
> PCI ID to the driver's list of supported IDs.
>=20
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> ---
>  drivers/i2c/busses/i2c-i801.c | 2 ++
>  1 file changed, 2 insertions(+)
>=20
> diff --git a/drivers/i2c/busses/i2c-i801.c b/drivers/i2c/busses/i2c-i801.c
> index 2994690b26e9..10467a327749 100644

Applied to for-current, thanks!


--wq9mPyueHGvFACwf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT82PgAAoJEBQN5MwUoCm2bT0P+weM3WlceNvWj88EZcerCbVs
hy4WBKc3LWDYrfhYzsJJbV/nTbJ5E3COhfgAicYX6L0Hxvfc5x2rbqfT9KUDyRD3
UMLQQIm4dtgiSa+l+HXBRpOj6zzBEoCmm9ifO55OdnhEwGgMIkfQ7J+lEFCFxBD+
z3/as9agUCMvuN8zX0MK4cdaE5GDabAkwyA8vThI01RlLd23Y9nbgsEnkg3GpMOK
lVHzEDuJYshpCxQps4AbbhoIgwK3szj303s03LXGzSApN3USiuNbMzD21YPce6KB
blSTjYFZL288jTNrYQcD2csGprYipPgCN2n6hGdUEUqpytilVjmmIgBEPzGHiq0r
uHPP9z86v+sOfdk/NrLAbSYEUZ9sNsPJn96ALzXmXjtXS09erRoKDJKxLfO1+XoN
Nrq0Qj368CC8JA4fJygo1IvwIZ7joOA3uFy4vxzspZWBuIVtJJQL4jUOcFRnHytN
7aihG3iLQxZiKTeb3NGnx1qyyAkoD97SyowBk5+GIjFzdn/7j3pUuEp38L98SD41
BAcZSwm5LAVcl5SBKYsYRh3vOwAA4sd8ZlE20sJeKRAja8zZHpAuLVguTSez3cIt
frg3HsU0OqrBY0VZQD5F5B9hABV9GFEu2/ijBQn9W741rBjTXxyJhyt/kAgLSkyV
AiZLwob2UJ0X6y6mxlSK
=osk3
-----END PGP SIGNATURE-----

--wq9mPyueHGvFACwf--
