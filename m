Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422852AbaKNWFf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 17:05:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:47012 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161843AbaKNWFe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 17:05:34 -0500
Date: Fri, 14 Nov 2014 23:05:29 +0100
From: Sebastian Reichel <sre@kernel.org>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-omap@vger.kernel.org, tony@atomide.com, khilman@kernel.org,
        aaro.koskinen@iki.fi, freemangordon@abv.bg,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: N900 modem support in 3.18-rc1
Message-ID: <20141114220529.GA18566@earth.universe>
References: <20141104205117.GA17606@amd>
 <5465A977.4030605@gmail.com>
 <20141114172008.GB12250@earth.universe>
 <201411141834.19242@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <201411141834.19242@pali>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Nov 14, 2014 at 06:34:18PM +0100, Pali Roh=E1r wrote:
> Anyway what is /dev/cmt_speech doing? If it exports gsm voice=20
> call data, [...]

Right.

> [...] should not it have alsa snd interface?

Sounds also like a promising standardized kernel interface.
I wonder why a custom interface has been chosen in the first
place.

> V4L2 interface is not for video/camera/capture/tv cards?

The V4L2 interface is also used for radio interfaces (e.g. the
N900's fm receiver/transmitter) and for software defined radio.

-- Sebastian

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJUZnypAAoJENju1/PIO/qaTQ4P/0TlYxevcxO+PWxuJCP/Uwu3
iP+qooeCXhocJJzTAFK0CM3RBqElSvIqcvBwO2loBwXm9wiyzrSzVX7rl0h37hDr
74d4ufQSLb0HfJO7VE3zwM3hrY1lsWJRBHneCbSZ2orirKyIG3BeiLwcJOJcCohW
yrJxSLBejlKcQPMYHnb/1Yy/xyDNYSrho4qzTKnJaxl0L3sNNV2gi3uybU6kdgLJ
7XIDww2bcsM6Zo3xVhO1ZGjO0NhgBLvyNyTeXD1FdDF0d1Uvbcu+wGA3xG1CxpcF
D3o3quaZaH2ACnhC9b081mMtvvxI2KE/rpud5ofXUjyWYn+KA302sPmND8RzwFEo
AtbmZPZfDfLP2k9S0FaJMEPaAqk6r+H97j0J5tElpKdR9Guze7LJUJ9y44060VYr
AI+l0LE1Moxk/Mmio+1j7lDsU5HCLsQUlqPbCPjet5p+vPybSyHadVjfVa5nkVq8
FkrDncTE2p+BDk58ALwqmpEAczeuuIBfXbbSPZ7NFwmMqE3ZPItnhI6b1wljCi8p
F87BM+TU4d0k8UvxlaWG0Hqtg0nXseWWeaIlw6OR18MwhbvbsqAGr7PXsq9VYHXS
82JstTFuQqpWzbyjXJ9d/pSNAD+j4vGA6HgodbV5cnZxkkzJiOWlP9dB6z4Mc1y0
oYycbSkTr7tEznSxUar2
=ElHK
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
