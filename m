Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759934Ab3DBWFF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 18:05:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52958 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755971Ab3DBWFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 18:05:03 -0400
Date: Tue, 2 Apr 2013 23:04:56 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: ab8500-ext: Don't update info->is_enabled if
 write to register fails
Message-ID: <20130402220409.GP23065@opensource.wolfsonmicro.com>
References: <1364907376.9803.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jTlsQtO0VwrbBARu"
Content-Disposition: inline
In-Reply-To: <1364907376.9803.1.camel@phoenix>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jTlsQtO0VwrbBARu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 02, 2013 at 08:56:16PM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied, thanks.

--jTlsQtO0VwrbBARu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRW1XFAAoJELSic+t+oim9Te8P/RI+y8Io/IrnXpve1Q36oYUZ
T/xgCaGIDP1t2fWzevOG9bAhzoTNX13sBE4gJzhvza/pX9T4GjBS8t2X0R9lUYxk
mZL3ssLl1xpkMzWIk+FtyjHY/pSTxTinHaBdBTqbtA0cevzlxjI+L8C6e9mQ4udM
RxPTmRG0BWiJ+WolZzUGEyKmF9rnRwax0VvX9Svzue6jP6rUZgdzDjar/NhNAxip
JURqVcdLYTOFcqllZd1REDIk77BLHNgU6ufpZEOhMswiWLWOVwISVX2n/EljhKXi
leSvqmR3SdnPQr49bpgc1h33uDW0BOalPvyR/blUrX66qC7gQ8wLGSLvCzVGCyuS
lxv7tAxdBqMqzKsnJpktCv7fZl0zoJnGvm4K9TnE4lAnLacHc8dkBqGm3g4nkSI2
oMqIYTDY3hNWBYyqJn05H4RDgm+zfEkl/0bSkajPOuvFWcYMg9OlP1k5e98G+Owm
KDNF1jq4neWaR2HiYmGWr73dsJ7BCvLFUkcTgsnCw64LIIpYmC8L4vMx5JBnWw0J
pnWlawsBMG1Nq9plbTBDd9Ea7VjQi5TE80l5ryG/UbIl3JaSST+Pe/N+lH5RvHGl
EviKlaAy0h9ANM4g2Wa/WUjE47g4k+CywoxjHiUSUXE8Lh6DNo5nA4w2itHGFCE7
OHY98qv/vlgKDdKhf2Gt
=NZw9
-----END PGP SIGNATURE-----

--jTlsQtO0VwrbBARu--
