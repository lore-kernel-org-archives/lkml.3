Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaAXR0T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 12:26:19 -0500
Received: from sauhun.de ([89.238.76.85]:46112 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751076AbaAXR0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 12:26:18 -0500
Date: Fri, 24 Jan 2014 18:26:14 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH 30/73] drivers/i2c: busses/i2c-acorn.c is tristate and
 should use module.h
Message-ID: <20140124172614.GF2629@katana>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
 <1390339396-3479-31-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QWpDgw58+k1mSFBj"
Content-Disposition: inline
In-Reply-To: <1390339396-3479-31-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QWpDgw58+k1mSFBj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 21, 2014 at 04:22:33PM -0500, Paul Gortmaker wrote:
> This file is controlled by a tristate Kconfig option, and hence
> needs to include module.h so that it can get module_init() once
> we relocate it from init.h into module.h in the future.
>=20
> Note that module_exit() appears to be missing from the driver, so
> it is questionable whether it would actually work for a removal
> and reload cycle if it was configured for a modular build.
>=20
> Cc: Wolfram Sang <wsa@the-dreams.de>
> Cc: linux-i2c@vger.kernel.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Applied to for-current, thanks!


--QWpDgw58+k1mSFBj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJS4qI2AAoJEBQN5MwUoCm21F4P/iFLNsmv4M04KPpGQH1jpge1
indr5iiLLHnD3L6HwyswYTRBMlV3nIBWro78Dq6ct48bH3+b2EmZOOw0wvUNvyJd
GwRbxACDd3jKLVneCyONj3d+BOQxwt1XwQn222dREZJ47pNq6mAHz8GVQO0oOFLX
xS08rvqnlwak+eB0AcVA9CisG/x33Ia9YV8zMq9EK7nCYaIpLNbwcOAD8slFBO9f
2SaOEu7l5eVtDDTki/XMM3VrNXTctQyxinqkA0A+ebcltqrpKy+ni1hLPCaz4ckP
Ex9lCYUsSsSVFeRGLSE5gei6T9JFsFXt6d58rmxsOcof6GGVXSFRP22otgTYzbPo
1TmZeKSccFF5Ers/xSTIUGWkif1WIhc9OiNB3fQ855A4wcExCZAy2M2oED+GV9LU
pvGsyu+v+Rrfact/MgW5t/KNo2WJxX4XazYEHOXWeut5g8XA2XwzG9iiC1ANNkim
114Txym+qjdIyKFQVrHsad0FPFv+jbC7zyOg3VI/kLvQtqRNQI9xhccLjusYxEjF
fjnvRekcZJNkPUb+dy37CQT5fdjsLh0Dr5f3/9ezDPOoLeIm2Q4jUo9LFGH75GlL
1ormRtQp71CRY6O39HdkcpfUhMZaI39vhhOoZy7SHyIJB5qIfOT6eqUInWDpWbNd
QeuFcPlHHvPtjUVMzzyj
=SPf3
-----END PGP SIGNATURE-----

--QWpDgw58+k1mSFBj--
