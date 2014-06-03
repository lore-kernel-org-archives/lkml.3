Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933629AbaFCTqe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 15:46:34 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52320 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932626AbaFCTqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 15:46:32 -0400
Message-ID: <1401825043.2412.14.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH] firmware: Added fw for qat_dh895xxcc hw crypto
 accelerator
From: Ben Hutchings <ben@decadent.org.uk>
To: Tadeusz Struk <tadeusz.struk@intel.com>
Cc: dwmw2@infradead.org, john.griffin@intel.com, bruce.w.allan@intel.com,
        karen.xiang@intel.com, pingchaox.yang@intel.com, bo.cui@intel.com,
        davem@davemloft.net, qat-linux@intel.com, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org, herbert@gondor.apana.org.au,
        linux-firmware@kernel.org
Date: Tue, 03 Jun 2014 20:50:43 +0100
In-Reply-To: <20140603182455.GA18826@gitlad.jf.intel.com>
References: <20140603182455.GA18826@gitlad.jf.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-yDI1H5yIn02qEhHF/AOb"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yDI1H5yIn02qEhHF/AOb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-06-03 at 11:24 -0700, Tadeusz Struk wrote:
> Hi,
> This adds firmware for Intel QAT dh895xcc HW accelerator.
>=20
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> ---
>  LICENCE.qat_dh895xcc_firmware |  39 ++++++++++++++++++++++++++++++++++++=
+++
>  WHENCE                        |   6 ++++++
>  qat_895xcc.bin                | Bin 0 -> 453248 bytes
>  3 files changed, 45 insertions(+)
>  create mode 100644 LICENCE.qat_dh895xcc_firmware
>  create mode 100755 qat_895xcc.bin
[...]

Applied, thanks.

Ben.

--=20
Ben Hutchings
If more than one person is responsible for a bug, no one is at fault.

--=-yDI1H5yIn02qEhHF/AOb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUAU44nGOe/yOyVhhEJAQqXeg/9FBAAiWd98OpHMunvpHX0BjRqemMn/fy8
5YtWTzmlNqytOwDAhfvxQmH5NsiRekr65pKA1oVhk7KKyGnqwG3IJakYTxGZyY9w
pNBG2OOCHW98sowXXYIxDgtzEvQwAMsrA13IO8IRm7yVp4kKvj/+xWpzWQjRH0Pa
83aXPtTjqH1mu7tvP0OcFj3lg/fymvhV9icqUK1cbbV9mRgadEi61Gyu8Z5r5Rkf
Y83IN9ilhRoSz0pK7tQ9rtEgZapMLIc31oZ/pSr0a1tDjS8j3ZXCjgFZ8LahKKnK
vFnCtD3mWdNd2JTrhc1lpbT2FIN46Ma30pGnX87SteXw1gnR3RY2ygmjVwonvs/p
2nYKvCGSqXyIR1Ifg3XBjarTkXeLrRY209H1UAR+CZOB+N/ZaL1ANqPYYd89Jn4Q
Ho26Aiea7leu7GkkjiXZ7MRct0kZpY0L/lUTwWrLcAhELJkxsomGfNoMgrKE4yYh
TzoMit1H62pMN5RH+6r2b5SkgoSZ5SzIjR35p/eTwRk8dYZ8lyX0wr0HRGOUwXb+
SgptkNg1zgBlPeKI+SPCPq0BXIfgKUZp1Mkjx2/Z94yt4na0oqT265r05Wi+VBZe
9QIfCgM5IYs5lNm5/M086uxtKqvw1fBQRMQ39iqgdkzHh7mI5KGZtvBv2JCcA7P1
Zyq7Kh2lNpc=
=eszr
-----END PGP SIGNATURE-----

--=-yDI1H5yIn02qEhHF/AOb--
