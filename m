Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab3CLIww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 04:52:52 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:45414 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754725Ab3CLIwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 04:52:50 -0400
Message-ID: <1363078356.10491.38.camel@mirsal-laptop1.mirsal.fr>
Subject: Re: [PATCH v2 2/3] drivers: android: binder: Fix code style
From: mirsal <mirsal@mirsal.fr>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: Greg Kroah-Hartman <greg@kroah.com>, Brian Swetland <swetland@google.com>,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Joe Perches <joe@perches.com>
Date: Tue, 12 Mar 2013 09:52:36 +0100
In-Reply-To: <CAMP5XgchLsz=MJsousY+qQU3J_Y4D7U2jC0xqb4yhbNwiMS8+w@mail.gmail.com>
References: <1363030315-10229-1-git-send-email-mirsal@mirsal.fr>
	 <1363044388-11409-1-git-send-email-mirsal@mirsal.fr>
	 <1363044388-11409-3-git-send-email-mirsal@mirsal.fr>
	 <CAMP5XgchLsz=MJsousY+qQU3J_Y4D7U2jC0xqb4yhbNwiMS8+w@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-WebXw3PLKt5OEcBbh8Zb"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WebXw3PLKt5OEcBbh8Zb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-03-11 at 16:57 -0700, Arve Hj=C3=B8nnev=C3=A5g wrote:
> On Mon, Mar 11, 2013 at 4:26 PM, Mirsal Ennaime <mirsal@mirsal.fr> wrote:
> >  * Use tabs
> >  * Remove a few "80-columns" checkpatch warnings
> >  * Separate code paths with empty lines for readability
> >
> > Signed-off-by: Mirsal Ennaime <mirsal@mirsal.fr>
> > ---
> >  drivers/staging/android/binder.c |   42 +++++++++++++++++++++++++-----=
--------
> >  1 file changed, 28 insertions(+), 14 deletions(-)
> >
> > diff --git a/drivers/staging/android/binder.c b/drivers/staging/android=
/binder.c
> > index 43f823d..4652cd8 100644
> > --- a/drivers/staging/android/binder.c
> > +++ b/drivers/staging/android/binder.c
> > @@ -2927,57 +2927,69 @@ static void binder_deferred_release(struct bind=
er_proc *proc)
> >  {
> >         struct binder_transaction *t;
> >         struct rb_node *n;
> > -       int threads, nodes, incoming_refs, outgoing_refs, buffers, acti=
ve_transactions, page_count;
> > +       int threads, nodes, incoming_refs, outgoing_refs, buffers,
> > +               active_transactions, page_count;
> >
> >         BUG_ON(proc->vma);
> >         BUG_ON(proc->files);
> >
> >         hlist_del(&proc->proc_node);
> > +
> >         if (binder_context_mgr_node && binder_context_mgr_node->proc =
=3D=3D proc) {
> >                 binder_debug(BINDER_DEBUG_DEAD_BINDER,
> > -                            "binder_release: %d context_mgr_node gone\=
n",
> > -                            proc->pid);
> > +                       "binder_release: %d context_mgr_node gone\n",
> > +                       proc->pid);
>=20
> I don't like this change (and the others like it). If is not uncommon
> the align arguments on that don't fit the first line with the
> arguments on the first line, so why change it here?

I actually took the "no tabs for indentation" rule a bit too literally.

Fixed in v3, thank you!

--=20
mirsal=20

--=-WebXw3PLKt5OEcBbh8Zb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEcBAABCAAGBQJRPuzVAAoJEPePn+hK5bYQLYUH/0jXJpXpup8IR49vmQBFim+V
/cQoOJswK7yHFX41hzmg+2cnv2kz2mBAV74dtmc45DOomzVm5ith/6ACUoStyVfP
qBwRq4voVfFvDrwwkuTvPWh5H2OHuehW5K0i0SMUK2vRf6jcIHjvVfbyQC63tux0
34gV/5mN0KWhvD1eyVFCkWuxU0JHBhlL4AP+OKj9r4BjxCa243ETUrGy/RUj4SuY
KlpgDrRUPLjiF3H4uwnIBhE81Vz0VLxbd6vFho92Oqe5eBp0W86poxDhkP18I/EJ
3QX0ayimhEUJVXEdjpM6fyJrRsnmoouX216JUBTawuVhXzf2jg739OZIzIOrMT4=
=FBx1
-----END PGP SIGNATURE-----

--=-WebXw3PLKt5OEcBbh8Zb--

