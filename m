Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab3APRSt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:18:49 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:47571 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756343Ab3APRSr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:18:47 -0500
Date: Wed, 16 Jan 2013 19:18:39 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Cox <alan@linux.intel.com>
CC: <arve@android.com>, <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <mikechan@google.com>
Subject: Re: [PATCH 06/10] goldfish: emulated MMC device
Message-ID: <20130116171839.GD6377@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <20130116165552.15183.92942.stgit@bob.linux.org.uk>
 <20130116165937.15183.76416.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g7w8+K/95kPelPD2"
Content-Disposition: inline
In-Reply-To: <20130116165937.15183.76416.stgit@bob.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--g7w8+K/95kPelPD2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Jan 16, 2013 at 04:59:38PM +0000, Alan Cox wrote:
> +#define OMAP_MMC_CMDTYPE_BC	0
> +#define OMAP_MMC_CMDTYPE_BCR	1
> +#define OMAP_MMC_CMDTYPE_AC	2
> +#define OMAP_MMC_CMDTYPE_ADTC	3

OMAP ?? :-) If you guys are emulating an OMAP mmc controller, why don't
you just re-use the omap mmc driver instead of duplicating the code ?

same comments about devm_* and the GPL license

--=20
balbi

--g7w8+K/95kPelPD2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ9uDvAAoJEIaOsuA1yqRE7S4P/jbm2Gy73O7cfGd7NidQBzoT
4+d0yeyvF0Fq+/yj4XWMbOj0d7g28QgTFYvBGUDOMlQwF5k0lsMDyw4zYpEqXl+g
lz7r2aW4G65QY1Gx1txEtVkj/OS4Nbxw8XrOdUqHhdh7XII3XKTyXkeWLL75V9RA
CZ7UWEfZO9v5hTuGs1y+Aw9giJWAJkqJcmht44Tgcru3AkiN0mQ3QfJ7zmnRqkFx
Lpb/b9ji4fmab9uZf0sbPeeIKYkJLdniWihY6V8x81IySZwAeROEiVPx7u1cH2tM
37+MxgG6rG4UHzYPbDCcuD92ZPEZQ25ZCopj6Sr1gkOSR49Vekx+xG9ZbFRhvjhJ
bND2KO0X89pIHYt/B++zAbgq5/czrLBWDBK+JiBLTYrE83XbWiHotDCMiBbeqWlx
TIX8R2br/1XW9lvFqspKkQ5g+E4o7+/wnbx9KJyLo9dDuB/n5Fs/VS0wpbtGt8YP
vAP2Vk7tzosusBbs289SkLi4DPGjF0ALCV256zXuau2ac6G1JvDYzLNBvjrr7M5o
HPvu8WDubjUYA/gD8zjsQu2wjssL3Zqm+vqh7MMzVlmCqeGGrMRAaRskq9PQgIjz
bBS7JDZwwjPmyv37IA3n3ztiyk6kR3xze3BGuG2w23dLdCt61dFfB/HD3zQSNdqJ
bhqKBviV0iNuh2+HXEZS
=93Om
-----END PGP SIGNATURE-----

--g7w8+K/95kPelPD2--
