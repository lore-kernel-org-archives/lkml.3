Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043AbaCEQbk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 11:31:40 -0500
Received: from sauhun.de ([89.238.76.85]:34057 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753538AbaCEQbi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 11:31:38 -0500
Date: Wed, 5 Mar 2014 17:31:31 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com
Subject: Re: [PATCH v3 1/5] i2c: mv64xxx: Add reset deassert call
Message-ID: <20140305163131.GB9228@katana>
References: <1393950521-4173-1-git-send-email-maxime.ripard@free-electrons.com>
 <1393950521-4173-2-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="H1spWtNR+x+ondvy"
Content-Disposition: inline
In-Reply-To: <1393950521-4173-2-git-send-email-maxime.ripard@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 04, 2014 at 05:28:37PM +0100, Maxime Ripard wrote:
> The Allwinner A31 SoC using that IP has a reset controller maintaining
> it reset unless told otherwise.
>=20
> Add some optional reset support to the driver.
>=20
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> Reviewed-by: Gregory CLEMENT <gregory.clement@free-electrons.com>
> Tested-by: Gregory CLEMENT <gregory.clement@free-electrons.com>

Applied to for-next, thanks!


--H1spWtNR+x+ondvy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTF1FjAAoJEBQN5MwUoCm2Ca8QAJwl5eVudH7RDwfMT8fsJE9u
+8vh8hddNetRsGFot1fn2ivmHdbMM6wp/kXcFmXsdLMqMr7ojDRfcWMptnsa0G1r
CiHN/2CuUFOEkQAX2HB6r1HWecnq2UE0cbN0XDpHuayD3rujlld/DG8RYjiZnYRC
+6kqs+DCSGkGJLIHtt+4re0DoJ4gmpbCZrqCU54v49Re7XQcUlCQarn871BWvp6u
QWnrnxsS2u6B4E5opBmVzR729jkQeO1XyQ56INzLdiYTDJhgyPO806RM7doQm4LU
Rpicfo2+rtKORLXakeHkeJGtF6Tv2lohssS2bkgHWK23YVQoylViuefOXOF+yGXj
f4QsmzyWTmdPYUuM7Su70VRKrnLIEVvnXjHByixMJk0xtzFA6rY8nnh7wjrmJUrF
tLX32FJGW0sOQrNlO6w7Mro942m7GMZfc/sQN68ZiUhHvJqqCAeOWk/dIyPjuhq4
BOhtvuXyotx9yEaqgnsYhl2m0Ry3j2VHX6qoGlNLepHO8rRhBRsxPeOkifmRAMuI
F4dleEES8tWzl2SkNihKfmKVDweEAdmdgHrxbpDvpaMrxTbxoibonCnspQ6xLgu1
z1/5ehmKEeQ9vHoXJ1NULjAa3SsmVR2F3DfEGWo7IwVkfFMTmPUTRRJcYSH6apoJ
SDZRSnaeksASRS+l9nUv
=jwPk
-----END PGP SIGNATURE-----

--H1spWtNR+x+ondvy--
