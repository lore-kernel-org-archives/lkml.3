Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564AbaKRPB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:01:26 -0500
Received: from sauhun.de ([89.238.76.85]:45663 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754427AbaKRPBW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:01:22 -0500
Date: Tue, 18 Nov 2014 16:01:55 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Yuan Yao <yao.yuan@freescale.com>
Cc: marex@denx.de, LW@KARO-electronics.de, mark.rutland@arm.com,
        fugang.duan@freescale.com, shawn.guo@linaro.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v11 0/3] i2c: imx: add DMA support for freescale i2c
 driver
Message-ID: <20141118150155.GA30004@katana>
References: <1416306667-15673-1-git-send-email-yao.yuan@freescale.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <1416306667-15673-1-git-send-email-yao.yuan@freescale.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2014 at 06:31:04PM +0800, Yuan Yao wrote:
>=20
> Changed in v11:=20
> - Fix the bug for 'orig_jiffies' uninitialized.
> - Use wait_for_completion_timeout() instead of wait_for_completion_interr=
uptible_timeout().=20

Applied to for-next, thanks!


--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUa19iAAoJEBQN5MwUoCm2rjIP/0UFcRatChJe4L+YU7l24G9H
J+uDWA+uSUqXa2uRreYcUmobkLtDfK6hfjtphnqlNPasJdGwZ3DsQsBSKHiwOM0k
TLxDd4aegWYPzivU0DCNUMw2LEr9aJn7PcyEVmgzWyNGWGWhQqDlp56vRjA4DJ7S
CQkyD0KRKiJd9NA2Z5FKx/8+lcBylJuto7LAMfG29SpGXBBdD+gyuLGS/AsW2hE0
BokWXHFlaxMy6v0apBFrs5BfcRN8DI6+dWwMKtsSKhP8z9uQ9bODSjRAjLy4DQfD
UOagqsuIjZgk2Doakmze59GiJtjb6Fsea7VV9HIhWWgINWlfmInJD5KMj6FwdezZ
CDPE561NYJROv3SG90uwgVACH+BiLMtzDfZZ0mVQQz4GwiK+nMp1aaG7hlwoZEVz
yEOAKJ/ANAZOmOPevdT4shtUwIRXFUSFlmf9SM0l2IdfVe83myoPog73o34M4Ewx
XsEraBUnR4zR+GLSuO/VPQHEa/bm3q8Z7wVlQ5becZYpoU4lKImiZ6JL6O/yHKwV
MFmWACjqCcxLt/aMCXpea1mMjeuc+bR+Q+KfDJz/blfviKfssp7nw71PdDHYWyxj
5Xu4FZ9t+hd/73MwebEnoNXy8tOZ7SEo/zvPuHFJ5BmhaI47gHSPo6Tz4VIRzXid
s8W2pApsHLTaMyrsfUT2
=NlES
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
