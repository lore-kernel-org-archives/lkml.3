Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752493AbbAMPQO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 10:16:14 -0500
Received: from sauhun.de ([89.238.76.85]:35702 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145AbbAMPQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 10:16:11 -0500
Date: Tue, 13 Jan 2015 16:16:02 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Nicholas Mc Guire <der.herr@hofr.at>
Cc: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Yao Yuan <yao.yuan@freescale.com>, Fugang Duan <B38611@freescale.com>,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Kaushal Butala <kaushalkernelmailinglist@gmail.com>,
        Sedat Dilek <sedat.dilek@gmail.com>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 -next] i2c: imx: fix handling of
 wait_for_completion_timeout result
Message-ID: <20150113151601.GI7660@katana>
References: <1419687233-10498-1-git-send-email-der.herr@hofr.at>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="54ZiyWcDhi/7bWb8"
Content-Disposition: inline
In-Reply-To: <1419687233-10498-1-git-send-email-der.herr@hofr.at>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--54ZiyWcDhi/7bWb8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Dec 27, 2014 at 08:33:53AM -0500, Nicholas Mc Guire wrote:
> wait_for_completion_timeout does not return negative values so=20
> "result" handling here should be simplified to cover the actually
> possible cases only.
>=20
> patch was only compile tested for imx_v6_v7_defconfig=20
>=20
> V2 spellchecked this time and proper labeling as=20
>    suggested by Sedat Dilek <sedat.dilek@gmail.com>
>=20
> patch is against linux-next 3.19.0-rc1 -next-20141226=20

The last two paragraphs should have been below "---" but other than
that, all is OK.

>=20
> Signed-off-by: Nicholas Mc Guire <der.herr@hofr.at>

Applied to for-next, thanks!


--54ZiyWcDhi/7bWb8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUtTaxAAoJEBQN5MwUoCm2oRoQAJ4dYIGPvQv3kjFVi3nwpxhq
F0PnNYM+Y5prL7D23KB/DBSsOztepAq9hfFUbpU5OWoVRSDW5wIoHTopBaeb4hWM
wXV6/ks3j1RCisbuOiivZR0+jxhbu+43c/q5qFC0psjnrE3090Qqh4NsR0uTvS1q
ALGYxHKCsKRqCiDfd9C2RBF/nFAwY+H6VxkYcTb9+aqWWQdliRHQqwM4m5CEFSN+
D+yJqMGcKL7t9L5pA3u5gOU2uEndKv3UNKsAu0oQQTqQp+JICtaYeP72sW5jXZKB
wC0srNfLHrmnnmVRZ94oGC/5lL4R/rh5I1XyANfj5GQC+wL+Wm/4EDV9E8icHa8G
vB2SlmXLSPWpkYoB2LMJdkWjUDTG7gSLkH67ay4Vx+s8XvAhiArx8HAezbg7Xo9B
R+L7o5fU1J4LDJnXqAhnpEdx47szbWecmHFUFRIHIZskAugwE9E5MPXAMXiNFEu0
cW4LRdSrCHmJUQiqHfNbxQKVbr5jJtFSu34JKPgZL5vWmJJ4DDNNjYcJhvzpMCpZ
vvyD4uy7AHKrHmn+pDuvISNNa39vPy2+oJ195Vpj1Aqz5qZkAzSLts3uYATejguY
VPuJ5YkeohCAYXnv75b0sYoO56AMLW47KlTI+nJEzQoE7n5XgazUaS+GbrSqm6la
Ga4xJFIM7FNUThjeM/gV
=x4UC
-----END PGP SIGNATURE-----

--54ZiyWcDhi/7bWb8--
