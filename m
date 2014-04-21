Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753590AbaDURej (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 13:34:39 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48040 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbaDURee (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 13:34:34 -0400
Date: Mon, 21 Apr 2014 12:32:04 -0500
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
CC: Balaji T K <balajitk@ti.com>, <chris@printf.net>, <ulf.hansson@linaro.org>,
        <linux-mmc@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] mmc: host: omap_hsmmc: a few improvements
Message-ID: <20140421173203.GH22794@saruman.home>
Reply-To: <balbi@ti.com>
References: <1395878690-9650-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CEUtFxTsmBsHRLs3"
Content-Disposition: inline
In-Reply-To: <1395878690-9650-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--CEUtFxTsmBsHRLs3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Mar 26, 2014 at 07:04:45PM -0500, Felipe Balbi wrote:
> this series lets us access the newer registers introduced
> back in OMAP4 which give us some valid information about
> the OMAP HSMMC IP like max block size, support for ADMA,
> support for Retention.
>=20
> Right now, only setting max_blk_size correctly as supporting
> ADMA and Retention will take a lot of work.
>=20
> Tested on OMAP5 uEVM.
>=20
> Felipe Balbi (5):
>   mmc: host: omap_hsmmc: pass host as an argument
>   mmc: host: omap_hsmmc: add reg_offset field
>   mmc: host: omap_hsmmc: introduce new accessor functions
>   mmc: host: omap_hsmmc: switch over to new accessors
>   mmc: host: omap_hsmmc: set max_blk_size correctly

this has been here for almost a month, any comments ?

--=20
balbi

--CEUtFxTsmBsHRLs3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTVVYTAAoJEIaOsuA1yqREC1QQAKN1hJ+u2Jd13AFvIt09j91T
LMJz908joUX9yOQk989qRS5JE4jN2lsXcJ9RWoDLYVQ3OKdpgHFEv0DyPDcR62qy
7eHrEH3UuIlRYazO5dLQVc7zYs4hYhNIsRN9drbHdGVk61aQ/kdye9NMyOr4zA7C
AfY8afhgi9G6aQc1TVcP2fWtXlhOsi5QaxBC7tlR1glXwGhgxmi3hEf1uXvMi0DJ
0FIofkR9egFCmB7JuCSACwDklX66GJTm5I/KISXuRidC/ha+ZVIpMZH94H6lw+ab
aaoa5LSVtrqr7rA4vDMg3i7pLOboGWoMjoxZIQ8lUB1dIvAMANc8PgYrO8lKvANH
r3SoRXZlHPTeKPbVxIjvDjN0ql5ZWK/EyQ42oEQv7XuwEHwZAgMYHdcMoAH9D13C
xdA1rqxT8Sj4PUP5FaKeI8TRpxfVeEwACkRf4rJW609FJbg6SuysnZ9Pk6/9D0Oe
ynrOxipIqbvGOta0R9VlgPwuOEEqEkjpaZO5s6L+wpscwChU56AcAfPmKsBSofT4
4n1QFqQtCGpMApFJejVK9hl7CRP1b/3blQN8vEDeA/GnwHGUa7HUNEqYGQVX/0F8
BxTAs1oZh6l3SG6cBXcg+YBg/lDheSUBr/kLeYCec2FmnKNT3pEDKM9ykECgbiBD
fI8p4MFUdV0TlATUas9J
=rtoW
-----END PGP SIGNATURE-----

--CEUtFxTsmBsHRLs3--
