Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266AbaGVK2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 06:28:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:40578 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751272AbaGVK2g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 06:28:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,709,1400050800"; 
   d="asc'?scan'208";a="576922777"
Message-ID: <1406024914.18280.59.camel@jtkirshe-mobl>
Subject: Re: [PATCH] i40e: use global pci_vfs_assigned() to replace local
 i40e_vfs_are_assigned()
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Ethan Zhao <ethan.zhao@oracle.com>
Cc: alexander.h.duyck@intel.com, jesse.brandeburg@intel.com,
        bruce.w.allan@intel.com, carolyn.wyborny@intel.com,
        donald.c.skidmore@intel.com, gregory.v.rose@intel.com,
        john.ronciak@intel.com, mitch.a.williams@intel.com,
        linux.nics@intel.com, e1000-devel@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ethan.kernel@gmail.com
Date: Tue, 22 Jul 2014 03:28:34 -0700
In-Reply-To: <1405993851-24375-1-git-send-email-ethan.zhao@oracle.com>
References: <1405993851-24375-1-git-send-email-ethan.zhao@oracle.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-To50B+pDlOsK7ZpwkSbR"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-To50B+pDlOsK7ZpwkSbR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-07-22 at 09:50 +0800, Ethan Zhao wrote:
> There is global funcion pci_vfs_assigned(), so use it instead of
> composing
> local one.
>=20
> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>
> ---
>  drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c |   31
> +-------------------
>  1 files changed, 1 insertions(+), 30 deletions(-)

Thanks Ethan, I have added your patch to my queue.

--=-To50B+pDlOsK7ZpwkSbR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJTzjzSAAoJEOVv75VaS+3OUhUP/Rkti/SLyuGsGQkG+U6+yo7a
807REHWrxFw9eBQY/XwLXuw+GMRCM33nF2NihmbOHfBpVovnv/47w4k+ROGHGviq
eqONZx0JxjKwgVL96cJR1Jyj15XIUPT0u0H9QMdxkgB1pn/hChlvt8S3GbIRf5VA
i586LCMas2+W5z5Bn9HMOKq6rnLEKJbirkKIAs0yYOMSNkpVOX7RDcB1Ohy23Wxg
IZdREzhx2Zo1Kz3UubjxM7nWYdsR2BMs/0sFrGMXFMvQ9B3okzL48euy8Y58CHHf
jJf0XvllJH5XV7UMYt2frzj/SE3eGhx8gYE/hsLy35pxjM85npmWJY8pwzZABk6J
MnqlHTJppmdr+bCin/jCwENZforF+4d7tHdiCIg9wtWZLPSzvBaUR2926Pm1TMfX
gftXrvHbBhvEYKdQNxJ1hXiTYoH0QGkd6Bb3vI6Dl7/rHpkgpcndg4H0mveeATlT
fYSGtB4F5ux4NaomSlacHsRrwiXYgEGbI+XAFACF39Gjc1ce7oJQ0PRI9JdtipL1
5FYwo7OQVnC8bNAyadpuYEJMjL2QsyE8lmHl+j22Rb0MmIjv90invtbDPzaDr69s
KGc2NlD4jdH8G8xxLr5qBeMf3Fjj/myJXgSw1isB6Q/vWzFUoiZklNKc5cZlzq+X
sNdypguBVfc4UXsC5eUg
=2CEa
-----END PGP SIGNATURE-----

--=-To50B+pDlOsK7ZpwkSbR--

