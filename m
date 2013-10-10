Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755379Ab3JJMYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 08:24:09 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:33467 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755283Ab3JJMYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 08:24:05 -0400
Date: Thu, 10 Oct 2013 13:23:34 +0100
From: Mark Brown <broonie@kernel.org>
To: Inki Dae <inki.dae@samsung.com>
Cc: "'Olof Johansson'" <olof@lixom.net>, "'Sean Paul'" <seanpaul@chromium.org>,
        devicetree@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'DRI mailing list'" <dri-devel@lists.freedesktop.org>,
        linux-arm-kernel@lists.infradead.org
Message-ID: <20131010122334.GJ21581@sirena.org.uk>
References: <1380670860-17621-4-git-send-email-seanpaul@chromium.org>
 <CAAQKjZN_r-=-sj=Vb-o-KUS4ab5=cjCq1ni3VZeMeVc3NL=MMg@mail.gmail.com>
 <CAOw6vbLiJLLKn=gb1=j5TBeM0ijEK13+goG-=mw7MZTyNT1kpQ@mail.gmail.com>
 <CAAQKjZPwyKCpju4Ndd+MB_aN24-zA5xTHFsFsun2617h7YT6dw@mail.gmail.com>
 <CAOesGMgKastzdFHYQzyL8gxkBN=86wFZ4jbgP8BHxfkOuZvJxg@mail.gmail.com>
 <CAAQKjZMhovKLxNfnXnbF-6diM2zF1cWyi+xHGyL3v83vBh4p6g@mail.gmail.com>
 <20131009182905.GY21581@sirena.org.uk>
 <05c701cec56f$b79eea50$26dcbef0$%dae@samsung.com>
 <20131010093708.GC21581@sirena.org.uk>
 <063a01cec5ad$8afd1920$a0f74b60$%dae@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yJ4qnbZIW6vSQ1qE"
Content-Disposition: inline
In-Reply-To: <063a01cec5ad$8afd1920$a0f74b60$%dae@samsung.com>
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 3/5] drm/bridge: Add PTN3460 bridge driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yJ4qnbZIW6vSQ1qE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 10, 2013 at 08:40:38PM +0900, Inki Dae wrote:

> That is what I mentioned. Some boards _could control_ the actual regulator
> for lvds-bridge, and that would be depended on how HW engineer designs the
> board.=20

For the driver this should be totally transparent - it should just
control the regulator all the time, the regulator API will just not do
anything if the regulator state can't actually be changed.

--yJ4qnbZIW6vSQ1qE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVpxDAAoJELSic+t+oim9lGoP/iCL66+/bISG/Y/dGNV4pH17
Y++ASeLEyHO7YJYMpy+JADrTA18r4YpFub1q6pNFEW3V9MHY0LkFmPDuZdrfSJso
6+Pr8H1DfOF4w1GYosfGxZMv9nmfPIefeKC8KNWHYL6Yi3+GvdScHWjVKGn+daAC
Mrmrq2ajkhlLNsgbok8MoF9UpNsbgXLwXcjc5NBuAhZ8Plh5wChhXW03yYiCAa8F
G/kVcBSfJpWYEyehOhMuFSbbSiE8a4LTFdhvRsCgwnRQBCcb46L1vM61t9xIfJA7
OuNbOfGonWbJEj0FN6tXtyb3JPFf/OuCKFstp5vycgb6Qnb6+SLZN456maTH3Sy4
AL7b3WcK9m+4A2EBVYyo+OBnPmSFb5KWEFUDdt9pkp57tGy2lDudhGh/3UvsrL+z
NGTqZCtvkjtYoCfwc4ZgMoBB91W2j3ZsUWWOcZf+7ktMaj7f50CMrqrbtISOmQVQ
LrzRFGC0K+klrmJ0JzOOTBulJFypuwIUI9Gdo7P5H4MfbRjABqAbilPj4+UsuRGX
OqUhI+X2XfBBOhY5JcKZDSzKEsEQda+Z4USxhueJ+xS3iAsOYdWMj6p77RCOCa5w
1akPTkOHHrnQRTEpB0i80a9ovDl2Ur/7LN2Yx/0vQ9B7fuWqZpoVIgFvn/ARtTs2
+fBQtUfo84DPOgwFKgdk
=xvZv
-----END PGP SIGNATURE-----

--yJ4qnbZIW6vSQ1qE--
