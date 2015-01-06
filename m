Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369AbbAFNIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:08:47 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:48853 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755020AbbAFNIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:08:44 -0500
Date: Tue, 6 Jan 2015 14:08:39 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-tegra@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] ARM: tegra: remove wp-gpios from the generic nyan
 dtsi
Message-ID: <20150106130838.GG31830@ulmo.nvidia.com>
References: <1420540653-14816-1-git-send-email-tomeu.vizoso@collabora.com>
 <1420540653-14816-5-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Cgrdyab2wu3Akvjd"
Content-Disposition: inline
In-Reply-To: <1420540653-14816-5-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Cgrdyab2wu3Akvjd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 06, 2015 at 11:37:29AM +0100, Tomeu Vizoso wrote:
> As the nyan-blaze has a micro-sd slot, as opposed to nyan-big, which has =
a full SD
> slot.
>=20
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>  arch/arm/boot/dts/tegra124-nyan-big.dts | 4 ++++
>  arch/arm/boot/dts/tegra124-nyan.dtsi    | 1 -
>  2 files changed, 4 insertions(+), 1 deletion(-)

Shouldn't this be squashed into patch 2/4?

Thierry

--Cgrdyab2wu3Akvjd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUq95WAAoJEN0jrNd/PrOhGkUP/RVd0lzrU1Z9J2jgQ2K6olr9
ymDvixWY34FKUkcU6PDnKz+aJQU5lqYXHIqXcD1foHOeEJ2CDABlA8c82aG9EeIl
1JquIn4HafGniC1HJWj7YInbAmex9lRqhm0OMcE21F24bjo2QzW10gTc9OdEuYuM
f2veiGqGft7TNzktE+HjTPo1V3dvw1ZeJWzlyujMbrF4FkGQwYhrmD9M5UD9w1fu
blAaEXUAiycc0Sa0guQR+CrSH1+zxfIzMtaznAyhowv8SWb59adVBUGu9c65jvuM
vFHYPRqBvHllkiEcBtGZiT/aWnr8L4zySU6OFNKmKEEGlpXwlGYER/ewVdmhA6rk
Cq54D79/iGUgPCbIj+pVbq638p6JFRI6/uJ38+APHibCoOlg1SmTEexmrgex99yN
HOHL/DVAh2IRYsEKvYKCuNnyOBQ6HMr66HiiQODTEib90NZ3KA98fEOVqbumCocB
rSJNxNhEQvonD3/+9HUt0+Aoa9IGpmsseYME0kWrTsvor3PoYjXkpS3zmJy8XvQj
akqafP0IqhCqo7BZ0Jzpj6QRAMAKxhJXPrAVrA2j/9GNMWA7bw79znIrn/AcEnhF
jRhNnOiqspox3NNiM3wMp6S5jnWpXk6buhKfczmheWUxQfQ2aPlBit/glM7ch5Q0
Q7ZjT0neySd4RwxJEX2o
=Na4a
-----END PGP SIGNATURE-----

--Cgrdyab2wu3Akvjd--
