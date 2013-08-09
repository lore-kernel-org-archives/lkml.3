Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967306Ab3HINSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 09:18:21 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57946 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758074Ab3HINSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 09:18:20 -0400
Date: Fri, 9 Aug 2013 16:17:56 +0300
From: Felipe Balbi <balbi@ti.com>
To: Andi Kleen <andi@firstfloor.org>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>, <balbi@ti.com>
Subject: Re: [PATCH] dwc3: Only build debugfs when DWC3_GADGET/DUAL_ROLE is
 enabled
Message-ID: <20130809131756.GB12041@radagast>
Reply-To: <balbi@ti.com>
References: <1375740523-7573-1-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UHN/qo2QbUvPLonB"
Content-Disposition: inline
In-Reply-To: <1375740523-7573-1-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 05, 2013 at 03:08:43PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
>=20
> Fix (randconfig) build problem with DEBUG_FS on
>=20
> Cc: balbi@ti.com
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Andi Kleen <ak@linux.intel.com>

care to show me the defconfig which makes the build fail ?

--=20
balbi

--UHN/qo2QbUvPLonB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSBOwEAAoJEIaOsuA1yqREQ7kP/0eSCLPJoeZJNB9ElkXwT51/
iZsT6u0EOx1nlF1IP5ZlcEKrr+dw+LT1GKRdXAK5oaZvbM7iCQph1Z5uoWCHkRE+
2j1hK+azdy6SevCGDHCFZN4qiI7Lwa8R/4T0ozeudS4IemZ8e+ErUSaOxKhsXTQv
8sDeab9QzD3tep6Z/AdJlrsKTE8ykBNv3Oi7M1mVqZFaxTPnvYpLRgJg4WeCVXhQ
YvI/zBpcOrtx1eAYnAeffxtlqg0eA0BUrmpbvO5nBNuCVK5VsK8hJogdEoy+EQz/
ikqm+vniE23mG7A34x2U+JaXE/0b+MgrOFXGhmkUuYwUJG0Z9Hw4UGR4yRSXHhWl
ILY4r1a5HTMRj1+J7LMv9mw+GSdnAlvbnyjqgYKb2evzblEn0OUs80IYfX3ysCGO
K24RwvhQVBGOSlpHn34FqArQhjuIf+nIEtRvdE+TFVY3wByihJOlTtk2lybhg/T1
fGgxh9TseorqB3O0J5kNfm1OMXu1na4v9N+x2tOK+GqhKiwG4EwhfUuyHpKZ5YK8
T/2qZAbwFxChviushpAlGkKKQOtCwvoGfnN2NNdN12ZKlVj0IPkt175zCik0S6vw
waCpEoSTZ93Wa5RXIj+KFjLTT+Egl7F3EBh+bJMF2O4OPBrqxfvKwnaiIvFHElKw
48UgXID9M2ffo3yQk7ZG
=NfF9
-----END PGP SIGNATURE-----

--UHN/qo2QbUvPLonB--
