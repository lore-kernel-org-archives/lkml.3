Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755820Ab3G2V2u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 17:28:50 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38347 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753016Ab3G2V2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 17:28:49 -0400
Date: Tue, 30 Jul 2013 00:28:35 +0300
From: Felipe Balbi <balbi@ti.com>
To: Julius Werner <jwerner@chromium.org>
CC: Felipe Balbi <balbi@ti.com>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, Tomasz Figa <t.figa@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>, <devicetree@vger.kernel.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH v2] usb: phy-samsung-usb: Simplify PMU register handling
Message-ID: <20130729212835.GC6901@radagast>
Reply-To: <balbi@ti.com>
References: <1375132676-15966-1-git-send-email-jwerner@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="f+W+jCU1fRNres8c"
Content-Disposition: inline
In-Reply-To: <1375132676-15966-1-git-send-email-jwerner@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--f+W+jCU1fRNres8c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 29, 2013 at 02:17:56PM -0700, Julius Werner wrote:
> This patch simplifies the way the phy-samsung-usb code finds the correct
> power management register to enable PHY clock gating. Previously, the
> code would calculate the register address from a device tree supplied
> base address and add an offset based on the PHY type.
>=20
> Since every PHY has its own device tree entry and needs only one
> register, we can just encode the address itself in the device tree and
> remove the diffentiation in the code. The bitmask needed to specify the
> bit within that register stays in place, allowing support for platforms
> like s3c64xx that use different bits within the same register. Due to
> this simplification, the whole complication of a Samsung-specific USB
> PHY type can be removed from the PHY driver.
>=20
> Change-Id: Id823f04bbf1942f307bd1d24ec9d8d55a69b0e56

remove this Gerrit Change-Id, please. Also resend with
linux-usb@vger.kernel.org in Cc.

--=20
balbi

--f+W+jCU1fRNres8c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR9t6CAAoJEIaOsuA1yqREk4cP/1dOiP9b4+Wk5lScWYJM3z39
rrP4t75wt8dnCyrjX4pyxvFkeGCIdx5qJPxkN1tbahYdDlgLx1VhUxD6bYYlA/LF
TK5VHSozldkdCE6VtjqHSwZUBLyBgSuXjTIYW3sMSp+lRhlsCwZZm5jhKJHYojWB
bs/7E/ynY/4gf3s3gjgdoAnB/KfHAm0hkMjS9oAyG5J7j2aEU0r/44+taupr6e/W
Ouk5J815zkxZdKQJi3QM6MZn14bVKPgD+qVC4sdOCEJ5hD5OxFGtFheAn/zSIzoE
3BKla0FdotqzG49SCIiHWJOGt0f3HR7RepAHRH/793zEyV/CQVDIdqb/GbEhRtZF
2D21mhOhHf7vp05C/xYXLvu9ReABAJu190MFqOnVr+arX3EXC+oEzElXSb0KjmaL
vKdalvCHJdrzrsZUo+kHD+1QTcx+PZb0LhzpEB+GubOdQchZIecgn5WHCDeVAfed
q9FgCuTgdxfxuxATXblWXKB6xnMIOHpEitbA4Vo1ArHU+x7egAFp9/t7mjnjptEg
MZ24FE/CqoCRwTyPVH6Ojyxlv497a1iuJGjk24MMbDAjCh8hrZXIDJCu6exdhj2t
uWEU8gxXM6fOlt5iDmF776klvxvp1Pcb2qVDASYoCZLDKTQa8MnjWppz7FeQRm8j
ZE+8Nzaz1oIVPlj+Viac
=YREa
-----END PGP SIGNATURE-----

--f+W+jCU1fRNres8c--
