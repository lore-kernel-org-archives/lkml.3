Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935276Ab3BOAXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 19:23:24 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:48068 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935133Ab3BOAXW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 19:23:22 -0500
Date: Fri, 15 Feb 2013 11:23:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: Joe Millenbach <jmillenbach@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: linux-next: Tree for Feb 13 (virtio_console)
Message-Id: <20130215112313.f0952009747b754447fc45c7@canb.auug.org.au>
In-Reply-To: <20130215000229.GA5164@kroah.com>
References: <20130213193532.162080d7c0557a307ab451ac@canb.auug.org.au>
	<511BEC55.5090801@infradead.org>
	<87sj4zk3ai.fsf@rustcorp.com.au>
	<511D30B4.5020201@infradead.org>
	<511D330A.2050407@infradead.org>
	<20130215105519.1d8de65d4f9195eeb9306c13@canb.auug.org.au>
	<20130215000229.GA5164@kroah.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Feb_2013_11_23_13_+1100_4Vyh+zD24/85Dxzw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2013_11_23_13_+1100_4Vyh+zD24/85Dxzw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Thu, 14 Feb 2013 16:02:29 -0800 Greg KH <greg@kroah.com> wrote:
>
> On Fri, Feb 15, 2013 at 10:55:19AM +1100, Stephen Rothwell wrote:
> >=20
> > The patch below is needed in the tty tree (which introduced CONFIG_TTY).
>=20
> Ok, now done.

Thanks.

> > Also, has someone checked to see if any of the CONFIG_ symbols that had=
 a
> > dependency on TTY added are selected anywhere else?
>=20
> Joe did all of that I think.  Joe?

OK, good.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__15_Feb_2013_11_23_13_+1100_4Vyh+zD24/85Dxzw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRHX/xAAoJEECxmPOUX5FEJCEQAIBEeLs9OM3xFb3c3AlcRD9p
soMyGJt87Z9mdLoOiSuEMSAZQp9xfjafNrRtUxC+yx7BnXX+KTO7pCtiMH7mgSb+
s8oiNlZIHGgxUT6sqQJL2/W74rHjcGmwUec0quvjHszw6yOgyTJw+OD0xcSJMNj+
e9bXa3vmSO9TL4gTtNFPQjO31hCwtgsbDTJqeH4P6m/qHpSicu1JT7or+s1V/w/P
91Deh/ifDWEmNX1uWUb3ec0H6Qe4MhUE/zEv9l+PPtDJ65Ih61omyvoDZZ4JkLT6
qXzFmflc8RG+ol9NbzulpQGqrODRwTH/CXTZ0RwrrPf7mcpBHqbEBQ6qxQzrB+1Y
QZCrHLtq5fXLd82hEf2ZtkjOADMYU8/cfBqLddpHCVKKX+EzPYhqBE9o47OgQfZh
bb5Ifkf7EmV7VNObeLntfYiwVoISZUYT/Jj29TM5VT2BZwYF202bkIFz0SEREFp4
Y+e3RWCdsyvKGn4n4qDcrjO36833NkTZgtXHCJ0aPLvkpTe7AxLTYb+KI03+Oy0U
5WHO1CeM079sq+riF/LDuOtWuZ98fYyXkSJ8lEHpOgbl6u30LcIXfdJeLdQK/1BC
ATzPGLPaqMe/VQvchmYjt5QB0vytVLpnyth7vl4PAhq3FcfWZW6ShV96EGQRJJ/a
8dyPgmCNG8CzfZNaujX+
=9R8R
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2013_11_23_13_+1100_4Vyh+zD24/85Dxzw--
