Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756881AbaFYLO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 07:14:56 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:64658 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756558AbaFYLOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 07:14:53 -0400
Date: Wed, 25 Jun 2014 13:11:20 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] arm/arm64: DT: Fix GICv2 CPU interface size
Message-ID: <20140625111119.GA21208@ulmo>
References: <1403692675-26503-1-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <1403692675-26503-1-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2014 at 11:37:54AM +0100, Marc Zyngier wrote:
> All the Cortex-{A7,A15} implementations are using a GICv2. Same for
> the current arm64 platforms.
>=20
> Turns out that most of these platforms have described their GIC CPU
> interface size as being 4kB. while it is actually 8kB (the GICC_DIR
> register lives at offset 0x1000).
>=20
> This was found when converting the GIC driver to use EOImode=3D=3D1 on
> GICv2-based systems. It uses the GICC_DIR register, and the result
> is a very early firework...
>=20
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>
> ---
>  arch/arm/boot/dts/axm55xx.dtsi              | 2 +-
>  arch/arm/boot/dts/dra7.dtsi                 | 2 +-
>  arch/arm/boot/dts/ecx-2000.dts              | 2 +-
>  arch/arm/boot/dts/exynos3250.dtsi           | 2 +-
>  arch/arm/boot/dts/exynos5.dtsi              | 2 +-
>  arch/arm/boot/dts/exynos5260.dtsi           | 2 +-
>  arch/arm/boot/dts/exynos5410.dtsi           | 2 +-
>  arch/arm/boot/dts/exynos5440.dtsi           | 2 +-
>  arch/arm/boot/dts/omap5.dtsi                | 2 +-
>  arch/arm/boot/dts/r8a73a4.dtsi              | 2 +-
>  arch/arm/boot/dts/r8a7790.dtsi              | 2 +-
>  arch/arm/boot/dts/r8a7791.dtsi              | 2 +-
>  arch/arm/boot/dts/sun6i-a31.dtsi            | 2 +-
>  arch/arm/boot/dts/sun7i-a20.dtsi            | 2 +-
>  arch/arm/boot/dts/tegra114.dtsi             | 2 +-
>  arch/arm/boot/dts/tegra124.dtsi             | 2 +-
>  arch/arm/boot/dts/vexpress-v2p-ca15-tc1.dts | 2 +-
>  arch/arm/boot/dts/vexpress-v2p-ca15_a7.dts  | 2 +-
>  arch/arm64/boot/dts/apm-storm.dtsi          | 2 +-
>  arch/arm64/boot/dts/foundation-v8.dts       | 2 +-
>  arch/arm64/boot/dts/rtsm_ve-aemv8a.dts      | 2 +-
>  21 files changed, 21 insertions(+), 21 deletions(-)

For the Tegra114 and Tegra124 patches:

Tested-by: Thierry Reding <treding@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTqq5XAAoJEN0jrNd/PrOhoC0P/jXztf2IbSTJQysE0s7omsj+
CxUeiQvvehmzx26bly9L8C62C/rlPWgGCWTN8lWZcKEINwphiC6ndXlsuO3V4FOX
sW22wV27JYacm034SkbF9GQia9pMsFRIEdf1En8Ky46eLUqYXJX97qyPwWMaNMVu
z2rd/gFkWl/RjyaPuLXKG2R50CKE31WyC7IHn4Y8SQDOMue8UITPMbhKk4jK8esO
iiDJL1K+ECeajj3fyCZKc3vLd7+4b0rE+zwUk41dPVkts2NKC1vhcSyUZfjvAoFi
193PDNYFzey5Wb4f7tq6YdHEsiNYNckE2LnISHjvPFbbysZw4QUFJRWirFgH635F
yZgqNr1Mx772g0w15MMxulqqkqQYetjWCwHTtqfjmbnW2uUIxMYEH06x+Eg3K9Ti
Lf+BGXOx5s5Ga6SB2nFClj6nclnJuP7JTvRvklNoU4GSU9WNnC7ujzcNNA+KIKD8
zJr+yfSAdhhftN+N/183KHS+kYreoxpu91V1ogYozZHEdBRuFc3YzQyzkJfUzds/
8rA0Eo3YmqL0ygdAMb0pT+lnwz6QLRN24HGLrnVCLbj0FvYTJ5T4kiFF6qd9/RA8
QDGsSiinPllgZqcHyYJoMvpZKj1IlK0/EqdBky+3QmVLkoNvgGD9XMwX/YFAq8Oj
e1EZkj0GHfLrULVU7H+P
=KkJ3
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
