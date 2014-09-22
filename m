Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753840AbaIVKnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 06:43:24 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:53279 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723AbaIVKnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 06:43:23 -0400
Date: Mon, 22 Sep 2014 12:43:20 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: dri-devel <dri-devel@lists.freedesktop.org>,
        David Airlie <airlied@linux.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?U3TDqXBoYW5l?= Marchesin <marcheu@chromium.org>
Subject: Re: [PATCH] drm/panel: update innolux n116bge timings
Message-ID: <20140922104319.GQ1470@ulmo>
References: <1409626606-15225-1-git-send-email-djkurtz@chromium.org>
 <20140922083929.GG1470@ulmo>
 <CAGS+omBFQi2BokDCV8DpRYwKs7DsGWKfxtDu8+7zJfKatL0SeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aNvCJ41Feu8IgPyB"
Content-Disposition: inline
In-Reply-To: <CAGS+omBFQi2BokDCV8DpRYwKs7DsGWKfxtDu8+7zJfKatL0SeA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aNvCJ41Feu8IgPyB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 22, 2014 at 06:12:41PM +0800, Daniel Kurtz wrote:
> On Mon, Sep 22, 2014 at 4:39 PM, Thierry Reding <thierry.reding@gmail.com=
> wrote:
> > It shouldn't matter all that much since the panel has EDID if I remember
> > correctly. The modes parsed from EDID should take precedence over the
> > fixed mode. If they don't then that's a bug.
>=20
> The driver I am testing this with does not yet support reading the
> EDID over eDP, so I am using the fixed values for now.

Ew... you should get a better driver, then. =3D)

Thierry

--aNvCJ41Feu8IgPyB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUH/1HAAoJEN0jrNd/PrOh6jQP/AuHn35zUI9p9QFa+M94hrVr
LOIIRPxgVdQc7BIkc4Ai/2Zg5WE0u26fLdcyT9Sdmy1hmK7ZhYTqTCzdzqv9/ZZA
RkIvSq42Bhiz/ebViVq63TLlT/vwmfiA8LJHh5uWXqD9C7lS0VfPXUFF/M3x2Yv7
J23JqUA/Fw9NZe04PMEEUaGnfdosm6ip3eNbwYeIlwEsVkNxODb2yBu+XYfqvDOA
EaQAUyu5687ljvJXzWUEVoYGUf1SOn3uVnNHcEjHUcFt6uzuqg3FPVSrU66N4L10
/RBSiHAQ6mUBKnK2PRkx82z1LNbwXDbbEagHDMuAKpyuv953AJxDgmoNFlARsSsk
QKtJYjfQg2oBRFnCABL3D5+12aaJipB6M6TNajjxGOJyh3T0vWhvB3lC5CUngZen
kBlEZ5mMN6wSYbiWvmdAWK31LizY4SuNU/hA+S0dnKNhmBmliQXGNXNCguXR7EHB
hGxQNJDrH3C/JWbXzbsyEWLM5AnAMSSmRI3Np38XDFqzbTk/ynOwTWdQIrq5UCbL
dyxC8zSYRxc4H56v8u2mjEeEeWqBozzrc8xag1ChOPe1dGD3c9VAEZ2+MY0I0sJW
bH4WG1pgrmxxTmDQ+OM8Kt0u9ZPv0AaMQqFhWHp+vlM/rjdfxsUBdOFgzQlGE3uW
1hoEIEzo5sSkXkXTMHhM
=vC5T
-----END PGP SIGNATURE-----

--aNvCJ41Feu8IgPyB--
