Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756350Ab3AWPyO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:54:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45896 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755880Ab3AWPyN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:54:13 -0500
Date: Wed, 23 Jan 2013 23:53:38 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [RFC] regulator: Display in use regulators in sysfs
Message-ID: <20130123155335.GC4565@opensource.wolfsonmicro.com>
References: <20130122094624.GJ6857@gmail.com>
 <20130123025125.GB5727@opensource.wolfsonmicro.com>
 <20130123081927.GF15873@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UFHRwCdBEJvubb2X"
Content-Disposition: inline
In-Reply-To: <20130123081927.GF15873@gmail.com>
X-Cookie: You are standing on my toes.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UFHRwCdBEJvubb2X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 23, 2013 at 08:19:27AM +0000, Lee Jones wrote:
> On Wed, 23 Jan 2013, Mark Brown wrote:

> > We call our reference counts use count but this was in fact the original
> > design, the local reference counts got dropped due to David Brownell's
> > forceful insistance :/

> So I should pull the patch?

Not sure what you mean by pull; a stright revert won't work.

> How do you feel about being able to access it via sysfs? Good or bad
> idea? If it's a good idea, I can always change the name of the
> variable?

That or debugfs.

--UFHRwCdBEJvubb2X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRAAdUAAoJELSic+t+oim9jZUP/12KVzZWfaP9b8NJTLT9lno1
oP01qj4+kUlR1sD3Z1tjNQaj+UdCbyLbdAdeQI+rldRKBQweHmrfiul38jUq9U16
BA7iNsnOXBq0bYRh+phWZKPWZ50zF/vwlzm0sYqv90vzJheMgshYc4I+BG+ZZ9TV
qAgGSVl3vlUXijM+BIbnuRqHko/787vD/JzqmhGI5TEPxYtOn8tDpsfMCpvcvhBy
ENYfqvDBRZS/Ucc4BW/rZBTBy5ACbEo637lt3V9SukV3TPn8ZUVuS+P4j6OYKKGH
gs9KoLwrLuDKWmgqQb+EguDfR2CKfDiE01hAb61+GfcmTXG+2rqLyONN6JZC54x1
3a3Rom4wjqHi7OA9cUrGbJiLOniCZqa85BTGNTJlkH6hnmBsPI6vSMby5G7rrM2I
NeeuAVlavunwZpiRF38Ubd4PAfPP803QQqndLb9/Vxu4mDdQ4AYx9laXXryJsiFM
WqtPanRTFckZll9rTDm3AY4WXGd1/UljGbD89s/JOTyDo003T3OBSzRwAmDtqY6D
sqdwI3ccAzVd+jHuuPUVJsIdBeKwsiNKwGOdZ4eTjNnCCyxjtpy4lUz9bcBhTW+c
NYDwvP08IVTj4UF73PLb5aHaLvmFy7L0jzRP6cd4YkprEl43DOzbOcQ0u3mSheDg
6uFOG5EepCxGKvIdJRqR
=AoiJ
-----END PGP SIGNATURE-----

--UFHRwCdBEJvubb2X--
