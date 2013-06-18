Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3FRBiJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 21:38:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52102 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab3FRBiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 21:38:07 -0400
Date: Tue, 18 Jun 2013 11:37:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michael Neuling <mikey@neuling.org>
Cc: Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-next@vger.kernel.org,
        Linux PPC dev <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH v2 08/11] irqdomain: Refactor
 irq_domain_associate_many()
Message-Id: <20130618113750.a59f53a3c60efb853e3b9295@canb.auug.org.au>
In-Reply-To: <5220.1371518734@ale.ozlabs.ibm.com>
References: <1371244086-9189-1-git-send-email-grant.likely@linaro.org>
	<1371244086-9189-9-git-send-email-grant.likely@linaro.org>
	<4521.1371518445@ale.ozlabs.ibm.com>
	<5220.1371518734@ale.ozlabs.ibm.com>
X-Mailer: Sylpheed 3.4.0beta4 (GTK+ 2.24.18; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__18_Jun_2013_11_37_50_+1000_+OidcKg.lgo=huyv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Jun_2013_11_37_50_+1000_+OidcKg.lgo=huyv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 18 Jun 2013 11:25:34 +1000 Michael Neuling <mikey@neuling.org> wrot=
e:
>
> Michael Neuling <mikey@neuling.org> wrote:
>=20
> > In next-20130617 we are getting the below crash on POWER7.  Bisecting,
> > points to this patch (d39046ec72 in next)
>=20
> Also, reverting just d39046ec72 fixes the crash in next-20130617.

I will revert that commit in linux-next today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__18_Jun_2013_11_37_50_+1000_+OidcKg.lgo=huyv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBCAAGBQJRv7nzAAoJEECxmPOUX5FE/eQP/Aq9PEpeFjnVHGR4eiCGkeZj
gtJbs9AC/Rz4BKk9RU2ydyxyFp9doEmQUbmks4e9K/1MB2hCztEHlsWAuxnNdE5Z
ZOX0bGRvPELMpCBGI3TKjV4+srVnYpDbbeB3nVpDV0mgnQO9Dzw/lR0trHusao1A
yVtba9Cc4i4ZxS0x34GLnaxRtiovY5qQFS4sqvEm/fAHdkkDJOY+siA+RM56ujKn
OhI7zfX6LVsSYvwgtFCshJx6RK2mJ1iEbvhPTs2XnQ/eOg4dXoG1wrKTPuXKfVvI
8srkMHpL//jdl+h6daAMwSiteo/4mnWI7CTeGmBK05adSYiHyxuAs/JZOa39Bv5V
jbP3hx7WxfjBmmX0coOVOGUyNgxLDY4A2S4bMwFVBiDPLzprjcpJAPDwzVdYWZMZ
eDXIfykbE97P5y8+DpKG51wJaj2IlEEJ1d9s0Ol5ZgX045/1fDxrla5nyxdVXvLR
Hkh17k6LfDL9umezZHPa2BmxWDsRZMirPKvTUkz5JGdD0PbKSdvVpmHG2E6U+PVP
luHHLPvkybSf2QiIQLcIKnT2VAwTlZ1WePAsEuvAInq8v1UvEMK5zlu6cMonqspX
FX9QCJXCQ5A5CFzzLmrfRzOTAo8MwLN8ef1mD06lrndb6oZFFCsXOGIMpyAwMooq
uLwBO5cf3JXdx4/eprgq
=EK+z
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Jun_2013_11_37_50_+1000_+OidcKg.lgo=huyv--
