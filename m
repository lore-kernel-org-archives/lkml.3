Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754246AbaIVOsp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 10:48:45 -0400
Received: from sauhun.de ([89.238.76.85]:50546 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751070AbaIVOso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 10:48:44 -0400
Date: Mon, 22 Sep 2014 16:49:05 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Anders Berg <anders.berg@avagotech.com>,
        devicetree <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: axxia: Add I2C driver for AXM55xx
Message-ID: <20140922144904.GA1465@katana>
References: <1408967482-17723-1-git-send-email-anders.berg@avagotech.com>
 <20140920121242.GA3833@katana>
 <CAE0=X_0VQ8rWrUgbsgKm1MwCP8bwWm3UJPq9p=xNDfjP4CC7Bg@mail.gmail.com>
 <20140922095939.GB1406@katana>
 <20140922130351.GL5182@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
In-Reply-To: <20140922130351.GL5182@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 22, 2014 at 02:03:51PM +0100, Russell King - ARM Linux wrote:
> On Mon, Sep 22, 2014 at 11:59:39AM +0200, Wolfram Sang wrote:
> > IRQ_NONE is "this interrupt wasn't by me" so for shared IRQs, the next
> > handler can check.
>=20
> Err, no it isn't.  IRQ_NONE has no such effect.  All handlers on a
> shared interrupt are always run irrespective of the return value from
> any particular interrupt handler.  See kernel/irq/handle.c.

/me picks the brown paper bag. I was sure I did. Need to update my
notes, it seems. Thanks for the heads up!


--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUIDbgAAoJEBQN5MwUoCm2N5UP/jYrU/j6nw2tJlhSg1IXtIub
DI1aIy/K73SQAaXB92qUElCsRNpHh+bt0CmTwmSGuWNJc6CIyZiOlvlvJwc95Lwe
lG0iYgm7wzYGPfrduvXLrrXBqiU6CdE6N6e6VY/zOQQSLlmJpXwTY8gjWMij6wQH
RZJrbxNgMnH5mk0R/EPil7DdgB1GxQTBdIENWP/210WDfqBhp60ki92QpZpYfNav
l+MpZzMh8WH9WcyC7YeDIwJDMntyemHkAUXjztLS9un9j5VekyubOu8fXBLQpoKb
Dts19ItfS+e7y77FquZ0Gy8mlPC8NNaW2RC0guM0BKvfMokJiHh6qOyxA51rwKNc
LO//96KH5PghNonlG/o4R/ONOn+VUvIhWK/9LQPZFwy85Tb+uKZ6tkkeYEaNS/Cs
ex8xGIqVtphMsYezx7VNQu1JPRh5OCTb5AWINbsUiXu4/nHXy46bkIUxGS3upoUr
OpNtddM/x+0x947z/laXUQW787AUc6HNGkNohlFLGLMpevw8MDzIxnuUpc1lhRNJ
xGJle1x6LXHOwbPjvFDMZVXBhyrJaUk/9WWwkbt5NArANtrKjH59a5ytEHvZ5G21
x5zaiVG8ZJZPLHRZIR0VIT6oiBbfRQHXH0pDqtrmWzkGQxJ86mQZChu/mu8vH378
aiIfpoGNYH+sgzv7cfSb
=vFvp
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
