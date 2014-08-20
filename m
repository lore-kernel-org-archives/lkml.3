Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460AbaHTIGA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 04:06:00 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:60573 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbaHTIFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 04:05:54 -0400
Date: Wed, 20 Aug 2014 10:05:50 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: broonie@kernel.org, mark.rutland@arm.com, robh+dt@kernel.org,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCHv6 2/2] dt/bindings: Add the DT binding documentation for
 endianness
Message-ID: <20140820080549.GA15414@ulmo>
References: <1405398183-31345-1-git-send-email-Li.Xiubo@freescale.com>
 <1405398183-31345-3-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6c2NcOVqGQ03X4Wi"
Content-Disposition: inline
In-Reply-To: <1405398183-31345-3-git-send-email-Li.Xiubo@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6c2NcOVqGQ03X4Wi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 15, 2014 at 12:23:03PM +0800, Xiubo Li wrote:
> Device-Tree binding for device endianness
> Index     Device     Endianness properties
> ---------------------------------------------------
> 1         BE         'big-endian'
> 2         LE         'little-endian'
>=20
> For one device driver, which will run in different scenarios above
> on different SoCs using the devicetree, we need one way to simplify
> this.
>=20
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  .../devicetree/bindings/regmap/regmap.txt          | 47 ++++++++++++++++=
++++++
>  1 file changed, 47 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/regmap/regmap.txt

Sorry for jumping in so late. I think this binding documentation needs
to be moved somewhere else. regmap is a Linux kernel specific
implementation detail and therefore has no place in device tree binding
descriptions. Furthermore the endianness properties described herein do
apply to drivers that don't use regmap.

Perhaps we need some top-level file that describes generic properties
such as this?

Thierry

--6c2NcOVqGQ03X4Wi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT9FbdAAoJEN0jrNd/PrOhlnYP/3IymfkKbB3C10ACu+v8eMQl
xwXINsbbOFkyA94+1+54L0KTxatC5ukRPgS8Kxf/i6ZGmK3D2HfeAUXp5qbd27uX
4vDkgcqnxVPjmRvUq7tPzMDAuyxucbcECrMAVAKnEMaYHG2hlmNwVOZ7crHAkIzF
TwkbydbxK/aAFGZD9z+agLVdgMwnw54j0fyeUb5erLUwuKKujck5b/WhTAilnL2R
zPf0BOnlkw0rYRGcamDcqVc8W8yMteeyvV1egi92MxCq9Kr4cCpq+OHHq+FTXflJ
Q6aTR+T/tZ6MoU+Tq4H3spq9Mc4sXr8Be01eQLVuzCpV137rDoPxv7T3bNW5GVum
fhxKGG99Zt4fqgvIiNcTUEs9kZblTDEOH0/vsj9t8zb4VtOqJLbGBZaWMA1yvtBe
1zo8aUdGI+0D4xMzx5bYb7ZC+JlgGuEvHAloypShDhIGn7IRLQ1bPGgisZ+ysI2f
lkSTzm0sU23fyaEcn7fcbjSVPe3WFk1iQ5vUfDQHETj+0WzEToDja2MJNZYvUH5p
GPQ9jAG9lrV5oYHBYnzDYDOk8FU71OnFUtVCOtnuy1jh2w9NIXhTjui9ZScPLNxr
F+8NBqEMvmN5hoRT4wsNLHzOe9mFBupW/PTm6glx3t/4AEHEo0DbT6j++YYnhZxT
MWmfD6sAIdbFpEtRUoqf
=iFNE
-----END PGP SIGNATURE-----

--6c2NcOVqGQ03X4Wi--
