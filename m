Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934011Ab3LIQPy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:15:54 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:52500 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932938Ab3LIQPh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:15:37 -0500
Date: Mon, 9 Dec 2013 10:14:22 -0600
From: Felipe Balbi <balbi@ti.com>
To: Lee Jones <lee.jones@linaro.org>
CC: Felipe Balbi <balbi@ti.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Aaro Koskinen <aaro.koskinen@iki.fi>, <sameo@linux.intel.com>,
        Tony Lindgren <tony@atomide.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 01/15] mfd: menelaus: Drop __exit section annotation
Message-ID: <20131209161422.GC24047@saruman.home>
Reply-To: <balbi@ti.com>
References: <1386042188-12246-1-git-send-email-balbi@ti.com>
 <20131203095136.GF11828@lee--X1>
 <20131208190739.GA18977@saruman.home>
 <20131209093748.GA12675@lee--X1>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ghzN8eJ9Qlbqn3iT"
Content-Disposition: inline
In-Reply-To: <20131209093748.GA12675@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--ghzN8eJ9Qlbqn3iT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Dec 09, 2013 at 09:37:48AM +0000, Lee Jones wrote:
> > > The code looks mostly fine, but the implementation of the commit logs
> > > seems lazy. Please submit a v3 using coherent sentences with full
> > > explanations and correct punctuation.
> >=20
> > example ?
>=20
> All of your commit messages.
>=20
> > that macro just helps removing some extra
>=20
>   ^- Sentences start with an uppercase character.
>=20
> > line of code and hides ffs() calls.
> >=20
> > while at that, also fix a variable shadowing
>=20
>   ^- Sentences start with an uppercase character.
>=20
> > bug where 'int irq' was being redeclared inside
> > inner loop while it was also argument to interrupt
> > handler.
>=20
>   < ---------------   50 chars   ----------------- >
>=20
> Please use the full 72 char (or there abouts) width of the buffer.

I don't see any mention of punctuation problems, however. Also, you're
not complaining about the content at all, which tells me those sentences
aren't as incoherent as you claimed before. But fair enough, I'll fix
those up and add Aaro's Tested-by

--=20
balbi

--ghzN8eJ9Qlbqn3iT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSpexeAAoJEIaOsuA1yqRE3/IP/2PkBF7vCs18wGZHDeFgfDOI
nGF+ykmHeVeMXhpb/8BcD4Oob+X3sBsZ60+WZ6cUizAt40Dzq02548JtydFMjBnb
arb7qVmiYYvGEAHXP9nhm88q/+lBlB0Fu0i3i0pDhIHuxy4FieQmSidR/quDd5xW
1LwHeAtMFhk89TnPwuDZtEGUxN0Qb/f8ojbjl3yIC5JFVhJEdwRl+orRCa8vUBUI
1cvSWl/kAyKoazEkZ2Z9r9Qq/ge8FDEEyND672ng4Sq/t3sl6ck3minMplQ5+bUk
laEHFZ5+X3K600wwxu4cFKX5Rf2MdUp8hgFrcahgRxGR4uOP4ILoWmBiBn4DSv2x
J+Y0Yy0HEJh+OSGhCTYXaTLZmcpjVJXcgiK1lE8SXiYkj3Hy57YR4lF9d6HuKOUw
KoxDngPIDTe4GTf/oruTzGcJbx7BNngU76E7ttJaBYgIXiG+nzkHKtLhKnh6mapG
vZEY8hA6pIO1VKsFhv1fFbFZjag0sQ9LdRxWUdARb7QC5GpgHU/L6sYFpSVjzb+7
HoNC2Rv6HzQFYVuIvjqJimkOOZ0vQV9txxciuUjBTqeaIrrHUMY6Ut5Wmcba5gze
YUzDZ97lBPf/MNDmn5C07+APELLFJQCz5dg5n3YqESKe8yQgZYYT2idwsvHXrCJR
7yiPXEl70roKe+heWZtB
=3+qF
-----END PGP SIGNATURE-----

--ghzN8eJ9Qlbqn3iT--
