Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934436Ab3CNAVr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 20:21:47 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57083 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754015Ab3CNAVp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 20:21:45 -0400
Message-ID: <1363220493.3937.97.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 008/153] powerpc/eeh: Fix crash when adding a device in a
 slot with DDW
From: Ben Hutchings <ben@decadent.org.uk>
To: Michael Neuling <mikey@neuling.org>
Cc: Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Gavin Shan <shangw@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Date: Thu, 14 Mar 2013 00:21:33 +0000
In-Reply-To: <5857.1363130238@ale.ozlabs.ibm.com>
References: <20130304033707.648729212@decadent.org.uk>
	 <20130304033708.479195432@decadent.org.uk>
	 <CAEjGV6z-d2f6G_bozJmaeg7pmK71uM_JjBZ24KgijnjO1wv+4g@mail.gmail.com>
	 <1362713395.3768.466.camel@deadeye.wl.decadent.org.uk>
	 <20130312181457.GA24837@oc0268524204.ibm.com>
	 <5857.1363130238@ale.ozlabs.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-/6KrW7S/dWs2tpz7BIs+"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/6KrW7S/dWs2tpz7BIs+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-03-13 at 10:17 +1100, Michael Neuling wrote:
> Thadeu Lima de Souza Cascardo <cascardo@linux.vnet.ibm.com> wrote:
>=20
> > On Fri, Mar 08, 2013 at 03:29:55AM +0000, Ben Hutchings wrote:
> > > On Fri, 2013-03-08 at 13:51 +1100, Michael Neuling wrote:
> > > > This patch is breaking the celleb_defconfig on powerpc with:
> > > >=20
> > > > arch/powerpc/kernel/of_platform.c: In function 'of_pci_phb_probe':
> > > > arch/powerpc/kernel/of_platform.c:95:2: error: implicit declaration=
 of
> > > > function 'eeh_add_sysfs_files' [-Werror=3Dimplicit-function-declara=
tion]
> > >=20
> > > In 3.2 this file doesn't (directly) include <asm/eeh.h> which is wher=
e
> > > the definition was added.  In mainline it does.
> > >=20
> > > Assuming that this change is actually required for 3.2 (which I'm not
> > > sure about), I suppose we just need to add the #include.
> > >=20
> > > Ben.
> > >=20
> >=20
> > This is not required for 3.2. The patch that *may* have broken DLPAR
> > (39baadbf36cee3ede5fdb8a34006d9109e5e2570) was introduced between 3.3
> > and 3.4.
>=20
> Reverting 066f289835f09a3f744d6bac96f25e25d20b3ded (from 3.2.40) fixes
> the problem for me so I'm ok if we do that instead.

Thanks all; I've queued up the revert.

Ben.

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-/6KrW7S/dWs2tpz7BIs+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUUEYDee/yOyVhhEJAQoo1BAA04UJmEord89jXYExN4z0yZq/C1GCUmcu
lf0e5gzM7etGtAYSmZB94CXU5HXpAIZQEwpQPF40moEVqHwuM9hIWdUET9OLYqep
wVeW2HyrjByQz3xnVdaosW0lvBAnv/U+FlGS+21UCZZTB9X3+KK9eXS4vGq/gcvP
MPaa4+1VgaUoJMNfP4HGj2mt+JyybBMmdyyNzabGoR/DybQUZ38EY77x/2b/xqxn
todTzT2p8uWol2wb9o9Yi479vhLZ0JRwJlvCHy6flZvHeatoqH7dFx+ujxSEzjID
rlaDRjYFK85FtyMz/PXaquUIoIVYExX7qsmTHxt9tLasCzO+Iaa9+zA6I/5orPA+
Y67ikglbGRvco/TjMERQD9LCqSTb8BqXGAnZ6rKbbzC1CkRdx2ILoUwEs5Ul1GWi
Fpjg+ymVTbk+Yl6FdTsnGoghAxAGLNRYHw+j1OAk/cYZnLAE6nX7lqt+ClGMD9zS
T3kfJJk7QLbG54h+ksPbsPuTK/xXE8gXGo9GQ5HvlgRI8UAc7j3Ii4V/y12QxjZg
A/rjUH8g9Bu6q4Ulxbzn50JO0wxsGM1dR7QiOWPFiLVo/WM3eFlXKl/f+/pzpNAm
MLrQ5e7Qicqn/QVvisZNP7yQcmy/W0jhAKwSyQmXZxeGV2dZXB4Z779iNAXq6UGW
JQoaeJ1/BTk=
=h3QJ
-----END PGP SIGNATURE-----

--=-/6KrW7S/dWs2tpz7BIs+--
