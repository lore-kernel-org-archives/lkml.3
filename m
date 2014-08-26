Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757443AbaHZKwO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:52:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54985 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754359AbaHZKwM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:52:12 -0400
Message-ID: <53FC66CD.8040800@ti.com>
Date: Tue, 26 Aug 2014 13:51:57 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>
CC: Thomas Winischhofer <thomas@winischhofer.net>,
        Joe Perches <joe@perches.com>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/7] video: fbdev: sis: delete double assignment
References: <1408818808-18850-1-git-send-email-Julia.Lawall@lip6.fr>	<1408818808-18850-7-git-send-email-Julia.Lawall@lip6.fr> <CAMuHMdVERt9XBN5OW8QqT_PvQVHd6xgnCdjRpiSNp7ZSEgXWSg@mail.gmail.com>
In-Reply-To: <CAMuHMdVERt9XBN5OW8QqT_PvQVHd6xgnCdjRpiSNp7ZSEgXWSg@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="T2Q2smw8R0tGaR5Wc58vTFK68lTM1xOCf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--T2Q2smw8R0tGaR5Wc58vTFK68lTM1xOCf
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 24/08/14 21:21, Geert Uytterhoeven wrote:
> On Sat, Aug 23, 2014 at 8:33 PM, Julia Lawall <Julia.Lawall@lip6.fr> wr=
ote:
>> ---
>> The patches in this series do not depend on each other.
>>
>> This changes the semantics of the code and is not tested.
>=20
> Hence I think you should change the subject of the patch, so it's obvio=
us
> some bug is fixed, e.g. "video: fbdev: sis: Fix double assignment".

Well, to me "fix double assignment" sounds the same as "delete double
assignment".

Looking at the code, I think what's done here is "fix 1280x768 panel
timings".

I can apply this and do the change to subject, if nobody complains.

 Tomi



--T2Q2smw8R0tGaR5Wc58vTFK68lTM1xOCf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT/GbNAAoJEPo9qoy8lh71lGAP/Rcvke/rHdDgVTiB688BVQZe
R/2N8CI8g62eAgmQs7vQOh78tchDDy+1Yw3VM/hUTR/Y0pM9FHSl2w5GuDvphotG
Ez7cYMWl3iPafrsSh+y4tCypKPLGW2NZeayID4DsoX6PKpa8HRgnbGNDW6pQMpZs
wWxhQz30qJ+TBglPp9uHrkzC5N2xOb/mhA7DynmiX57SFiq+zHNAY/Dgo1JFwZRH
lSiLBqnHaFMklz9Cag5BgZecss09nGzZH6Hgd3n5V84hIoYkcmLTb1qt+vS8/QPu
pYdhRRF+ZT23p8Dh6RO4U6h+Jzzsc3s+DgjdTd7gJ3wDZJtZoAleIPfMwa1mAi3f
dUpE2HYCOLZ60XuARtG0hkz3/SlJLNa4lxQeipZgbeHNJwfckXibohytzTvB2yvx
flYz0eU7ICZiCaF/waf2xe5rzVDN615X9C6o4saUya0hoeNe55+WlmQ67Z2U19EI
KP4kkZK5aur2t1cKVuRnN5YWIsI7NrAfu7BgnSvurFsTyymv23+Jo24lLezUDcG/
KnzBFB+HYlgBnp3oFzFB0X4RcnO7zxpQv34rJxABdsfLCmNV+ugjmzK4gircutHv
D2gCcs71RziZpNPqBrLqKR+06Ao3k5TAgu2lxOYq55F2LHqWz3M6IsJbs2drnz73
f3w1Q4gxb7AI4Bx25rm9
=LHS9
-----END PGP SIGNATURE-----

--T2Q2smw8R0tGaR5Wc58vTFK68lTM1xOCf--
