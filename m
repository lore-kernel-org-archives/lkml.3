Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751458AbaJOSyS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 14:54:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:33134 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116AbaJOSyR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 14:54:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="asc'?scan'208";a="400828286"
Message-ID: <1413399256.2412.27.camel@jtkirshe-mobl>
Subject: Re: [PATCH] bcm/CmHost.c: Fix noisy compile warnings
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: Joe Perches <joe@perches.com>, devel@driverdev.osuosl.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 15 Oct 2014 11:54:16 -0700
In-Reply-To: <CAOMZO5C5ya=OgBUEOOM+tZE7B2zZ3J05PHC14t3Tp6nXkPYmoQ@mail.gmail.com>
References: <1413375999-10210-1-git-send-email-jeffrey.t.kirsher@intel.com>
	 <20141015123431.GA23154@mwanda> <20141015125934.GB23154@mwanda>
	 <1413378213.2412.13.camel@jtkirshe-mobl>
	 <1413389496.7484.3.camel@perches.com>
	 <1413394958.2412.23.camel@jtkirshe-mobl>
	 <CAOMZO5C5ya=OgBUEOOM+tZE7B2zZ3J05PHC14t3Tp6nXkPYmoQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HTeNut76osI5Cx/OnVqn"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HTeNut76osI5Cx/OnVqn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2014-10-15 at 15:24 -0300, Fabio Estevam wrote:
> On Wed, Oct 15, 2014 at 2:42 PM, Jeff Kirsher
> <jeffrey.t.kirsher@intel.com> wrote:
>=20
> > I like the idea, but won't this exclude other 32 bit systems like MIPS
> > and I am sure there might be others.  I could assume that Beceem WIMAX
> > was intended for x86 arch's that are 32 bit only, which may be a safe
> > bet.  The only thing we know for sure is that is broken on 64bit.
>=20
> What about this?

That works for me.  I am putting together a v2 patch now, since you came
up with the change, I will put you as the author Fabio, ok?

>=20
> diff --git a/drivers/staging/bcm/Kconfig b/drivers/staging/bcm/Kconfig
> index 8acf4b2..fa5a3a4 100644
> --- a/drivers/staging/bcm/Kconfig
> +++ b/drivers/staging/bcm/Kconfig
> @@ -1,6 +1,6 @@
>  config BCM_WIMAX
>         tristate "Beceem BCS200/BCS220-3 and BCSM250 wimax support"
> -       depends on USB && NET
> +       depends on USB && NET && !64BIT
>         help
>           This is an experimental driver for the Beceem WIMAX chipset use=
d
>          by Sprint 4G.



--=-HTeNut76osI5Cx/OnVqn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCgAGBQJUPsLYAAoJEOVv75VaS+3OmpIP/RN4s+rNit349CDegbPpv/Ju
3HGvss0/iUw/w+vBspkHFb73ISS/5pemCsLvqvp8viHMBtoSJZ4OX8lf7f4eRd+a
MRBYP1WcMYkUQqGElkLYz8D1H3KqpratfiKc8RSGe5hhV/RDRoDuh6Hyew7Fw4/f
xntTVnJBJsV9Kl8Iccddz0F/x9j6iaOn1yl/hv/UK+HGO52065cu0uoTv8GceqLz
CpUnPAj4+S65t4C4ePuhEjSqxv2C8eUVPvcqbprnPY4T48yCLbxVj5jsD55IT1gk
6KlldMpvI3D6+PIrUoGVSDFRMIYZfnBVjdiJFJ61qYI4gUtr7KKxUoTI3hdNcA/K
BHEMS0Z0vH85ZYPjtgSxVuhfiH6cHrf3ecaoiI2U3JQasrBjj50p+4RqWN3wTrv9
Vj2tV0PaMhJqbSVH23J/buObmeQKOEEBdFqD5Nw2PlXuSa7a3vq1ApQntMyJo+PI
DTPKuD5vqHPn8TaeHVB2HNXMAtPOqW8GFnoXoE3eDWWS8TtaX9LBzO3PkBmXuXLp
6iXfQ3NU3mL5WdkiUJVoEgOakHgMyNYYWzsQ+u1JZRQELTLnPMHas1XJ9TaHIQwN
EB2JPK6x4FXI7uRsZbJUDdpzLYExctSmwIggk6Nv6/11gwnlI4dM56qLaOIibJcH
gxdEI9yzz04YXgkMmYO9
=iLvr
-----END PGP SIGNATURE-----

--=-HTeNut76osI5Cx/OnVqn--

