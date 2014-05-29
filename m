Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaE2W6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 18:58:40 -0400
Received: from ozlabs.org ([103.22.144.67]:54680 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329AbaE2W6j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 18:58:39 -0400
Date: Fri, 30 May 2014 08:58:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: abdoulaye berthe <berthe.ab@gmail.com>
Cc: linus.walleij@linaro.org, gnurou@gmail.com,
        mika.westerberg@linux.intel.com, andriy.shevchenko@linux.intel.com,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpio: gpiolib: set gpiochip_remove retval to void
Message-ID: <20140530085832.711df1c6@canb.auug.org.au>
In-Reply-To: <1401402722-26631-1-git-send-email-berthe.ab@gmail.com>
References: <CACRpkdZg559ogf5koyxA_urM949ee-+upauYWQmo-sPUQn-g2w@mail.gmail.com>
	<1401402722-26631-1-git-send-email-berthe.ab@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/TVK/E9unbWQjnMAzm.Niu=0"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TVK/E9unbWQjnMAzm.Niu=0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi abdoulaye,

On Fri, 30 May 2014 00:32:02 +0200 abdoulaye berthe <berthe.ab@gmail.com> w=
rote:
>
> +		if (test_bit(FLAG_REQUESTED, &chip->desc[id].flags))
> +			panic("gpio: removing gpiochip with gpios still requested\n");

Someone else already commented that panic is probably overkill ... is
there no way to log this and continue?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/TVK/E9unbWQjnMAzm.Niu=0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTh7ucAAoJEMDTa8Ir7ZwVzz0P/Al0FVFzrAA6QH0U2YTzs/m6
uFKcpTHL0k9gxkUNk7irzqqj9iUvKn14Yy0DgoLTFxtFOF+Fpo+RAJ9RBAw2aaAp
I8AOd6MGNHV2gViB58NAlOGCrTQJ5pnR8QVwCpKPtNYrRuMUbnSUjPTI1/kFLLkN
junPrCw+5gJVabJ8RauBZwLIsDtU5rVaEriANtBZNb8MvdLjQJlJ0jWx+XSf1WtL
hvz9XtJJI+gXUyZP+1h6R3h5U1alC4VhAJ7WUvmN6GticC+R2RiIw+thV52p0AxH
gsXQMNFsgbnQEBSdVdLDGEXp5ZAPyvQLlSifC5Y+s05lwakcZKsmUu6so8Hx1GfN
XJAhQmBwLTvCpzEcuv7xd1GO1mG1LbgYlKPG91OH7a3W2KWqcykVNNPUl9OYgzw7
tD0gXgX9uzp67XBiG/e0FvyT10AJmHxBe+HvSfhSTHwdvPf178x4BCDOflxxMVeI
zz9rG80xiyLJ1wZsjc+fNzdivx+dNvwSkdjOvFMHp78isvAE/Gl2Xkjmu1R3E3Da
qmQTPV81yizUw3WNbmiIHiitN6PpeqjSYkLZJz6WKj0AEtxbZBOdh1/duxG25S82
PeyIX/EU1u/gbHoQRlhodlHl8cBJ3LXnjB5Zmjpz6ZQgMFqhKrvS2Ix7yk8qzaxX
I1L8ZujZSaEnBbPhEboE
=nnbe
-----END PGP SIGNATURE-----

--Sig_/TVK/E9unbWQjnMAzm.Niu=0--
