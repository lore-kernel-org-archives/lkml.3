Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaHTSMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 14:12:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:56564 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851AbaHTSMw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 14:12:52 -0400
Date: Wed, 20 Aug 2014 13:12:44 -0500
From: Felipe Balbi <balbi@ti.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Mark Brown <broonie@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] usb: phy: samsung: remove old USB PHY code
Message-ID: <20140820181244.GX24500@saruman.home>
Reply-To: <balbi@ti.com>
References: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MTFjS3R2zZZVGaSB"
Content-Disposition: inline
In-Reply-To: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MTFjS3R2zZZVGaSB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, Aug 14, 2014 at 04:25:22PM +0200, Bartlomiej Zolnierkiewicz wrote:
> Hi,
>=20
> This patch series removes the old Samsung USB PHY drivers that
> got replaced by the new ones using the generic PHY layer.
>=20
> Depends on:
> - next-20140813 branch of linux-next kernel

this thread seems to have died, what do I need to do with these patches?
Are we deleting the phy drivers or not ?

Please rebase on v3.17-rc1 and resend with all Acks in place.

--=20
balbi

--MTFjS3R2zZZVGaSB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT9OUcAAoJEIaOsuA1yqREDFAP/2FZrBlfIb/RJcEr0ZHV/w2h
KS/vfWFeP+3dnF/BEfw7a5AU9YSK9MUeUkAaLgRKFjl7QxcfSwUL8J7EqYbVszpA
Om+LPiU7/QQqGVUIl7R2oK8gw73+0fQleL0fr/GZkNQNxmTNd+uCm8+DzuJqJUeS
5BFAjkSnsqg3m4dYslXgOrT+6awRZGNE35psJlv6SgsO/EgbGGvulU1uET4GmuBy
hhl94o+FkXiVsy+NgtMrmgMQjZH12ouhc+YlzyQ575xMMmzfN3ODBDKzbmfU2zmV
CStePdZVhC9zqlyTwmkso1WgEdd//M9bVj0S4Ldy/KW+R0Yz6rrQ/V1sTJbKYUy9
g6e1ehF8IUAGHeCR3ZV+hy4W/zrsBJ3fIQE13uCbsAL8H4YsS1mAJVe0e62ZyOF6
uhz+o7uH2p1RGMBPvpd4RJi7Yr9BA+3ZNQm/16rHvsF5zv3bhDjO09cgh0nQ25x7
HZypzgDcbIWeQLyo//S66VXW1+3gqXL4QaFRu2kJOLRtMUpoW90U8W4heAzB8cFR
jndb1m/sSPv3tjtQ2IFD95QjJXSOqh3BHOPauwUUUGDb4ol/srXM9UPqZQjQDnTF
2/m/VcWB6JiNgFn+wZB5sG2K7uQwauMluXWt1tVnVm/7gkuM30pxisiUm4lkDht+
0QVnHIoMJ9sVrESBXKn+
=GjfH
-----END PGP SIGNATURE-----

--MTFjS3R2zZZVGaSB--
