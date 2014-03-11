Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755246AbaCKPvB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 11:51:01 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:41480 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924AbaCKPu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 11:50:59 -0400
Date: Tue, 11 Mar 2014 11:50:54 -0400
From: Matt Porter <mporter@linaro.org>
To: Mark Brown <broonie@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Christian Daudt <bcm@fixthebug.org>,
        Devicetree List <devicetree@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tim Kryger <tim.kryger@linaro.org>
Subject: Re: [PATCH v2 5/5] ARM: dts: add bcm590xx pmu support and enable for
 bcm28155-ap
Message-ID: <20140311155054.GL25092@beef>
References: <1392765432-9111-1-git-send-email-mporter@linaro.org>
 <1392765432-9111-6-git-send-email-mporter@linaro.org>
 <20140219044458.GA2669@sirena.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T7mxYSe680VjQnyC"
Content-Disposition: inline
In-Reply-To: <20140219044458.GA2669@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T7mxYSe680VjQnyC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 19, 2014 at 01:44:58PM +0900, Mark Brown wrote:
> On Tue, Feb 18, 2014 at 06:17:12PM -0500, Matt Porter wrote:
>=20
> > +			csr_reg: regulator@13 {
> > +				reg =3D <13>;
> > +				regulator-compatible =3D "csr";
> > +				regulator-min-microvolt =3D <860000>;
> > +				regulator-max-microvolt =3D <1440000>;
> > +			};
>=20

> You should not be setting voltage ranges like this in a .dtsi - you've
> no idea if these voltage ranges are in fact valid for any given board so
> they can't be set safely.  In general I would not expect to see any
> configuration at all for regulators in an include file for the chip.

Agreed. I moved all constraints where they belong in the board-specific
dts.

Thanks,
Matt

--T7mxYSe680VjQnyC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTHzDeAAoJEOfTILNwq7R4JsIQANKk2E4HGfKUKJw5A3Z7NnbD
lXt5wGzbGgqyQOKv2oMDu5GB+Eeq48j2c4CHvzVUc/t3xo89CJ/OegCVwRZe+gQ7
LweWGNwrwiuXeiaDQmn4pS6+T4ag1icNVx3LM8/4eKpgfJdzVs3eaKFv0FjxTKEg
zNt6FhwbSIGagLCBybMLz9Sp2Z09eAB7/D9n3s5ZtR04qyb0XO+LaT+hwktCoG5D
rwq1OWW1ypKBZjGMMuiqoY1RR5UcvPLKaZdD5SYBvbumyjPhIUoPuEbnJYs5wTKJ
54hZRHmPAdKkMddBivCorztYino5JsBfAdurLobgYWZqc5D3LfLxUeOYKGkYj0M+
q9FYSmP1+shH1jd9pVt5e30wkfwu1Y+CC7sR/xyTw+aNkB3eGQtka9Us13UWoQ1y
a6O2ib5Ck3fProQMVjVIbLxQABsFokEXG+X7MzqTsQ/1+FdGmCfPjzrWjiQGacFv
y2WMksFJDALjTv8oJ3ddzxqk3SCgHa2GzcSTFsiq1fVNDzqevz1ETXGZwof5+YXP
+dntZidIKrySOg/l1U8vyiSzLsvLp35HeaaHj1UdeSpJ0y9j7TDwZXQQBuSo0upZ
H5H5HrOeJUh+Y0QhYhuPYcPo6daxT03IwAQ40dFfrlGEl5WdUlhKY65RsTy2cw67
TQvjHQf8WACr31MxmQVU
=RGda
-----END PGP SIGNATURE-----

--T7mxYSe680VjQnyC--
