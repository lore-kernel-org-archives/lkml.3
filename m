Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab3BFQim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 11:38:42 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:42775 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755670Ab3BFQik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 11:38:40 -0500
Date: Wed, 6 Feb 2013 18:38:00 +0200
From: Felipe Balbi <balbi@ti.com>
To: Yuan-Hsin Chen <yuanlmm@gmail.com>
CC: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <sarah.a.sharp@linux.intel.com>, <balbi@ti.com>,
        <Julia.Lawall@lip6.fr>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: Re: [PATCH] usb host: Faraday FUSBH200 HCD driver.
Message-ID: <20130206163759.GB9952@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1360149841-2392-1-git-send-email-yuanlmm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MW5yreqqjyrRcusr"
Content-Disposition: inline
In-Reply-To: <1360149841-2392-1-git-send-email-yuanlmm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--MW5yreqqjyrRcusr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 06, 2013 at 07:24:01PM +0800, Yuan-Hsin Chen wrote:
> From: Yuan-Hsin Chen <yhchen@faraday-tech.com>
>=20
> USB2.0 HCD driver for Faraday FUSBH200
>=20
> Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>

just use ehci-platform.c and avoid the duplication

--=20
balbi

--MW5yreqqjyrRcusr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJREobnAAoJEIaOsuA1yqREj6YP/2zleSLqC7PBb76pTCudZr1B
0GzlQMoibws69v6iaHPvLoW2pLjmA6pU+F8NUIPGdg89UmcTQAoe/BjcDORtQ9yM
52DXchnsID6gTSoIE+3TTnhouM1SaQ/ICfh3boqWO+C0AfjC0y24IaDVo2taNreS
iv8ZULiobCVrSZ1KHPXO4CkgTYyfV4HWUgrWOuXnLySg3wWwkqtrqlp38mCOlPxi
vOD9oYUsQ8ujyWoGlp4lcMqHvcJStUTeOsJ3e97jpDBn0SvSbqVgXdZCRRf6sdnD
i4WrjX6QdeWyOk3tUVBIPtqphLgcm+Aql77btHBWz49g11cyzKy1Vq9YsdtbwbCy
KrEMng7Un3vZKjF6ySNnwsE5nnm/9J1A/64osmtJH655mFI9hX68EOuAbTW+e9Mr
NdanprNAtwh50f9ABmPhdaUci63J+zx7Zwy1hQBtOHSgZbw1gqrGq0SgkfyrlEHr
965cUlDxc7ybsaBGzcMMq+8LM2YJ9u0T+a0oUmqJpFnmDndXRBirZt9ZITDwnZMw
evCswTWOkNHR3ivcDwEOteOT+n03Q0V5K/vDsgyM0EF3jLhgiIe8m0LLSGt6wAEO
e18vex/8Sbc+6o2+vWr3weTCNLjsObetqr4Ytao5tkKFLD1eng7Zz8zd8u8PFK4e
gdMXV+umB6EauouMyrbu
=tXjc
-----END PGP SIGNATURE-----

--MW5yreqqjyrRcusr--
