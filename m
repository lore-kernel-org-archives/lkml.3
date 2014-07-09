Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754069AbaGIByQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 21:54:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55641 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751150AbaGIByO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 21:54:14 -0400
Message-ID: <1404870838.26540.30.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 099/125] mm: fix crashes from mbind() merging vmas
From: Ben Hutchings <ben@decadent.org.uk>
To: Hugh Dickins <hughd@google.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 09 Jul 2014 02:53:58 +0100
In-Reply-To: <alpine.LSU.2.11.1407081420220.31914@eggly.anvils>
References: <lsq.1404846110.431506873@decadent.org.uk>
	 <alpine.LSU.2.11.1407081336180.31914@eggly.anvils>
	 <alpine.LSU.2.11.1407081420220.31914@eggly.anvils>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-3BpP93fgemkJSk8/Lu+w"
X-Mailer: Evolution 3.12.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3BpP93fgemkJSk8/Lu+w
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2014-07-08 at 14:26 -0700, Hugh Dickins wrote:
> On Tue, 8 Jul 2014, Hugh Dickins wrote:
> > On Tue, 8 Jul 2014, Ben Hutchings wrote:
> >=20
> > > 3.2.61-rc1 review patch.  If anyone has any objections, please let me=
 know.
> > >=20
> > > ------------------
> > >=20
> > > From: Hugh Dickins <hughd@google.com>
> > >=20
> > > commit d05f0cdcbe6388723f1900c549b4850360545201 upstream.
> >=20
> > I don't think that's correct, I can't see a change to the
> > "vma =3D check_range(" in migrate_to_node() which 3.2 and 3.4 trees hav=
e.
> > Does it build (without warning) with CONFIG_NUMA and CONFIG_MIGRATION?
> > I expect this version I sent yesterday for 3.4.98 will be good for 3.2:
>=20
> Hah, I now see that 098/125 in your series

Which, for anyone who missed it, was commit 082708072a42, 'mm: revert
0def08e3 ("mm/mempolicy.c: check return code of  check_range")'.

> removes precisely the "vma =3D "
> I was calling attention to.  So all should be okay and you can ignore me.

Right - of course I'm assuming that the reasoning given for that revert
is valid for 3.2.

Ben.

--=20
Ben Hutchings
All the simple programs have been written, and all the good names taken.

--=-3BpP93fgemkJSk8/Lu+w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUAU7ygvOe/yOyVhhEJAQri2A//SymUt0C4aok2KaFDpUKmqaG6bmuVilf0
Ydt2Toa0D5Ii0Qsh/vf2Jtqpp3GmairKfr0fNClD9LzQ6Za1Bh1+TcoJ4HqoI8TG
gRlW/vxF7wWYUS4uzk0DOpvMH0V7zcGgSAhdUBHw0Ffz7GyXrykFM6p8JtFVzlP4
xgLjKhn78v17LFB/WRKNmNf18Mvgegxy5olfGlLXcXVJywVq7MjlBdXrbBHzQ5mB
TjynDmR5SF3BYOMCRMwa6SjF6b9IOFMrgosO5811MOJensBDuFAOmzr1Vg23PrBA
2jDftGR8q4m7yYwxp+haah5JWcuV2ETzzVCFXoKVu/7+zS/Atri8ixAjcfoSxbL5
xEJARaurKI8vDWmwGqD76thi7t3l5KMQIoA8FIdZsedRW0xybmC8etwTiyjNSOGY
nlkbHAeBVqlYNMyAI1oF+VSHWveQHMGiX4uALf+dOke4pINGtJKflZaDjjIz44IZ
9mBwksD5D7iO0mycutie7wQFHHZpD8GZcXboq2vqWacgHBBQJlTEQymHrZyqYQtk
k95F1HhRGATIqjFnMw5FkXjPw/Hlb4GQiXgFztlPvX+v70nt+smy/hfI2X4bEl5n
17DqA1s82DQmCnNOFb11CAt7ojrRB3/z8AVbqDQKmHCa4UTK3AFUDqaNGNqt4TVF
KdECzNNr6wo=
=n3UH
-----END PGP SIGNATURE-----

--=-3BpP93fgemkJSk8/Lu+w--
