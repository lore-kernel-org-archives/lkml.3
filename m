Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab3AOLdz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 06:33:55 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:54653 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755723Ab3AOLdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 06:33:53 -0500
Date: Tue, 15 Jan 2013 12:33:48 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Terje Bergstrom <tbergstrom@nvidia.com>
Cc: amerilainen@nvidia.com, airlied@linux.ie, dri-devel@lists.freedesktop.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv5 0/8] Support for Tegra 2D hardware
Message-ID: <20130115113347.GC18119@avionic-0098.adnet.avionic-design.de>
References: <1358249182-17486-1-git-send-email-tbergstrom@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0lnxQi9hkpPO77W3"
Content-Disposition: inline
In-Reply-To: <1358249182-17486-1-git-send-email-tbergstrom@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:efgzX5OLYGldWzyZg0pXxacJn2VLb/3eRpi4EdfgEOc
 R1M51ncI8sPhCDN7zHnyfMdVX3FAq/d/X5m2p+X+6d7pL/ANX8
 o+G4muJb836XBOtgy1Tohl4tsZUExRbaQQwbAB+1PPTZNHR7aq
 N2tvoKtw8UO3NSOaTCoOOFUC0mGAYbVYfxfvgLZpb0KuWNha4v
 d7DWGuPPKcYFx0l3rh5eKpCaNMYRFKz4CsAClFykp1zNCq6tty
 1VIh/Xr/xYt2M/5g0LVR7VeB8CRPTQzGm4XoMrdiLyd+4IAWSz
 QBkADwPC6Gma9pHp5dDJ8kjYf2nEmIMjQtEyi9TzoPaEA2Vw9m
 ZKAOdXYGIVKQbyLfkDjLGsh6agtqffzjDQS99n8zadEcc5eiLm
 n83U0fiy7cgO45+DOvFFM6LzoUO/9yqY+4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0lnxQi9hkpPO77W3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 15, 2013 at 01:26:14PM +0200, Terje Bergstrom wrote:
> This set of patches adds support for Tegra20 and Tegra30 host1x and
> 2D. It is based on linux-next-20130114.
>=20
> The fifth version merges DRM and host1x drivers into one driver. This
> allowed moving include/linux/host1x.h back into the driver and removed
> the need for a dummy platform device. This version also uses the code
> from tegradrm driver almost as is, so there are a lot less actual code
> changes.
>=20
> This patch set does not have the host1x allocator, but it uses CMA
> helpers for memory management.
>=20
> host1x is the driver that controls host1x hardware. It supports
> host1x command channels, synchronization, and memory management. It
> is sectioned into logical driver under drivers/gpu/host1x and
> physical driver under drivers/host1x/hw. The physical driver is
> compiled with the hardware headers of the particular host1x version.
>=20
> The hardware units are described (briefly) in the Tegra2 TRM. Wiki
> page https://gitorious.org/linux-tegra-drm/pages/Host1xIntroduction
> also contains a short description of the functionality.
>=20
> The patch set merges tegradrm into host1x and adds 2D driver, which
> uses host1x channels and sync points. The patch set also adds user
> space API to tegradrm for accessing host1x and 2D.
>=20
> Terje Bergstrom (8):
>   gpu: host1x: Add host1x driver
>   gpu: host1x: Add syncpoint wait and interrupts
>   gpu: host1x: Add channel support
>   gpu: host1x: Add debug support
>   drm: tegra: Move drm to live under host1x
>   gpu: host1x: Remove second host1x driver
>   ARM: tegra: Add board data and 2D clocks
>   drm: tegra: Add gr2d device

Hi Terje,

Just by a quick glance this looks like we're getting closer. To make
reviewing easier, would you mind resending patches formatted with -M so
that git actually detects that tegra-drm was moved. That should make it
easy to see what exactly needed to be changed besides the relocation.

Thierry

--0lnxQi9hkpPO77W3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ9T6bAAoJEN0jrNd/PrOh4sMP/iagyjiN5VvzYSeKAvDTYIok
is5r907S2NLLt2sLEXlyw/QLW9tzoLqpyv5sZxxP8R8Fzc6T2yjf832cvvpn4jps
lqsqBP2da3wjB3Tyy5lPIQB2LLuw3ak7OceJoTHl8+0h0LObXGoPPNXRVr+TRe+V
2Eg0hB1PVTkfAO64pi2wNDaz5od1scobexNLjGVrIsDMdsjsnTyUkcJYo3CK1Ydk
Hj2Pm0HegA5xvtZBb5vdsMkAnr5WLyZKmpKfa1HNBlSImwuviF8ohPdPj2HCydoV
tqbN4cuEoKZQkfEA1t4cMebVqnsoIxga5P3DcoLcA4PpBS8sChk4/r0Jh8PGtjfw
NZ8Ww2JbRJUCOOfWRJGid2qoZ3uCj8zQDCn5U8mKdYxAUcRWRe+orTkJ0CmsBBCr
3cS7d8/sj6MNl/QsO7ottp+2qocev7DpBkkKUo+hQ/7sqb232AIOU1F7JjxLx9nZ
U8RXnOp7z1BZ6ws9yTCvMFB+Phz4k9u3Px2ksE2eTJ5wRieOlR2dN7Ymiz1+BUtj
uHHcER6eUUKFzu84iQEvUn8sZ0p+zENhgtK8KzXwXCtnKJVc+ovgH8r80dGFbXfE
shG4ywcUX0i3lwTAU0JZv8bZnCI27KUT0XePeRYS2r1jfgY7u28FqlHKCd+Y2Lrh
runnrfwW3D2GL7euOwb5
=DsLU
-----END PGP SIGNATURE-----

--0lnxQi9hkpPO77W3--
