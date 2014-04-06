Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754437AbaDFPvT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 11:51:19 -0400
Received: from sauhun.de ([89.238.76.85]:57097 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753444AbaDFPvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 11:51:15 -0400
Date: Sun, 6 Apr 2014 17:51:06 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Mike Looijmans <mike.looijmans@topic.nl>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Harini Katakam <harinik@xilinx.com>, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, linux-i2c@vger.kernel.org,
        Gerhard Sittig <gsi@denx.de>
Subject: Re: [PATCH v5 2/3] i2c: Add driver for Cadence I2C controller
Message-ID: <20140406155106.GD2609@katana>
References: <1396646876-27336-1-git-send-email-soren.brinkmann@xilinx.com>
 <1396646876-27336-2-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="P+33d92oIH25kiaB"
Content-Disposition: inline
In-Reply-To: <1396646876-27336-2-git-send-email-soren.brinkmann@xilinx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--P+33d92oIH25kiaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 04, 2014 at 02:27:55PM -0700, Soren Brinkmann wrote:
> Add a driver for the Cadence I2C controller. This controller is for
> example found in Xilinx Zynq.
>=20
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Tested-by: Michal Simek <michal.simek@xilinx.com>
> Reviewed-by: Harini Katakam <harinik@xilinx.com>

Applied to for-next, thanks!


--P+33d92oIH25kiaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTQXfqAAoJEBQN5MwUoCm20jMP/0GpIKkIGjN9cQON/V5RLiMz
Qb5YwLo61jN0I4X4shJdNgkMmNIJH9emE3UsLp2k0r688mcnwFRHpGMrII9YeLOb
cPARhwlQP70Lr6LZmE3okdQZ0VAyZZaQIrxzyXXiAF58kK9awr7QSgGll0/N1hy0
XelfJxORIe7ZLnEVmiKCGWspwBfez3SJKwIZLQmwNaLmsBRoCFoN1Kyi+eI2Z6E2
d1CNnSVOR3KCn3Xt9LKcewxcTK48cgn2Gn2iPj7iGwu0D84Iv5kQUVaIzN6y5ho3
P5JVIm3Bm9VyM/UyGqj+ZHLDQfgZP7AhRXaZ3Lsihinr/kFqiWCpWLi/w7FQkwKL
UExxIM2mfWgD3NrV55fLx+hJ6/oHDSzBBnWNFRqq0HVnZ+lBhmzpKwX+RTBbQA7Z
GC9KFA07qN8rqmZT2EaqUVnIYM3FjZcrTu56yhe6N72sCl+SBp7d5sk+AjejHtUF
PgqMooEdyQHLGkDvDt0xHmF0KVeMsqmslYNqhqHgOF+W/mhZIxZS+W4rrEZiuDd7
uBa6SQAD5nhrXGWBZ+X7JXnbQWRST3Khqzc9x+VmzTUZRliah7yTwNzvY47/Q1D+
uI/vhb3PdhwStw+GHemYsQjJeqRkMXIQEXL3hnXumFR1MfxanmvyMqpKJcjG4pFp
4gru24eb/2mpx3IqZ1yu
=Ryve
-----END PGP SIGNATURE-----

--P+33d92oIH25kiaB--
