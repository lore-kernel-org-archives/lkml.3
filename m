Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518AbaAHNmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 08:42:08 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:45381 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbaAHNmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 08:42:02 -0500
Date: Wed, 8 Jan 2014 14:39:52 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 3/6] ARM: tegra: Add efuse bindings
Message-ID: <20140108133951.GD1592@ulmo.nvidia.com>
References: <1387891931-9854-1-git-send-email-pdeschrijver@nvidia.com>
 <1387891931-9854-4-git-send-email-pdeschrijver@nvidia.com>
 <52CB14D3.2060904@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1sNVjLsmu1MXqwQ/"
Content-Disposition: inline
In-Reply-To: <52CB14D3.2060904@wwwdotorg.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1sNVjLsmu1MXqwQ/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 06, 2014 at 01:40:51PM -0700, Stephen Warren wrote:
> On 12/24/2013 06:32 AM, Peter De Schrijver wrote:
[...]
> > diff --git a/arch/arm/boot/dts/tegra20.dtsi b/arch/arm/boot/dts/tegra20=
=2Edtsi
>=20
> > +	efuse@7000F800 {
>=20
> "fuse" might be a better node name; "efuse" is presumably the name of
> the instance, not the type of object.

There's another occurrence I noticed recently where we haven't followed
that rule. The PMIC node on Venice2 for instance is called as3722.
Perhaps that should also be renamed.

Thierry

--1sNVjLsmu1MXqwQ/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSzVUnAAoJEN0jrNd/PrOh2IUP/0HmJ+zy8f/2KJjdWlr0482w
QNMB6eOD3oYxRgXyxjAtQTqb2RHASLLvSRdLKz8mz+/0ZP9is7ufOYJtin4VnDki
8N5mqGuRtkk/XDLWPdqWbJT42h3SrGq7yC3tvG11cnNuw/jrZGrmPyfWn3e/sUFw
jY24rUqPg6oI1XnVNn2BGsI0URellhGxHFtKrmYkmHIpBCUa1XrU5OoAsmXAwAl0
/OgshcxI3J6IQ2R0ClQydmlI83Lfz1D+BixyH4G3pxl5MKkg9I/josOkWZv5InRW
9IaS6KpEpoouAuoRDoA0XGXLt/c2pE583DiTs3cFUON7b2o5ECpiyK/D+LlipsrG
cgr6q39iZrQPP3iH1Dz35HrTBa3ZHktTGB7ZJrAoZ8G0dTbanvaeBlAgVj99YMnA
Zuvw4iAXlxxV4T6Vl9tkeAn2UXrPT5UQhN4bnH3VMQDlgHeHO5MNENUJCj2OpVuv
Wud7TICgJAGOICBF61jSWaUAUR4Az9kFA5Q5V0sCpwM3qrdQJQydLnoJ8/qhpWyG
9FRpSehrRyh6Ua/8/xvdJOMXt+CItXs3GozgYCpbT27XLhL62A9CKGcNq7HJDGjv
xCexfDB8HYGYiSAmEs3xAT99SxfpzqNHPWXbkl4lXOhJi4Y1nkycL9NFTaNPSxug
OigsMWOU/MGKAHXHF9xT
=l8Z3
-----END PGP SIGNATURE-----

--1sNVjLsmu1MXqwQ/--
