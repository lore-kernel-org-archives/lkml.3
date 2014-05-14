Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481AbaEOIgK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:36:10 -0400
Received: from top.free-electrons.com ([176.31.233.9]:53038 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752399AbaEOIgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:36:07 -0400
Date: Wed, 14 May 2014 15:02:03 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: kishon@ti.com, hdegoede@redhat.com
Cc: Boris Brezillon <boris@free-electrons.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com
Subject: Re: [PATCH RESEND v4 1/8] clk: sunxi: Implement A31 USB clock
Message-ID: <20140514130203.GL29258@lukather>
References: <1400072167-29631-1-git-send-email-maxime.ripard@free-electrons.com>
 <1400072167-29631-2-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dp9QYJgVRVEW2bsm"
Content-Disposition: inline
In-Reply-To: <1400072167-29631-2-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dp9QYJgVRVEW2bsm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 14, 2014 at 02:56:00PM +0200, Maxime Ripard wrote:
> The A31 USB clock slightly differ from its older counterparts, mostly bec=
ause
> it has a different gate for each PHY, while the older one had a single ga=
te for
> all the phy.
>=20
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> Acked-by: Mike Turquette <mturquette@linaro.org>

Sorry for this one... PEBKAC...

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--dp9QYJgVRVEW2bsm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTc2lLAAoJEBx+YmzsjxAgS1kP/R8uxKV919PfhdjUbQ1ncpzT
yS/aGABSKgk1zrpW89G02TMGy23sam/jK3T5XpJXFqh09G+fA+su8SydveF9hkVC
VunUtdCyzwJoSDw+MEJ9gBZd4PotaYnsGtyYP+zkT0YwLvs2bqfyrCGtuNe5oD5l
f6fnSAaSWAbEfAiL0tgd6kmZRww5qiMg00iLSizvIsU2ijJ5QjIG6HVHneB64pee
Tge57mMMbJlBqAOzo0pNxgyEOhf8QKSzxJbHLfiMCS5koXG2OmFk0Fhr9C2JBJqs
cX2FuUyS70A6PlSQKMR7KfhmQ1BzcM8FxJzc7XntEF9uv5pC05bzL9tq8gSn44SH
oc6XDSbToFNockC8LQKvwM8Lk0I9pxMq45xbT8F69M1DI4lFbuS3LgEum1rGrbp3
7zVmIC+ajzMASDNYyg+hBY03t1aAVFXvU3jZYzd4d2jYEUZLfh4K13Fv1+gcGwaP
C1HvBO1U0vZDOxPpfbSND5H9uzNERYoGEA9U/MwdbAGmcJeoz6mYYLCzeMC51bVs
XKTOhssYd7B4bXGUdc5wwCb6pH2zzFfG25JWomXYnqnHwDiGpCyY249Kb82vUEzP
mnbZEtscEBPZCK6U2GvV19Tk+Pl7Q6rdSAAlfA4FYuWj0mv9uOYwLeBPiuGAHmzU
sSg5qVvF0pNUBkkvjC5j
=9EKP
-----END PGP SIGNATURE-----

--dp9QYJgVRVEW2bsm--
