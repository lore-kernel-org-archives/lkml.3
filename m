Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085AbaFEE3S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 00:29:18 -0400
Received: from ozlabs.org ([103.22.144.67]:36234 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbaFEE25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:28:57 -0400
Date: Thu, 5 Jun 2014 14:28:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@linux.ie>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>
Subject: Re: linux-next: build failure after merge of the drm tree
Message-ID: <20140605142848.67fb6ec7@canb.auug.org.au>
In-Reply-To: <20140605141227.7449bb38@canb.auug.org.au>
References: <20140605141227.7449bb38@canb.auug.org.au>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/tRWI6BAPDsWmwFqvhkIRHoG"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/tRWI6BAPDsWmwFqvhkIRHoG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Thu, 5 Jun 2014 14:12:27 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> After merging the drm tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>=20
> drivers/gpu/drm/i915/intel_fbdev.c: In function 'intel_fb_initial_config':
> drivers/gpu/drm/i915/intel_fbdev.c:392:4: error: implicit declaration of =
function 'drm_get_connector_name' [-Werror=3Dimplicit-function-declaration]
>     DRM_DEBUG_KMS("using first mode listed on connector %s\n",
>     ^
>=20
> Caused by commits c0c97622c1bd ("drm/i915: Use the connector name in
> fbdev debug messages") and c23cc4178dd1 ("drm/i915: replace
> drm_get_connector_name() with direct name field use").
>=20
> I have used the drm tree from next-20140604 for today.

This affected the drm-intel tree as well, so it is back to
next-20140604.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/tRWI6BAPDsWmwFqvhkIRHoG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTj/IGAAoJEMDTa8Ir7ZwVfCIP/32utRNtpDEQFyzif0Of1GLT
1lQSZSYx3x1r/RnH9Z9mzYxowFDFzy1UkVK8eOjImVytnbOQNTiU86uz8tVSLkfY
f9jdLnzpNiZpS82yfOu/fPYb81xdCy+WJPfOtc8PN+JTotq0p/IOdDkNpFDhDQAq
W1qUDEEVsqI4gR+lT9UqYLTYsyWKx5kUtcU3WjWY5PQYDHqOqsPjXAHdQmnvdUmV
F7N0+Eu5Ta6iCx6eq68UkrZmxFJYas6A1mGtLYo+KpkdwQ+AMf8F59IQWeDGn9lU
7/2FlTnjg04tU4AZF7IXPNG3ptPWMEGByVI5NKEQ99zLH6dM7JUsE1rvzF1cEEQ5
OcgljZuUmVzkKHASruvuODlFaCfAdU83ppSLVhrskSfXDYa7wYtfGbt10bv0/Qs7
i2Bt74sYZdhc2x/WCRYOvX4yLnURXvJhmXUxEjQvbLWc9Iqinxz309c4cgY9ESGe
gOJS9YWAZEIYIMCnINzJVjjj0WOJwfNWgZC6sRBj/8wshJNvKJeCmMR8NHJ58UUe
W3BssaJzLnR82R4IHhyWo01hwirwpyC+2k2H988HFs8wMdZwrvxrT/D1ukUvLPHf
fDNF5ibto/q8ILNtgdUS+I32PparCLCfW7w8QNeA0FYixlaY5uzhULgR2FQFClpI
HHpCEvIAzqZp81rVx83n
=EoHi
-----END PGP SIGNATURE-----

--Sig_/tRWI6BAPDsWmwFqvhkIRHoG--
