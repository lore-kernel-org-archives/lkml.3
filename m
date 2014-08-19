Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753778AbaHSRW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:22:59 -0400
Received: from mga14.intel.com ([192.55.52.115]:16508 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753711AbaHSRWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:22:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="374356768"
Date: Tue, 19 Aug 2014 22:37:27 +0530
From: Vinod Koul <vinod.koul@intel.com>
To: Michal Simek <michal.simek@xilinx.com>
Cc: linux-kernel@vger.kernel.org, monstr@monstr.eu,
        Dan Williams <dan.j.williams@intel.com>,
        Levente Kurusa <levex@linux.com>,
        Srikanth Thokala <sthokal@xilinx.com>,
        Jassi Brar <jassisinghbrar@gmail.com>, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] dma: xilinx: Remove .owner field for driver
Message-ID: <20140819170727.GU13288@intel.com>
References: <f82330042cf6185a1f4e18232ebf6999662ae48f.1407931050.git.michal.simek@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="orO6xySwJI16pVnm"
Content-Disposition: inline
In-Reply-To: <f82330042cf6185a1f4e18232ebf6999662ae48f.1407931050.git.michal.simek@xilinx.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--orO6xySwJI16pVnm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 13, 2014 at 01:57:42PM +0200, Michal Simek wrote:
> There is no need to init .owner field.
>=20
> Based on the patch from Peter Griffin <peter.griffin@linaro.org>
> "mmc: remove .owner field for drivers using module_platform_driver"
>=20
> This patch removes the superflous .owner field for drivers which
> use the module_platform_driver API, as this is overriden in
> platform_driver_register anyway."

Applied, thanks

--=20
~Vinod


--orO6xySwJI16pVnm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJT84RPAAoJEHwUBw8lI4NHaYAQAMc0T/QxFHL4Py5CPNGFztQF
vT3EO1V+QwnbpK+IxsOkN5D57La8pUwvGpVO4/sMZinwAqfTT3MFfMoyRPCimFWx
bb5ssPQdt05lebbZTDwaEC0SDT8F2Zv+tmEuoW/L2cDoCpblGUiD0btQZiaWGsPd
0x4Jj48JgH/HkmJwCfJXcIXCNiZEHo5Abi9BeXR3Tv49WeZ43l/Ln+eCECJ4Tfs6
qAJUrWo4GNsjNtXwh0iyeMhIHTwmfyR9ADtbcV3b7xk9Red9ncXFWXkZAsoU66z+
iuLzIOM3WZQIzNHm8v3L9VIIE3lAsK4MQk7cGNLnX7mhnk+uACBc0zZ2ZJydKqed
Rmfy/I7RLmqjHJC3+/Iv5Y0z7sOmkKjgt29bMpbl88rmc68NgRo6rQJbqHmxRfSN
Op04PvjP5JBBHmxKpTlFt8VNlBlyCBeVviO8STFVB7XBntXXhC+I9zcjXTI8VVul
yjvtE8vEWLS47knGItAp+uL+KlSZENb6YlJMsl8WEK8ZAK6PqgOrQbM338k6o0Qk
/xaaVsoVsPNo9g2q9i7BnxQ7Jb/SaqbEl9mfk4dPKtZlm0FtpyJcrR8EDCR1Rk2L
KXB1sg607O1hAaXmpmvKiWgVCJtClMZY9TWo0OBWW7A5jxm6LC8kVeO9eGo+Fpoa
AEwe5oz6H/Uo70kU+rdu
=CWyb
-----END PGP SIGNATURE-----

--orO6xySwJI16pVnm--
