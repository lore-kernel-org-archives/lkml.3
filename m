Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935804AbaH0TZ1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 15:25:27 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:44637 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935181AbaH0TZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 15:25:26 -0400
Date: Wed, 27 Aug 2014 14:25:11 -0500
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
Subject: Re: [PATCH v2 5/5] usb: phy: samsung: remove old common USB PHY code
Message-ID: <20140827192511.GI6347@saruman.home>
Reply-To: <balbi@ti.com>
References: <1408726745-31135-1-git-send-email-b.zolnierkie@samsung.com>
 <1408726745-31135-6-git-send-email-b.zolnierkie@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lqaZmxkhekPBfBzr"
Content-Disposition: inline
In-Reply-To: <1408726745-31135-6-git-send-email-b.zolnierkie@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--lqaZmxkhekPBfBzr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Aug 22, 2014 at 06:59:05PM +0200, Bartlomiej Zolnierkiewicz wrote:
> drivers/usb/phy/phy-samsung-usb[2,3] drivers got replaced by
> drivers/phy/phy-samsung-usb[2,3] ones and the old common Samsung
> USB PHY code is no longer used.
>=20
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> Reviewed-by: Vivek Gautam <gautam.vivek@samsung.com>
> Reviewed-by: Jingoo Han <jg1.han@samsung.com>
> Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
> Cc: Kamil Debski <k.debski@samsung.com>

this patch doesn't apply. Please rebase on my testing/next

--=20
balbi

--lqaZmxkhekPBfBzr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIbBAEBAgAGBQJT/jCXAAoJEIaOsuA1yqREtA8P91qAkizr1qs7wr6r8JuOgceP
KXwZGRlBCa44JY81ermTjGwlB19JiQ/LucM6K0ZTgi2HlMUTRVwqxPSHrNtRK/Xc
xZhNMJUkgWZ5aBN09jMgq5pOWGSppwe4/jMXIr2PcWbKpGMXhYv4LFtqx+dQQgDj
HUvZ2YXjeQjQmweQck4HWIziFZLCd+tLGoYktbtyA3PQT2/ttedFDJCkVWw943HL
eNkyS0LEdeKn0EJ2tpxF6dww7V9qdp9USgNgpXxYC7UGaHVHCmG619dZgtbSDU7m
mpHybY1coLG77MOosQBOX8b7fRtlCI2CS8HjBpRamcacjDJ17oUq3wL8vSFjdtm6
uylME3g12ybM7ArS0ZH6Ua2lOJKDf4ObGlXJq3D6IHM1TnEWeMjwtmdK/1+LDPQ0
mexGdTK1EllzMkWwec7qMoI83GcBWXs/BWy3zrGih2gS3xjtWLaRkohnQGne+j+l
7DEzsmi0vE/URB+mVXreGL9hXkNVuiwaQacEEz5eeN43tqm+rXvrYUAPSbffG+1D
3XQkOR46Caz+yxaxIcdz/YHCxCle7ksEr/e9KuDlJWstM+o5lLx3rpEBPQPeXlb9
6MRUiA4PeSk2Q+prmy1OQP5Z5nzQB3o72MmXe4DE3PuhSNKO/Nfsw0w9+wkhYB24
KY31S/nNxYYuz+mQJ04=
=L4rZ
-----END PGP SIGNATURE-----

--lqaZmxkhekPBfBzr--
