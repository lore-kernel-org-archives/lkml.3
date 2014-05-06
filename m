Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaEFTlt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 15:41:49 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:36365 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbaEFTlq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 15:41:46 -0400
Date: Tue, 6 May 2014 14:40:55 -0500
From: Felipe Balbi <balbi@ti.com>
To: Sricharan R <r.sricharan@ti.com>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <tglx@linutronix.de>, <galak@codeaurora.org>,
        <santosh.shilimkar@ti.com>, <nm@ti.com>, <bcousson@baylibre.com>,
        <robherring2@gmail.com>
Subject: Re: [PATCH V5 1/3] arm: dts: dra7: Add crossbar device binding
Message-ID: <20140506194055.GA6962@saruman.home>
Reply-To: <balbi@ti.com>
References: <1399384579-25620-1-git-send-email-r.sricharan@ti.com>
 <1399384579-25620-2-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <1399384579-25620-2-git-send-email-r.sricharan@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 06, 2014 at 07:26:17PM +0530, Sricharan R wrote:
> This adds the irq crossbar device node.
>=20
> There is a IRQ crossbar device in the soc, which
> maps the irq requests from the peripherals to the
> mpu interrupt controller's inputs. The Peripheral irq
> requests are connected to only one crossbar
> input and the output of the crossbar is connected to only one
> controller's input line. The crossbar device is used to map
> a peripheral input to a free mpu's interrupt controller line.
>=20
> Cc: Benoit Cousson <bcousson@baylibre.com>
> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Cc: Rajendra Nayak <rnayak@ti.com>
> Cc: Tony Lindgren <tony@atomide.com>
> Signed-off-by: Sricharan R <r.sricharan@ti.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
> [V5] Rebased on top of 3.15-rc4 and corrected the
>      irqs-reserved list
>=20
>  arch/arm/boot/dts/dra7.dtsi |    8 ++++++++
>  1 file changed, 8 insertions(+)
>=20
> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> index 149b550..0274a86 100644
> --- a/arch/arm/boot/dts/dra7.dtsi
> +++ b/arch/arm/boot/dts/dra7.dtsi
> @@ -790,6 +790,14 @@
>  			status =3D "disabled";
>  		};
>  	};
> +
> +	crossbar_mpu: crossbar@4a020000 {

shouldn't this be "status =3D disabled"; so that boards enable this
on-demand ??

--=20
balbi

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTaTrHAAoJEIaOsuA1yqREVxQP/1rfzqFpCWVKKc8S4sHCubvp
x4kEprOmrbYoeAyQZyqhzM6Ha45kCP0XB8bQlbEE32zfvnqyk3ZWLAqV4q30wpkV
LMAlZkrrdy81izZlXsIISCEWFnlTyMsVJ9JFCcCzGOLhpdo/JarpIqw+6zJxEY0R
WC0DlGT3SSH6C9HhInIGKXCwqpCtQGq5A7ZJeXzLRJAwkl/uVl4OXkeWnFXKu8c2
mzVVwajZmSZpyazAh63REdSjPPNJhnvtf992i/YEAKIszXP+NRsyDFgacfGCxREn
OJccJ1r166dMhGveFI57R3jEPknmhilYtqoTSF9JA8N7mTXwlPJLBWJQdJnblP8D
ODg4hPxRbHhMfRft/arcLzaa0GhN58KXaHCga4Ppts7W134XVZfQSR9s4IhX6U1c
2JCOPadoxP/ynDr9lCpLeNz9pTx2FaBjiJx6ik1GX2rPkgGnbCN8Bfzexz0CFDhR
5llt52NGzDtxxx3nSVfMHGN+sQVxnoipsuW+GOE4Tpb1K61ZE9/z3Q3ejgJhMsIZ
FchTbTB+foWdO9loQ/5pOujUCeODJfPvzGxPQjkQXv5yrTPo3vfTlEv+Od0weew4
lr9oPuwb9Z2o0kBgqPKUHrX55KLwgC89xd26R+6icSdw52jzjxxXcSpoN7DsfEVD
pIywBu8cZlyG/EWoQmLe
=9gl2
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
