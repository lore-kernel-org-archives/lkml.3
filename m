Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaJBKxg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:53:36 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58427 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232AbaJBKxf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:53:35 -0400
Date: Thu, 2 Oct 2014 11:53:25 +0100
From: Mark Brown <broonie@kernel.org>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Message-ID: <20141002105325.GQ4273@sirena.org.uk>
References: <1412234823-31433-1-git-send-email-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="x9l1eQe8PlYqUxyS"
Content-Disposition: inline
In-Reply-To: <1412234823-31433-1-git-send-email-thierry.reding@gmail.com>
X-Cookie: So you're back... about time...
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] ASoC: rt286: Fix compilation warning for !PM
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--x9l1eQe8PlYqUxyS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 02, 2014 at 09:27:03AM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>=20
> The rt286_index_sync() function is only called in the resume path. If PM
> is disabled it becomes unused and shouldn't be built either.

Applied, thanks.

--x9l1eQe8PlYqUxyS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJULS6kAAoJECTWi3JdVIfQLiUH/A36WaRUays1fzr42uwaD431
l3tQEVY2WO73YEBmvDFBI7qoHzPSdfa0Hq/hHGp+NIEH/wXFkkwiiXf81Ltuiq1j
6kRjY6K8XabyK8NKax5VVIe5CQLPmPn6tzJ7V1q6OPM+BKPJIl5S3v/YJuDgx1a5
ZvtkTsAD0romg/JtQrugQrNR1FMb92EnXeQqYyf5gNz8G+ZQGWWrSwfSfEvEq5nr
hsJaMtezACdV5z73rZ+U78G2jfJ47J9OIOUbrIc0a5RVyuFmHCdIKRv4KMDOEpWJ
S0sYUBU25iolM9XtTTVWl8tY3oDyGHq5pXivhf5KRHzvw1ajVKsZfnYBHcQdZ1A=
=VLA3
-----END PGP SIGNATURE-----

--x9l1eQe8PlYqUxyS--
