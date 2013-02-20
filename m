Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935009Ab3BTL0p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 06:26:45 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53587 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934252Ab3BTL0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 06:26:43 -0500
Date: Wed, 20 Feb 2013 11:26:40 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: J Keerthy <j-keerthy@ti.com>
Cc: devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, rob@landley.net, gg@slimlogic.co.uk,
        sameo@linux.intel.com, liam.r.girdwood@intel.com
Subject: Re: [PATCH 1/4] documentation: add palmas dts definition
Message-ID: <20130220112639.GA2726@opensource.wolfsonmicro.com>
References: <1361332815-2348-1-git-send-email-j-keerthy@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Content-Disposition: inline
In-Reply-To: <1361332815-2348-1-git-send-email-j-keerthy@ti.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 20, 2013 at 09:30:15AM +0530, J Keerthy wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
>=20
> Add the DTS definition for the palmas device including the MFD children.
>=20
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> [j-keerthy@ti.com: changed the DT node property names to follow the
> convention]
> Signed-off-by: J Keerthy <j-keerthy@ti.com>
> ---
>  Documentation/devicetree/bindings/mfd/palmas.txt |   67 ++++++++++++++++=
++++++
>  1 files changed, 67 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/mfd/palmas.txt
>=20
> diff --git a/Documentation/devicetree/bindings/mfd/palmas.txt b/Documenta=
tion/devicetree/bindings/mfd/palmas.txt
> new file mode 100644
> index 0000000..5fa922e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/mfd/palmas.txt
> @@ -0,0 +1,67 @@
> +Texas Instruments Palmas family
> +
> +The Palmas familly are Integrated Power Management Chips.
> +These chips are connected to an i2c bus.

I would expect this to enumerate the regulators that the user can select
but it doesn't appear to do that.

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRJLLcAAoJELSic+t+oim9As8P/35bAdML0+0ZnfYXryHiKfxX
slMl0SUFTNh+8/j9d5GH7bHOl9USf/7gwG9wl1L4Zq6/YzguatdKrH0fvslEDAEu
T89vDE3kuWeL/e5D2u3qV332StdqZ2IhNaYCQNXWCsCcCV/N3qMOvqgElGvhFNoC
R4uYifcwQ7gx+gNsXD9rdHdmmgQcaP0CCEIqRAjpp06pTaMA0BTFiPNU+3SyAGyI
VuMAt14CCULdkOT7O/ptZlvUQ243nb+8Wfx+ZTCLVYObi0SPSBQNOoxQGVorIXq9
e9b5SXlghozy6afu5q3olYTgkzj1EbNBMkoHiM6ZXUKz3JXZYVSXkGLYi4BPHc7R
ssjFnhOdsQa85ZUQDw3AhFzvGTG2Z10fnDoFUBQWaHFgIV7O4KNJhdQlxUq6eRYW
Velsq548FFrjiaJUzteLjpZ3u7DDhB6Pe+2hYgKMt9UBJ2MspEU0VTcGmZ/yPo1U
gm5jqYZ3ZOp7lipcl/ZQlPn0bHaT3CzwRcZSUWAHH6JsAfb0UGmrgkHHrwl/TC5Z
lK4Rzpjp+vAwwo5Q0sD08QZ5d9VDPMU2CGidvEla+r3kjeNVmwlJIXH5G7t+QrdH
ctbF/B++nBid4ia18ekZ5PUm3ZkLLjrFNPrMBHQvAGlSYLNaQsVPGioDmbyHmLDh
xXotrWk5VVCXDgD5fCGj
=hMUI
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
