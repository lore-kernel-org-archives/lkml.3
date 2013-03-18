Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751156Ab3CRBLX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 21:11:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60525 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750930Ab3CRBLV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 21:11:21 -0400
Message-ID: <1363569069.3937.287.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 052/100] drm/i915: Increase the RC6p threshold.
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?ISO-8859-1?Q?St=E9phane?= Marchesin <marcheu@chromium.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Date: Mon, 18 Mar 2013 01:11:09 +0000
In-Reply-To: <20130312223128.581946761@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
	 <20130312223128.581946761@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-1+sSbtDZHd3ZythYiLhz"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1+sSbtDZHd3ZythYiLhz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-03-12 at 15:31 -0700, Greg Kroah-Hartman wrote:
> 3.8-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: St=C3=A9phane Marchesin <marcheu@chromium.org>
>=20
> commit 0920a48719f1ceefc909387a64f97563848c7854 upstream.
>=20
> This increases GEN6_RC6p_THRESHOLD from 100000 to 150000. For some
> reason this avoids the gen6_gt_check_fifodbg.isra warnings and
> associated GPU lockups, which makes my ivy bridge machine stable.
>=20
> Signed-off-by: St=C3=A9phane Marchesin <marcheu@chromium.org>
> Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>=20
> ---
>  drivers/gpu/drm/i915/intel_pm.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> --- a/drivers/gpu/drm/i915/intel_pm.c
> +++ b/drivers/gpu/drm/i915/intel_pm.c
> @@ -2572,7 +2572,7 @@ static void gen6_enable_rps(struct drm_d
>  	I915_WRITE(GEN6_RC_SLEEP, 0);
>  	I915_WRITE(GEN6_RC1e_THRESHOLD, 1000);
>  	I915_WRITE(GEN6_RC6_THRESHOLD, 50000);
> -	I915_WRITE(GEN6_RC6p_THRESHOLD, 100000);
> +	I915_WRITE(GEN6_RC6p_THRESHOLD, 150000);
>  	I915_WRITE(GEN6_RC6pp_THRESHOLD, 64000); /* unused */
> =20
>  	/* Check if we are enabling RC6 */

Is there any reason why this shouldn't be applied to 3.2.y and 3.4.y?
The same function and writes are present, only in intel_display.c rather
than intel_pm.c.

Ben.

--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-1+sSbtDZHd3ZythYiLhz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUZpree/yOyVhhEJAQpSTBAAw1ZMuYW67R/yOF/l7Gqn7mRBoJKrU6Lw
zKa0bKsbZT+BiwAUJy2OD5Ad3S3o/twa81iZP+s2J2DATV2UCU1q7+F5YxpnwKHE
unGtAL42qxibDAnJrzGu1NJYc0SFqoGnemDQ0sRsgFZHUOVzdTo96psjw/1Pywnd
6WWJP34uZxCKliC8MPiJIKmHzMVMXs2Zf3a1lDF5nmP1HG26DJTzfUaNfOVaNVI4
GvqW6pV09GxvHPWKiwNbxgEYVs0/LHzQ9+nFp6sALwQk8T+hk0hf7XyWFXFNo85I
o8GTVAGQJH8dkPNp28PBw/Znswwb4jdMVa41phCP1BXwC0I10DNXpMZxTukM3Rr8
SDATTQbxvdXBQtzSLiUMm3L4NGJcjN0IwSDgx0gKMw5zP7vS8PhM3KWVRKZefJ1k
EC3oMfTa0ak7/K9UJRRXPIoczOEyFEROodWhNF7BhiD2cOQkqVAOjvYa5NtHPM6/
fuRahPNNb0l7fOv3FgLEn5Ah+Z0AJZkOwlJQQXASC9PZQG1zmGVQs7DAppOGICG/
DkwUzRi/QWSB4H7xaul9rmQLIaDbxEwMAmFC9bYLJRn+5Hbt3UzH8JQcBG7kraYp
q3/gOC8G46IaioXXOeZR8vTTaftLe0juoGKJkuyns9DS+SCY/NfbynUsYSUAjwM8
DoyetlXxdIc=
=YcZd
-----END PGP SIGNATURE-----

--=-1+sSbtDZHd3ZythYiLhz--
