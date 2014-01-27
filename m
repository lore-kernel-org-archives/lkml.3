Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903AbaA0PFI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 10:05:08 -0500
Received: from top.free-electrons.com ([176.31.233.9]:50985 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753857AbaA0PFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 10:05:06 -0500
Date: Mon, 27 Jan 2014 16:02:29 +0100
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Emilio Lopez <emilio@elopez.com.ar>,
        linux-sunxi@googlegroups.com, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH 1/4] clk: sunxi: Add support for PLL6 on the A31
Message-ID: <20140127150229.GM3867@lukather>
References: <1389892285-11745-1-git-send-email-maxime.ripard@free-electrons.com>
 <1389892285-11745-2-git-send-email-maxime.ripard@free-electrons.com>
 <20140117221402.4167.78251@quantum>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ai3I8gwHc37+ASRI"
Content-Disposition: inline
In-Reply-To: <20140117221402.4167.78251@quantum>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ai3I8gwHc37+ASRI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mike,

On Fri, Jan 17, 2014 at 02:14:02PM -0800, Mike Turquette wrote:
> Quoting Maxime Ripard (2014-01-16 09:11:22)
> > The A31 has a slightly different PLL6 clock. Add support for this new c=
lock in
> > our driver.
> >=20
> > Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>=20
> This looks good to me. I guess it will be going in for 3.15 based on the
> comments in the coverletter.

Yes, indeed it is 3.15 materials.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--ai3I8gwHc37+ASRI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJS5nUFAAoJEBx+YmzsjxAg0nwP/jV4RKa9TFCbZu6HqRbmLGrR
j7xP7AbCvF38wJJJPUAULMy+dILWM50d+h8LHgLHC41tTWMHZnVgB50Zhg/HxnT1
DO5LW72Y18pwteeagMlfGrlabb07XdplMiJvkK24myPfsXMj/JBq4dWbCce5p/tb
N0so1XW6jIUPqAin0hfLyL6cVCUYK1yw6EeAALuBfQ6hyYTZnrkQna/6UBkwn/F0
4+qkVKK6HVtq2zwmh1ygMAZiLN/a3igLjpGwWhel3wYbD7MiXEI4VnqPpK8tTwDv
rpi2lfV7OxMdVp1neWmofFO0LDu5EdTxYZ52B6CdTSAaZcEuinD/Vx5lFKw+xoXw
vHnyh9WZD85bCQFLrT900FfGc96k+W039pe84BBHpFg3an8fbVMJE1eVfTMxWHZ/
IGaM9dk7AJM5mx8VpuEQ0b3eipaRl2lDqPRKtAQ3ifG3+LT3lCAQX2tI/796uooo
8IjSlSllRIVDqTOLBaP4MRYgDqQckNs/BHWjJ6V5VBvFs0xocp5GQ8qBvXqJsKiH
qLTJmb17xBdk0hbLojol6/HmQDqls9+h2Ccw3mM9ym7+Nshnf5pCCtOMbnn1aJDO
3LnQctsIIVVewAUznu92GbGKK6fVu/E67ncDCRvkd164tpe5ZI6HyPYMIX5hGHGp
x20MNoQyJGMJzbFh0MII
=p6YM
-----END PGP SIGNATURE-----

--ai3I8gwHc37+ASRI--
