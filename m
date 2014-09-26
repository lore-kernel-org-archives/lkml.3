Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398AbaIZJ0l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:26:41 -0400
Received: from ozlabs.org ([103.22.144.67]:43471 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753880AbaIZJ0j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:26:39 -0400
Date: Fri, 26 Sep 2014 19:26:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Liviu Dudau <Liviu.Dudau@arm.com>
Cc: Thierry Reding <thierry.reding@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>
Subject: Re: linux-next: manual merge of the pci tree with the asm-generic
 tree
Message-ID: <20140926192632.31fb96fd@canb.auug.org.au>
In-Reply-To: <20140926091357.GL841@e106497-lin.cambridge.arm.com>
References: <20140926132902.603fb9f8@canb.auug.org.au>
	<20140926070022.GA31002@ulmo>
	<20140926091357.GL841@e106497-lin.cambridge.arm.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/mc3SRbiOUe._V1GbCX8oVo8"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/mc3SRbiOUe._V1GbCX8oVo8
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Liviu,

On Fri, 26 Sep 2014 10:13:57 +0100 Liviu Dudau <Liviu.Dudau@arm.com> wrote:
>
> I agree with Thierry's solution.
>=20
> I don't know how these cases are handled. Should I send Bjorn a patch for=
 his tree?

They need to be fixed in one or other of the trees, so yes.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/mc3SRbiOUe._V1GbCX8oVo8
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUJTFNAAoJEMDTa8Ir7ZwV94wQAII4XGIyoDbhF5lkr/o683re
0Kc4H7leNKeR3u0mQc71P5xBorb6jRuJ5FSrk0CKOW/zIyZgdgnjYRLALAwE9duj
tfH9Va4YqCFwEahjqcw1W9SSFjWdW6tzEPGoSMPx/46f8ggqdIXol0izVGpezvaR
kD/ebS9gxf3YZPB/PJvrB7NpPZSVhnFRT11IuwAmnpJCU/ZCVVya8CODdpgYZ1yY
Ip6REfEJLp0LDNIeLMNzQ3uz4yp616JO3TRDVCrKWCkYARba9F1xNgX8KuiU1e4F
pCT96pDcIEcZnX9lkfZ5dVFboGCVL9Qn6nteM9Qz0GreIC8yYvVcaFAH7HvNtWtb
5ZF9jidXpc7pYSChBQAomhqheBHTpuL6tC16MV7e2Vdz27AQYfKW8c0XEBB0JYsD
AYjs/aJqaXRaZr5VfMbXZLWxtwWxquCacXFJGZBaKIt/Hl5k2TWUzb7OahxamY5h
vsBnEuXbl2H+VohCiJYd7mgzS6x8FiGsu6UOEUHozRxXan9Vd/nadB6inPlXqKDO
GQO0qh+Ini0HxDKoj6YlFHDUvRrrZKf5n9OwvFaaEWiIE49NEw+RwhmALoetPDMP
bQtAAwwZ72AQNupME6xTNN8MuUJ05nERACZQJ7qil4yAmwH37dTGUedBSJSVaG/O
nt42/ojAFnLMOWMfY+yK
=8Jeq
-----END PGP SIGNATURE-----

--Sig_/mc3SRbiOUe._V1GbCX8oVo8--
