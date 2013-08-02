Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751429Ab3HBLhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 07:37:41 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:50024 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab3HBLhj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 07:37:39 -0400
Message-ID: <51FB99FF.9080003@monstr.eu>
Date: Fri, 02 Aug 2013 13:37:35 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org
Subject: Re: [PATCH] arm: zynq: dt: Set correct L2 ram latencies
References: <1375313099-8402-1-git-send-email-soren.brinkmann@xilinx.com>
In-Reply-To: <1375313099-8402-1-git-send-email-soren.brinkmann@xilinx.com>
X-Enigmail-Version: 1.5.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="9EMqpc1Wv85B3JOHn6QfOj0f84VlKduqK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9EMqpc1Wv85B3JOHn6QfOj0f84VlKduqK
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 08/01/2013 01:24 AM, Soren Brinkmann wrote:
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
>  arch/arm/boot/dts/zynq-7000.dtsi | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/arch/arm/boot/dts/zynq-7000.dtsi b/arch/arm/boot/dts/zynq-=
7000.dtsi
> index 6f54a64..e32b92b 100644
> --- a/arch/arm/boot/dts/zynq-7000.dtsi
> +++ b/arch/arm/boot/dts/zynq-7000.dtsi
> @@ -41,8 +41,8 @@
>  		L2: cache-controller {
>  			compatible =3D "arm,pl310-cache";
>  			reg =3D <0xF8F02000 0x1000>;
> -			arm,data-latency =3D <2 3 2>;
> -			arm,tag-latency =3D <2 3 2>;
> +			arm,data-latency =3D <3 2 2>;
> +			arm,tag-latency =3D <2 2 2>;
>  			cache-unified;
>  			cache-level =3D <2>;
>  		};
>=20

Applied to zynq/dt.

Thanks,
Michal

--=20
Michal Simek, Ing. (M.Eng), OpenPGP -> KeyID: FE3D1F91
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform



--9EMqpc1Wv85B3JOHn6QfOj0f84VlKduqK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlH7mf8ACgkQykllyylKDCGqTgCfbEsKoTx80LN3xoh3MebWovoM
6cAAnAxqxZCmW7AcfQKNv9MoTWJ508PU
=pMQU
-----END PGP SIGNATURE-----

--9EMqpc1Wv85B3JOHn6QfOj0f84VlKduqK--
