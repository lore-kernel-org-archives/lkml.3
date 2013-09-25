Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579Ab3IYNrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 09:47:21 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:45201 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754775Ab3IYNrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 09:47:19 -0400
Date: Wed, 25 Sep 2013 08:46:19 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Gupta, Pekon" <pekon@ti.com>
CC: "olof@lixom.net" <olof@lixom.net>,
        "benoit.cousson@linaro.org" <benoit.cousson@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "avinashphilipk@gmail.com" <avinashphilipk@gmail.com>,
        "Balbi, Felipe" <balbi@ti.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>,
        "dedekind1@gmail.com" <dedekind1@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 1/4] ARM: OMAP2+: cleaned-up DT support of various ECC
 schemes
Message-ID: <20130925134619.GG10746@radagast>
Reply-To: <balbi@ti.com>
References: <1378986619-26765-1-git-send-email-pekon@ti.com>
 <1378986619-26765-2-git-send-email-pekon@ti.com>
 <20980858CB6D3A4BAE95CA194937D5E73EA15ED7@DBDE04.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xjyYRNSh/RebjC6o"
Content-Disposition: inline
In-Reply-To: <20980858CB6D3A4BAE95CA194937D5E73EA15ED7@DBDE04.ent.ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--xjyYRNSh/RebjC6o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

+ akpm

On Tue, Sep 24, 2013 at 01:04:05PM -0500, Gupta, Pekon wrote:
>=20
> >=20
> > This patch
> > - updates DT binding for selection of ecc-scheme
> > - updates DT binding for detection of ELM h/w engine
> > - removes following obselete ECC schemes
> > 	OMAP_ECC_HAMMING_CODE_DEFAULT (S/W based 1-bit Hamming
> > ECC)
> > 	OMAP_ECC_HAMMING_CODE_HW_ROMCODE (H/W based 1-bit
> > Hamming ECC scheme)
> > - updates DT binding documentation for mtd/gpmc-nand
> >=20
> > Signed-off-by: Pekon Gupta <pekon@ti.com>
> > ---
>=20
> Dear Olof and other DT Maintainers,
>=20
> This patch series has missed multiple merge windows, and
> much of the other development work on mtd/nand/omap
> driver is gated due to this.
> So, request you to please review this patch set and Ack it
> if all your mentioned concerns are resolved.

--=20
balbi

--xjyYRNSh/RebjC6o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSQukqAAoJEIaOsuA1yqREmG4QAI4Uzvi3VHdrNmTGNjGJz3VN
j3RxXtbD6I1ZvHqfmR841RYk6HwgSpJiU8Wt8ymOJUNSFHRKWMsMheih/L789g7c
NkhNVeHgMpvvROWOUxiQkSGDGI72hOm4bgYT7Y7taRbcQrb7LNQYSg1hwWH4Vt+e
cxlpw58/s6AaOZpCRNstyjUoZvIjVi4OiCxK7rK3HrH9+xZORE4Fz5vYjqHv9Ndu
VubHmK/3D8tMqw4rGQbapLUHzjnpT2eHPwe2vikZ0wjoccdmrDCIA3VgPYSounrY
wsqEpY4+pTgFD/BAXV61tfIj5sKxpFizkGe911dC7E7fCCEIryhZSuT0MY4wk/MJ
peazcFQTlVRFOIRJV/nn9paJXtN64Dkf5vhqu3yjBMenvqMJUZTjezF8+B01+uvr
REd+1EQce5Is649vJpmNLFiihqhp6IKE8tuaRW50b5zY8mC+ip8Sr3+ENmAcBECd
DC/DdVIzizZKknb3v2+ODuBdBvLC/6+/V5I9AqMeNd7PbaIowjGSbb4kLKfGFIq7
P4WsJRJTYzrEbty4+V/i2l1tOJS6iefJ1qGqHusmtNJ5KxFjN3yGIe85KJr3c2Au
pAfWy6h1oJ5wuq746wHfMc1sQB0kExR0yNJyIkeqIVKQLPmjA82yKJh3m6ZWSGwT
woHvdfOmSAzhnUw1rh7w
=gQOf
-----END PGP SIGNATURE-----

--xjyYRNSh/RebjC6o--
