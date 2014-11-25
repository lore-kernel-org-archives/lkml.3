Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbaKYOKR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:10:17 -0500
Received: from sauhun.de ([89.238.76.85]:32818 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbaKYOKP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:10:15 -0500
Date: Tue, 25 Nov 2014 15:11:43 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Grant Likely <grant.likely@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>,
        Rob Herring <robh+dt@kernel.org>, Mark Brown <broonie@kernel.org>,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v2 12/14] i2c/of: Add OF_RECONFIG notifier handler
Message-ID: <20141125141143.GC1843@katana>
References: <1416868422-22103-1-git-send-email-grant.likely@linaro.org>
 <1416868422-22103-13-git-send-email-grant.likely@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ncSAzJYg3Aa9+CRW"
Content-Disposition: inline
In-Reply-To: <1416868422-22103-13-git-send-email-grant.likely@linaro.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ncSAzJYg3Aa9+CRW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 24, 2014 at 10:33:40PM +0000, Grant Likely wrote:
> From: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
>=20
> CONFIG_OF_DYNAMIC enables runtime changes to the device tree which in
> turn may trigger addition or removal of devices from Linux. Add an
> OF_RECONFIG notifier handler to receive tree change events and to
> creating or destroy i2c devices as required.
>=20
> Signed-off-by: Pantelis Antoniou <pantelis.antoniou@konsulko.com>
> [grant.likely: clean up #ifdefs and drop unneeded error handling]
> Signed-off-by: Grant Likely <grant.likely@linaro.org>
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: linux-i2c@vger.kernel.org

Reviewed-by: Wolfram Sang <wsa@the-dreams.de>


--ncSAzJYg3Aa9+CRW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUdI4fAAoJEBQN5MwUoCm2W4EP/3qb5u0igOYGh/2FevV4t+b4
DJFLtEVwjwqQwIgZMpUwu0WT1CIsoI6s+q/lgiG4Fl9y2P2ZleoRECGx0dkxMZmG
wL+Bg2S6MnUbJOp1+I6xoLO5LChOYIuj6k5bm41YF+7sABIlmdiBJUP1QMnv6VQH
XHCxOjBwqlhzd19cbCTsrztGEO/QnbCJyu2oIk6pS5E3a6IWa7n8fEJI0bUVairm
tqfCv5wZnYo9h+xYP9qoxJoy5wYSR1fHbflK/LCBh7Di5i69qc+ED/OJt8t/iK4a
nhjGVguPE/zdJZKIITe6ekuwPxgy9LGDhwEbFymbOMGml/pak9v17osUqvaUSWmF
XjSU+ojxALYk6NwJ7FXOPoTrY7EiOJc4v4BL3xa5waRkhLoWrCVs6B0SPGpykf+d
g7jk9JNrPDTryxkiN+yMI9DOfElOxw7ebbRkBigVi//58qkTM8aWXWVlwEI/xUxK
QXX8IUOemRJZPbt+YIQQdrerIyUXHPPuicI0eWC+SldYB7HmjO6EcvuQY6EvCY/B
TcXE5tYsveAOTC6aYwf4bfd4f+GgzfV5SQanH1IGBSnyCSQNAFE+YR9tFY9745n+
mQXlJ7GSIv2KyA9YSnx0D7NVd5jUQolJ2rjWYz+D3w7TIxUfqRZAAj9wSi6HgmhL
6PvubW5n5gHEhs1DWFx2
=1DXP
-----END PGP SIGNATURE-----

--ncSAzJYg3Aa9+CRW--
