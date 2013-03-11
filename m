Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323Ab3CKW1u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 18:27:50 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:53171 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753234Ab3CKW1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 18:27:48 -0400
Message-ID: <1363040861.10491.35.camel@mirsal-laptop1.mirsal.fr>
Subject: Re: [PATCH 2/4] drivers: android: binder: Fix code style
From: mirsal <mirsal@mirsal.fr>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, devel@driverdev.osuosl.org,
        Brian Swetland <swetland@google.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Date: Mon, 11 Mar 2013 23:27:41 +0100
In-Reply-To: <20130311215402.GD9138@mwanda>
References: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
	 <1363030315-10229-3-git-send-email-mirsal@mirsal.fr>
	 <20130311215402.GD9138@mwanda>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-nGbAWKh+QsDg9G/ftHkm"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nGbAWKh+QsDg9G/ftHkm
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-03-12 at 00:54 +0300, Dan Carpenter wrote:
> On Mon, Mar 11, 2013 at 08:31:53PM +0100, Mirsal Ennaime wrote:
> > @@ -2943,28 +2944,39 @@ static void binder_deferred_release(struct bind=
er_proc *proc)
> > =20
> >  	threads =3D 0;
> >  	active_transactions =3D 0;
> > +
>=20
> The blank line here isn't really appropriate.  The initialization is
> logically a part of the loop.  It's part of the same paragraph.
>=20
> >  	while ((n =3D rb_first(&proc->threads))) {
> > -		struct binder_thread *thread =3D rb_entry(n, struct binder_thread, r=
b_node);
> > +		struct binder_thread *thread =3D rb_entry(n,
> > +			struct binder_thread,
> > +			rb_node);
>=20
> Do this instead:
> 		struct binder_thread *thread;
>=20
> 		thread =3D rb_entry(n, struct binder_thread, rb_node);
>=20
> > +
> >  		threads++;
> >  		active_transactions +=3D binder_free_thread(proc, thread);
> >  	}
> > +
> >  	nodes =3D 0;
> >  	incoming_refs =3D 0;
> > +
> >  	while ((n =3D rb_first(&proc->nodes))) {
> > -		struct binder_node *node =3D rb_entry(n, struct binder_node, rb_node=
);
> > +		struct binder_node *node =3D rb_entry(n,
> > +			struct binder_node,
> > +			rb_node);
> > =20
>=20
> Same thing again.

Resending, thank you so much for reviewing this!

All the best,

--=20
mirsal=20

--=-nGbAWKh+QsDg9G/ftHkm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABCAAGBQJRPlpdAAoJEPePn+hK5bYQ1P8H/jfhBnVr2fPM9vKkzk4LDAXl
HJ2p2+0irgt6ppYrMl9scIfIEHj8h55SlQVQq1l6GT0JI/aqWcNWS9qZt3pnmpvE
gSoxhXq2ZSCD2QT0LqqPppLd1i8vLKmTdxPEcco/oWRAl4ii0jmpPxemyAzxbs2e
eZBFWGCwSBzU0yNhocDLGT9qJFuxfpBH9tpYuny656+hj7NN7vhl4WUZCvOH5u50
xOkkTv4bHfnEmOGLjzF+Fk1Ylw1JNXKJkMFC3zYBevmutf3rL3NS4NmF4MkBoI+/
footuXKATjtODHjbj0YO/f917oN7tJWcF9olPOhJ+v68V1p2aKhIa/JblpWnRpM=
=I1Bw
-----END PGP SIGNATURE-----

--=-nGbAWKh+QsDg9G/ftHkm--

