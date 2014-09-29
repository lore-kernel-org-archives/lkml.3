Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbaI2WuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:50:18 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:42750 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753300AbaI2WuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:50:16 -0400
Date: Mon, 29 Sep 2014 17:49:34 -0500
From: Felipe Balbi <balbi@ti.com>
To: Andy Gross <agross@codeaurora.org>
CC: Wolfram Sang <wsa@the-dreams.de>, <linux-kernel@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>, <linux-arm-msm@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] i2c: qup: Fix order of runtime pm initialization
Message-ID: <20140929224934.GB21681@saruman>
Reply-To: <balbi@ti.com>
References: <1412028051-21774-1-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OwLcNYc0lM97+oe1"
Content-Disposition: inline
In-Reply-To: <1412028051-21774-1-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--OwLcNYc0lM97+oe1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2014 at 05:00:51PM -0500, Andy Gross wrote:
> The runtime pm calls need to be done before populating the children via t=
he
> i2c_add_adapter call.  If this is not done, a child can run into issues t=
rying
> to do i2c read/writes due to the pm_runtime_sync failing.
>=20
> Signed-off-by: Andy Gross <agross@codeaurora.org>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--OwLcNYc0lM97+oe1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUKeH+AAoJEIaOsuA1yqREPFEQALN+xu2qW/Qakr5ZfkZoLsE+
76r3Z1vojmfS/niQBf3fXwW8EEfXqdFPjUEeYCBG6myOVEKU2kGHQTYgGhey1OmK
QVvEdbkZfFgUHSNsq0eGeENP51c/pDR4LplgW22DWZMIedKNnsT55e3wkXbkjzem
OSk8nNn6ijKt2+MHt5kvj+/BLILGfP5myjBpTdVFDZqa790aDBVQHu1onJom0Ucd
LEqK7npPrpxrnRGtyxpOo/PNebGm7dyP8zdXK2f0PKu3WuTAiGEaI8dI3U+hCbDD
3Zm83gytAjWpg60BDAH4L032bxuUOF5Oq4pnUIfbcRZzsmuVukjU2JLQFwIBzhi3
vbSkyL+Spj4HS06L/Ht79dTM+yusp7hCF+u1k+4yeSd3azi6MipeUwzHLUGP9G98
j3PDfyQ8OUyffql5Njvgc6WWgQr8vlctA7LMmw0trBP9FV7Ad2fkm8n38Hg/ORfg
zvFWPdBQxMbGRoYZLWvymgzCEU1HMOFTrh9sCAwVgWkPzd0+PqAQZo1qxBCk/+08
5yNWYm5Ax+fb+1N70OygdEuZOBYf/zmXhQFmMRsN7JVCMCOi44G9VOHd5ZhMxsuX
9k9erWfAbrSIjHBSwWz3B3aVZUVmIJB+T0Dgl9Swk/F1h/kconKNvV5bcBuxl60Q
z6/ASS1w1gKPm0Kyixzq
=2yUl
-----END PGP SIGNATURE-----

--OwLcNYc0lM97+oe1--
