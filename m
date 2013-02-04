Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3BDIlG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 03:41:06 -0500
Received: from mga03.intel.com ([143.182.124.21]:57313 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab3BDIlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 03:41:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,597,1355126400"; 
   d="asc'?scan'208";a="252229965"
Message-ID: <1359967368.13791.22.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2 1/3] mtd: add new fields to nand_flash_dev{}
From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Reply-To: artem.bityutskiy@linux.intel.com
To: Huang Shijie <b32955@freescale.com>
Cc: dwmw2@infradead.org, computersforpeace@gmail.com,
        shmulik.ladkani@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Mon, 04 Feb 2013 10:42:48 +0200
In-Reply-To: <5105DD0E.1010500@freescale.com>
References: <1359007901-26464-1-git-send-email-b32955@freescale.com>
	 <1359007901-26464-2-git-send-email-b32955@freescale.com>
	 <5105DD0E.1010500@freescale.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-4CWMzGYPcj9eIFzh/fDF"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4CWMzGYPcj9eIFzh/fDF
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-01-28 at 10:06 +0800, Huang Shijie wrote:
> > +     unsigned int id_len;
> > +     unsigned long oobsize;
> > +     unsigned long ecc_len;
> I think it's better to submit another patch set to solve the ECC
> problem.

Would you please strip the cited text when bottom-posting - this would
be a lot mailing-list-friendly.
>=20
--=20
Best Regards,
Artem Bityutskiy

--=-4CWMzGYPcj9eIFzh/fDF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.13 (GNU/Linux)

iQIcBAABAgAGBQJRD3SIAAoJECmIfjd9wqK04V0QAIe0aP4NYMF7c0tQpkfxBLC9
pi5h4JCrH+zAO/wlWbwCk2r315l/1Pir7OvYvGRU5ygobGYxX1nomL/XHYYxSeoA
D9F2fVr3vYrlCrS43ujw7MEt9ya9mLNyOs2DZESDiL57ikfx2cWfi2qxSSwbQ4zd
7KvP6tGADueRas8LL9TegBSijLD1NgAw2alb0kAFGoRlpSzOp8zHJxOaSSD8K63u
UMMEeP1b7fiLRK5m9xEAoWoZwlSd1VxgT7UBkzZJD7B99kAhq1uuIvwChq7NjFOQ
h2PC2l3NKeyUaF+CdGjI2oJZA5VgzhzpThVQ40h7jtRz/2gxgAcXpndsb42EJPTb
iUHhRG4LdcEuRBZaahwzEmpp2Wo1bc2SqQ47IrvrwTWOnLsOaXwyVEw5vz3avwKb
bnP6gUwYo1P0R+dn1/QrqM4gBJ1lR8RuUOwjtW4WoR6QHAicTLnJem/q+0Eelv61
djpynJMPNsgMDICGr8Ti5KpUXYbkSTDT+VpyLse4IgWuCCcxdFYJSRiwy96f273I
qDoNXfx3H/DF8yGXESq+NW1OElRKaTu7UO1/5Sxm4r5mkLZ6hX4CvgSt+2zStbyk
yjf65BMvtM0NfOw88XXUcmu1nivVi51pn585PHax3JPb5Jhjopl7UQEA9J8MJK4A
Vg5VTGmsNSxJn+LzwiPC
=C/Es
-----END PGP SIGNATURE-----

--=-4CWMzGYPcj9eIFzh/fDF--

