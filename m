Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab3GPJDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:03:44 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33567 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351Ab3GPJDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:03:42 -0400
Date: Tue, 16 Jul 2013 12:03:14 +0300
From: Felipe Balbi <balbi@ti.com>
To: Hein Tibosch <hein_tibosch@yahoo.es>
CC: Tony Lindgren <tony@atomide.com>, linux-i2c <linux-i2c@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] i2c-omap: always send stop after nack
Message-ID: <20130716090300.GG8880@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <51E50217.1000507@yahoo.es>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6lXr1rPCNTf1w0X8"
Content-Disposition: inline
In-Reply-To: <51E50217.1000507@yahoo.es>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--6lXr1rPCNTf1w0X8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 16, 2013 at 04:19:35PM +0800, Hein Tibosch wrote:
> Hi Vikram,
>=20
> On a OMAP4460, i2c-bus-3:
>=20
> A driver (lm75) is causing many 'timeout waiting for bus ready' errors.
> SDA remains high (as it should), but SCL remains low after a NACK.
> The bus becomes _unusable for other clients_.
>=20
> While probing, "lm75" writes a command, followed by a read + stop,
> but the write command is NACK'd. The chip does accept other writes/reads,
> it just refuses to ack invalid commands.
>=20
> Can you tell me if the patch below would make any sense? Or is it the
> responsibility of the client to reset the i2c_smbus?

patch below breaks repeated start.

--=20
balbi

--6lXr1rPCNTf1w0X8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR5QxSAAoJEIaOsuA1yqRE7ZcQAItkOCWEcaGdt0vJC2yc8Cme
MlA9nxsWr7CWxNXNtStZ5YKXrrnn6VSgatEV0dfWFEp6c6R6zdHwxsQk+SdjRRcR
K3H52N9X+zHpRUyjgKoO0NxLvaMClFqnxO/QqrNFrhwabAsHcBNAOqdU8Nf6wVOi
YJKr4A6dhDA4UBncgfw4nw9+o983/zmnmet7MwqOyQkgQ0yITYsJHrOUGjduug5y
3tXt4L+eBaYtK5M6Dx0hZTbfXYKth71Qng47oVGIp0Y9OuEMr4UEyjoCh1qPkCQk
mvzD2p84sdx+JWyiNyXKoSC4hqT62WyAU4Mo/uDFvFdc7jquhcabFUX5GyUHyrb1
vsqLY/LXmWiFoewiwooqMqsareqSvkfcnNIjFHlt5kl3tr35yYj/V27bZixNfZmh
j3m0o5Eo9BpMkDQ65nl6Lt7XUrWOI+mcGDIJG9KrMJyh32BhHkQkIc+hQxXMCh9M
CpzDfUCqK0s5CxpaS3GBcGV9gmEv7QLrfwMALFNPd7mVBbIp6gMeU+OYLK9CQJuJ
zQuV/vQPTVdohzfGSaRjVqTrSu/Vqi7da3V1mK721gXZ+rVClHQknZHYrAB3Tn9u
hZUnxz6e/3AriL0V6zSrbU1aGtXdEpS/xuKCUWwtVtEaA9GhcbzPnC8aGAbXULAS
frfa2qBSk51FfLKzU4hC
=lPyd
-----END PGP SIGNATURE-----

--6lXr1rPCNTf1w0X8--
