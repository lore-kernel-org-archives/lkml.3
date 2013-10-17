Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761947Ab3JQCqo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 22:46:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:40647 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761009Ab3JQCqm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 22:46:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,511,1378882800"; 
   d="asc'?scan'208";a="418094882"
Date: Wed, 16 Oct 2013 22:31:49 -0400
From: Chen Gong <gong.chen@linux.intel.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: tony.luck@intel.com, bp@alien8.de, joe@perches.com,
        naveen.n.rao@linux.vnet.ibm.com, arozansk@redhat.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Subject: Re: [PATCH v2 3/9] bitops: Introduce a more generic BITMASK macro
Message-ID: <20131017023149.GA14946@gchen.bj.intel.com>
Mail-Followup-To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
	tony.luck@intel.com, bp@alien8.de, joe@perches.com,
	naveen.n.rao@linux.vnet.ibm.com, arozansk@redhat.com,
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
	Thomas Winischhofer <thomas@winischhofer.net>,
	Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
	Tomi Valkeinen <tomi.valkeinen@ti.com>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
 <1381935366-11731-4-git-send-email-gong.chen@linux.intel.com>
 <20131016140221.6f2299d8@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <20131016140221.6f2299d8@samsung.com>
X-PGP-Key-ID: A43922C7
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2013 at 02:02:21PM -0300, Mauro Carvalho Chehab wrote:
> Date: Wed, 16 Oct 2013 14:02:21 -0300
> From: Mauro Carvalho Chehab <m.chehab@samsung.com>
> To: "Chen, Gong" <gong.chen@linux.intel.com>
> Cc: tony.luck@intel.com, bp@alien8.de, joe@perches.com,
>  naveen.n.rao@linux.vnet.ibm.com, arozansk@redhat.com,
>  linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, Thomas
>  Winischhofer <thomas@winischhofer.net>, Jean-Christophe Plagniol-Villard
>  <plagnioj@jcrosoft.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>
> Subject: Re: [PATCH v2 3/9] bitops: Introduce a more generic BITMASK macro
> X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.19; x86_64-redhat-linux-gnu)
>=20
> Em Wed, 16 Oct 2013 10:56:00 -0400
> "Chen, Gong" <gong.chen@linux.intel.com> escreveu:
>=20
> > GENMASK is used to create a contiguous bitmask([hi:lo]). It is
> > implemented twice in current kernel. One is in EDAC driver, the other
> > is in SiS/XGI FB driver. Move it to a more generic place for other
> > usage.
> >=20
> > Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Thomas Winischhofer <thomas@winischhofer.net>
> > Cc: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
> > Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
>=20
> Acked-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
>=20
> Btw, there's another incarnation of it at sb_edac.c (GET_BITFIELD).
> It could make sense to also replace it by the newly bitops.h macro.
>=20
> Regards,
> Mauro

Aha, I will update it in the next version.

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.14 (GNU/Linux)

iQIcBAEBAgAGBQJSX0wUAAoJEI01n1+kOSLHmrMP/3W3X1viFuwj0oE9gWmcF8S2
K1hwJHFcUZ0/N8VFx87pV0XlNBBR7gtNvHr56pNICgJqoTm4tb4a0ANhb+MwTGob
wDDzbIOE0LF+OCEtFLSwKmQRy40y81gkMivF8AkqXcY+kp8DltZaV2INhTL89tps
0N2mPzgWSxBggIluSEDcSYedRCIEzMzNjWi7eYBwiR4hVq6fzNvFztCGIuYB/HWh
MIJ/HEgVYb59QjKptGm7dNTL05ooqUFwRW2hrNRTI8nvo7TGAKC8jn0x4igyiG/7
6XTIbkVpCVScsVYstO5cazQr81jOWUUqTR86KYwy407Bz0T+6NXleZ/ZExRz+Bmc
i9or0zALjIIUQSIRWw7Hhj0zYMOFfxSDKsfObyUOsX5UXReRbPl4JfwrDGZ3w9B5
mskqGt1glgdGysbV4aLnmxAocKY+zBKp2GRriATi1TLaJajt+orMFxUI2R6W6Ysi
7M562+fEyY4IAk1naIlCoBe07IMndCyW8non/I1AWU0l8yes4CykvPbib9Sf2K/7
ynQlR+NwhbWFX9CTAxlZ3wHDhpBaTBreJnR+DISmIU7MOBl5gMnAReVewDnnNfmP
fVV0DCaxl9ysChsHh1xB13vI2jt0a6O0pD+Oo2aGsrjZCnpntPPWpNFyoQW0yTOF
ScmTKJS3I8lAvoL6uEr+
=AVdC
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
