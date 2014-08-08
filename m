Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835AbaHHQfK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 12:35:10 -0400
Received: from sauhun.de ([89.238.76.85]:45796 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756194AbaHHQfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 12:35:06 -0400
Date: Fri, 8 Aug 2014 18:34:55 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Addy Ke <addy.ke@rock-chips.com>
Cc: max.schwarz@online.de, heiko@sntech.de, olof@lixom.net,
        dianders@chromium.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, cf@rock-chips.com, xjq@rock-chips.com,
        huangtao@rock-chips.com, zyw@rock-chips.com, yzq@rock-chips.com,
        hj@rock-chips.com, kever.yang@rock-chips.com, hl@rock-chips.com,
        caesar.wang@rock-chips.com, zhengsq@rock-chips.com
Subject: Re: [PATCH] i2c: rk3x: fix interrupt handling issue
Message-ID: <20140808163455.GA2847@katana>
References: <1407490900-4718-1-git-send-email-addy.ke@rock-chips.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
In-Reply-To: <1407490900-4718-1-git-send-email-addy.ke@rock-chips.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 05:41:40PM +0800, Addy Ke wrote:
> If slave holds scl, I2C_IPD[7] will be set 1 by controller
> for debugging. Driver must ignore it.
>=20
> [    5.752391] rk3x-i2c ff160000.i2c: unexpected irq in WRITE: 0x80
> [    5.939027] rk3x-i2c ff160000.i2c: timeout, ipd: 0x80, state: 4
>=20
> Signed-off-by: Addy Ke <addy.ke@rock-chips.com>

Applied to for-next and added stable, thanks!


--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT5PwuAAoJEBQN5MwUoCm2ihMP/i9/62UUo9OMrKe4T1sGnZR8
+b1/Efp2o9jnZ3eyq72JMO6GbYL7Tm/a4gtm4s7PQiRMdKKFaCWlSLpQ6kEbIbzl
EWZr0DzDA+7L8mpN+83dEtbUjJNY98YBPWorfQfXc8irXlRTsdKUNTHZRsnET9gW
1cmD5kMPyIUh36lB3eLnV+TdQ8EzW2aU5kucYlOL2CEYloQ58Ao0WsskLmUWDfdC
EzVJ38qlEbrg6RBm2KwkfY7iZhMnnR07BYGSTG4qOtaHDbVCfXz6j9e9RHj4Owl2
UohdymmVtUOVPvJTFFbQGb+ITPe3bNNzrruBWlxoZEn/Jt8L2EHBGzj73hyZiRiZ
VE4tTNsWQCTJcipo6qiRl5aHfhBi5lGVHiKbEEgUMpDlA/Q29l2zkFrw/4IN5Fz/
JdnTgAvWg/KC8f93lb4zMs8hgfAXU6ukHJ/LKxd0vh5tQWkdcINJaJLp4pUZ3kPh
einr8Ldx0UUFDmovW4bBvsZiJj7lsKKZA+G+servxPOs/Vq74M3OMPU5EZ3vbnO0
W3yge3dlD7AgDW/7a6vdM3HO9Z017J/99396SOvueS5ebCYjikPcmgTdM4QrKGFn
3vLuoLHCuQC2QG9ZSa5XkaivSDu4o94aIvbBAFzkTzJ9xzv1fqYEpvqGoBcYBFEs
ElPhwbX3w2XZJ5nC/O/X
=IF68
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--
