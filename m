Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756989AbaAGD2J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 22:28:09 -0500
Received: from ozlabs.org ([203.10.76.45]:55817 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754974AbaAGD2I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 22:28:08 -0500
Date: Tue, 7 Jan 2014 14:27:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Dong Aisheng <dongas86@gmail.com>, Chris Ball <cjb@laptop.org>,
        <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Dong Aisheng <b29396@freescale.com>
Subject: Re: linux-next: build failure after merge of the mmc tree
Message-Id: <20140107142759.abeb12cd3748ecd3284f20a6@canb.auug.org.au>
In-Reply-To: <20140106064406.GD26128@S2101-09.ap.freescale.net>
References: <20131213125716.f432c59bf8782a489400a5a7@canb.auug.org.au>
	<20131217132838.cc16a4dbac2f4d3218bbed1d@canb.auug.org.au>
	<CAA+hA=Shwn1P25+xB+VogD+9n7gdvCmJ-EG6khgf3a2gjGwTJQ@mail.gmail.com>
	<20131217031600.GG6691@S2101-09.ap.freescale.net>
	<CAA+hA=QU1TApbbohD1iNFiMMMHdQSamRfOsO0r3GpqmCbdiSgw@mail.gmail.com>
	<20140106172243.8067c8e72c666511129a9701@canb.auug.org.au>
	<20140106064406.GD26128@S2101-09.ap.freescale.net>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__7_Jan_2014_14_27_59_+1100_ZAvw9rTzgqu1mkZ4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Jan_2014_14_27_59_+1100_ZAvw9rTzgqu1mkZ4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

On Mon, 6 Jan 2014 14:44:08 +0800 Shawn Guo <shawn.guo@linaro.org> wrote:
>
> Okay, I missed your point.  The resolution needs the additional changes
> as below.

Thanks, I applied the following as a merge fix patch today and will carry
it as necessary.

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 7 Jan 2014 14:20:53 +1100
Subject: [PATCH] mmc: merge fixup for imx6qdl-sabresd.dtsi

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/arm/boot/dts/imx6qdl-sabresd.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi b/arch/arm/boot/dts/imx=
6qdl-sabresd.dtsi
index 0eab66ea2009..0eb5704f2850 100644
--- a/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
+++ b/arch/arm/boot/dts/imx6qdl-sabresd.dtsi
@@ -356,6 +356,10 @@
 		pinctrl_usdhc3: usdhc3grp {
 			fsl,pins =3D <MX6QDL_USDHC3_PINGRP_D8>;
 		};
+
+		pinctrl_usdhc4: usdhc4grp {
+			fsl,pins =3D <MX6QDL_USDHC4_PINGRP_D8>;
+		};
 	};
 };
=20
@@ -438,7 +438,7 @@
=20
 &usdhc4 {
 	pinctrl-names =3D "default";
-	pinctrl-0 =3D <&pinctrl_usdhc4_1>;
+	pinctrl-0 =3D <&pinctrl_usdhc4>;
 	bus-width =3D <8>;
 	non-removable;
 	no-1-8-v;

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__7_Jan_2014_14_27_59_+1100_ZAvw9rTzgqu1mkZ4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSy3RFAAoJEMDTa8Ir7ZwV7VEP/3RntVsI7dmQqaek3lTzuQj8
wvvwhyab8IwCX8+XzxZyuwqTU7z6dhooq8A7kxKWejxFku2LBFw/cm4TAZ5QecFJ
OXvP31A6uryEMRt/E7t2D/hm57Iy45v1s7iptROe9zVNE6HGFyCYUFLioIDsWZCU
gX8ENmecvW4BymjEVKOIkmXGike1Q7xarc5chYaWj5Ds8TKnYuOCRx8B0AjdS7tK
fwN3PS2zziZBtJoeov4OM//hqT+ky5Oe7cyusIzdnz6s/Njtl2yh8l6DFhIreDMQ
fSwgxVhiJ3wHnazcsX37hKMr2IicZRciCPj/NR8NtIbqMnjZwLk1wDsUrZt1P/WE
zQfNyIBe1ANCnxGfQlR0VaJ0VTMmXi8P/AQoN2TObIZ1cAOSAzVi+s6SM4Yb7UEz
buhUW48VUIcZ+JAKvuXnHNSsgxQsbezQ1BhKvFaFhEKZxaHa+7z7hf3rkqnq4oxr
80LEwbOWu0bs90XHNVtKSYSVhXnL8X8B5kpOXAmzr5AWFNR/V7v6GiL9fyelTktB
mv6SY6pO3nsWij7vpS78SJ48xzfVeiIelCbkF5Okl47d3OMNKkxQfPELz9ptjyjb
Awv9XUxltDuyy2iau2bdw82ioQMtk9rcrnbqwxWMLqE5uh/3ziqljVGQFWapkDnU
j19YPOZNkmAOtGOLBQ1D
=c7xi
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Jan_2014_14_27_59_+1100_ZAvw9rTzgqu1mkZ4--
