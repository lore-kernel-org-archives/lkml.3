Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3IRQil (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 12:38:41 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:33082 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612Ab3IRQik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 12:38:40 -0400
Date: Wed, 18 Sep 2013 11:36:49 -0500
From: Felipe Balbi <balbi@ti.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
CC: Javier Martinez Canillas <martinez.javier@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, Felipe Balbi <balbi@ti.com>,
        Tony Lindgren <tony@atomide.com>, Anton Vorontsov <anton@enomsg.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <freemangordon@abv.bg>, Aaro Koskinen <aaro.koskinen@iki.fi>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH 1/4] usb: musb: Call atomic_notifier_call_chain when
 status is changed
Message-ID: <20130918163649.GL21559@radagast>
Reply-To: <balbi@ti.com>
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com>
 <20130918133025.GB2953@amd.pavel.ucw.cz>
 <CAAwP0s0nGthkm9Bp1ug23Rtz6-sbR60FFTSfd-Cj9wKMU0RBEA@mail.gmail.com>
 <201309181756.12782@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VBq/nvTu32OVLBUP"
Content-Disposition: inline
In-Reply-To: <201309181756.12782@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--VBq/nvTu32OVLBUP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2013 at 05:56:12PM +0200, Pali Roh=E1r wrote:
> On Wednesday 18 September 2013 15:57:13 Javier Martinez Canillas=20
> wrote:
> > to split the patch in two since the patch was solving
> > two separate issues
>=20
> My patch does not solving *two* issues. It is *one* regression=20
> and both parts of patch are needed for fixing it. Read commit=20
> message again. It does not make sense to split patch fixing kernel=20
> regression into more one line patches - or please clarify why.

issue 1) twl4030-usb.c doesn't initialize atomic notifier head
issue 2) musb doesn't call notifier chain

do you need a drawing ?

--=20
balbi

--VBq/nvTu32OVLBUP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOdahAAoJEIaOsuA1yqRE3DEP/jghJ8vczhUc/02pY/gikq8K
dP1JgjgcVUyEjXqgqk+ISSFU1psVrMRZoY3NNDPxLWxkNMcWMdhQ+yHCuUqV0dyh
56okmvdDSu8wqv9yLbV8pNUqSu/FKEdArEewCahgj9AW1ZcJtnm1Mi5d4DJpN1St
yyEamsoBt/K0C4V4/TszjcYeT2lPCAmHc21JT8K1hENrb48fGzooPVOqfC311l4v
zZnznKx20tq5Qq/iAjYdQ4YN9Na2igO69ohoM9CNSO+IFjKpUqrAAtl3IbjMXKO1
0GSo7KfBqZaKTWu8Jg/pUn1QmKS/iyx5LivRWyZH/yT7y5IPRUCw1FQcH26hV/1y
Un9b6mcUW53t5dQgxry13Nf9Vjvg0VDb/BN3gaVKvrRV4ovlqyvAmsca4aQhIVBw
6oXLC8+dPZ0d8wnn9T4ILCD7eWooi6O14igAUfrXIUBn5sehNbfXvcfTq6Tvb4sT
29x0NiH7uZCEHUSc8VZYFRARSvAahs50NrXtppXf2EZbO7T8wwt/cVJf9BnNSPoo
N8Q3I33DdZlcnuL3TCRQJeBJPtGl2GfD6rGHkQyuLwK1PMipVvke/75A4Yl4Qe2R
WrUXJwuSu8c2DbELUyvDt9F1h82Li6dYuAtMrGbL0HViuKyACVQ+DB3kKr3JMpyT
wDMHbWZKlxNHfjI79rHT
=jUdC
-----END PGP SIGNATURE-----

--VBq/nvTu32OVLBUP--
