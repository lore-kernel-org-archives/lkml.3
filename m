Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936046Ab3DPP6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 11:58:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:54712 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752876Ab3DPP6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 11:58:54 -0400
Date: Tue, 16 Apr 2013 16:58:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Girish K S <girishks2000@gmail.com>
Cc: spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, grant.likely@secretlab.ca,
        t.figa@samsung.com
Subject: Re: [PATCH V3 RESEND 3/5] spi: s3c64xx: Added provision for non-gpio
 i/o's
Message-ID: <20130416155850.GL26958@opensource.wolfsonmicro.com>
References: <1366015230-18243-1-git-send-email-ks.giri@samsung.com>
 <1366015230-18243-2-git-send-email-ks.giri@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CqfQkoYPE/jGoa5Q"
Content-Disposition: inline
In-Reply-To: <1366015230-18243-2-git-send-email-ks.giri@samsung.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CqfQkoYPE/jGoa5Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2013 at 02:10:28PM +0530, Girish K S wrote:
> From: Girish K S <girishks2000@gmail.com>
>=20
> Currently the drivers supports only the GPIO based i/o pins.
> But there are Exynos SoC's that use the same controller with
> dedicated i/o pins.
>=20
> This patch  provides provision to support gpio/dedicated pins.
> The decision is made by parsing the "gpios" property in the spi
> node.

This has some conflicts with my SPI -next branch, I think it's all due
to Arnd's changes to support multi-platform boot on Exynos but there may
be some other stuff.  Can you please rebase against

   git://git.kernel.org/pub/scm/linux/kernel/git/broonie/misc.git spi-next

and make sure everything is OK?

--CqfQkoYPE/jGoa5Q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbXUtAAoJELSic+t+oim9z2MP/im1kdsXWk0dkOLHQpGyDUmc
TOOGBXgde6KvXnhh+gnGulE81+KxJv/RnfkwRcJbcLnHU5SkYXH/1m+sGydLomU/
l4QgMGYydd1MP7dbUfhrzb06h5wumClYZAuOtj1rsJqaJM6lulhToHf/RLfAur7u
cw0Rx8wHlM5FWeXjGnWbP2wbysNX9cj7KV9BIHZDA+Y7mZZ2XaEGuf5AWXVtvJSU
5FhPEncYIetWu4bSsY8AvcBxZYTLMzoaPK9if4coOOMhNXnDmubEmHMp+eeQCMyp
RqkAOPJ1GCTXYjGIQGZl3TvODuuEvnD9pLK/MhBnzl7GOTAfHcCkuuFTIjD0npPi
47rjYbj3z2Gf5joFuznBeg/VwmG/Q+zI4DfmAn38yDr8Q042G1N1KqBaqsaQTyVN
j/FcPbn2up88rRGDorx4NV42WN42ezwECEC23YRcsDQMRKdO+42NTXs38fHo0EvZ
LQeZSkfPYiz+/vJVB4CPbMsDcm6L6RBpsYOvbjVjY38Go8TYrN+HMYb1pImBgdA4
kY2HdugXj53d7ZxJBAah6VORauwGerH9JhMgIroODKhAcTs35XWkAhfZVMQLj4/L
XwkaLMI6f5OiZM24YrM+cldMIiFSLmY02pBERQy/0t6DY57pUdLs3ujIG0XXbpSE
95YaZVebtvvvBAKOIeRe
=aOhu
-----END PGP SIGNATURE-----

--CqfQkoYPE/jGoa5Q--
