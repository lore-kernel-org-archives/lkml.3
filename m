Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755417AbaIQNPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 09:15:00 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:52531 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbaIQNO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:14:58 -0400
Date: Wed, 17 Sep 2014 08:14:42 -0500
From: Clark Williams <clark.williams@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: unify boost and kthread priorities
Message-ID: <20140917081442.60425e2d@sluggy>
In-Reply-To: <20140916204156.GP4723@linux.vnet.ibm.com>
References: <20140915100524.2cd80d2e@sluggy>
	<20140916204156.GP4723@linux.vnet.ibm.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/_cOrZgs4LzXCFGqytEPX_Qy"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/_cOrZgs4LzXCFGqytEPX_Qy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 16 Sep 2014 13:41:56 -0700
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> On Mon, Sep 15, 2014 at 10:05:24AM -0500, Clark Williams wrote:
> > Paul,
> >=20
> > Here's the result of our conversation Friday, regarding the per-CPU and
> > boost priorities:
> >=20
> > Rename CONFIG_RCU_BOOST_PRIO to CONFIG_RCU_KTHREAD_PRIO and use this
> > value for both the per-CPU kthreads (rcuc/N) and the rcu boosting
> > threads (rcub/n).
> >=20
> > Also, create the module_parameter rcutree.kthread_prio to be used on
> > the kernel command line at boot to set a new value
> > (rcutree.kthread_prio=3DN).
> >=20
> > Signed-off-by: Clark Williams <clark.williams@gmail.com>
>=20
> Thank you, Clark!
>=20
> I queued this, porting to rcu/dev, which resulted in the following
> patch.  Please check this to make sure it still reflects your intent.
> In the meantime, I will start testing.
>=20
> 							Thanx, Paul

Yes, looks right (and you fixed that I didn't have it all under
RCU_BOOST).=20

Thanks,
Clark

--Sig_/_cOrZgs4LzXCFGqytEPX_Qy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUGYlLAAoJEEersVlSw9Nz3kEQAJ53xCpJf50nj4+JdQMMh+NR
RuJZyTIh6Mtjlp5g4AVb0ShGhRWst/QcgzewTtLvr6bsmzXmkA6uXxUPRCHrFTst
gA3iZCZYT6Tt6oVPfRUSawqu2KTM0AxsqmMesA9a0Z4c67G1TdmtNnpCX7Uq/uJ7
P1o8nI7bnqzDr9mEVVVkeApLWfYIQuDe/oDYk+7JPZ4Es9GUNG0TkfyRy86EFNQv
Pfg52wVu0fcLrHw4j1YvVt/8qBG/OgynmhB0W9xfioLzgsRquOhzYsNNYHdJ+vXb
KNgKN+QP8XNJec5dxk7HLvEYcx62oPX4Wj8GL2Q24CgQ8cuI76znkJrXMFG5mQKo
cuYhb6XPOjHhUN7Sf+bkoYgllBGTKZ2QY/yYxVlUMC26xkzxJI6xsikBnUXM0msu
ARcAaLT7Y8oHc3vKBfS/D+qa2gNok3QFdttZ53yWmDTvqDXCENuE3jNAb2i+Xglq
7NraOQN/oUvyJ2veuEOOF5R/qnX3SgO7g9L6MsXv57oJ+r6Wpzi8JelLNPv0WO1q
tlEy6KJISnTnrmpwFRlh+jqrQTTuN7qezjkd5YN3/5477gbidIsub/vZUky4RQcl
2fkzJoIzxaesdBWzjwcwSlBEVScK2LMyAr9Sj+UDIoz9qy1cpWg+cQwlMGiXVrYN
IzowTH+vj7nvemjGb/kc
=ynbl
-----END PGP SIGNATURE-----

--Sig_/_cOrZgs4LzXCFGqytEPX_Qy--
