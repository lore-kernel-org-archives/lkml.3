Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932593Ab3KHXop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 18:44:45 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39965 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932498Ab3KHXol (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 18:44:41 -0500
Date: Sat, 9 Nov 2013 10:44:24 +1100
From: NeilBrown <neilb@suse.de>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: Ben Myers <bpm@sgi.com>, Ric Wheeler <rwheeler@redhat.com>,
        elder@kernel.org, Mark Tinguely <tinguely@sgi.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xfstests <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] update xfs maintainers
Message-ID: <20131109104424.45b71dac@notabene.brown>
In-Reply-To: <CAEH94LidwFnLX7cxetBAAzYzRGL+pc96egDNKPFKuPYcqKOtNg@mail.gmail.com>
References: <20131107220208.GY1935@sgi.com>
	<527C0F64.3010906@sgi.com>
	<527C4B27.6020205@redhat.com>
	<527CC50D.4060905@redhat.com>
	<20131108180337.GO10553@sgi.com>
	<20131108193424.GA11052@infradead.org>
	<20131108204605.GA1935@sgi.com>
	<527D4E8D.3000109@redhat.com>
	<20131108220309.GB1935@sgi.com>
	<CAEH94LidwFnLX7cxetBAAzYzRGL+pc96egDNKPFKuPYcqKOtNg@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/ZJLaGD0NzuLPED6VFKEZ+tC"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ZJLaGD0NzuLPED6VFKEZ+tC
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 9 Nov 2013 06:59:00 +0800 Zhi Yong Wu <zwu.kernel@gmail.com> wrote:

> On Sat, Nov 9, 2013 at 6:03 AM, Ben Myers <bpm@sgi.com> wrote:
> > Hey Ric,
> >
> > On Fri, Nov 08, 2013 at 03:50:21PM -0500, Ric Wheeler wrote:
> >> On 11/08/2013 03:46 PM, Ben Myers wrote:
> >> >Hey Christoph,
> >> >
> >> >On Fri, Nov 08, 2013 at 11:34:24AM -0800, Christoph Hellwig wrote:
> >> >>On Fri, Nov 08, 2013 at 12:03:37PM -0600, Ben Myers wrote:
> >> >>>Mark is replacing Alex as my backup because Alex is really busy at
> >> >>>Linaro and asked to be taken off awhile ago.  The holiday season is
> >> >>>coming up and I fully intend to go off my meds, turn in to Fonzy the
> >> >>>bear, and eat my hat.  I need someone to watch the shop while I'm o=
ff
> >> >>>exploring on Mars.  I trust Mark to do that because he is totally
> >> >>>awesome.
> >> >>
> >> >>Doing this as an unilateral decisions is not something that will win=
 you
> >> >>a fan base.
> >> >It's posted for review.
> >> >
> >> >>While we never had anything reassembling a democracy in Linux Kernel
> >> >>development making decisions without even contacting the major
> >> >>contributor is wrong, twice so if the maintainer is a relatively min=
or
> >> >>contributor to start with.
> >> >>
> >> >>Just because it recent came up elsewhere I'd like to recite the
> >> >>definition from Trond here again:
> >> >>
> >> >>    http://lists.linux-foundation.org/pipermail/ksummit-2012-discuss=
/2012-June/000066.html
> >> >>
> >> >>By many of the creative roles enlisted there it's clear that Dave sh=
ould
> >> >>be the maintainer.  He's been the main contributor and chief archite=
ct
> >> >>for XFS for many year, while the maintainers came and went at the me=
rcy
> >> >>of SGI.  This is not meant to bad mouth either of you as I think you=
're
> >> >>doing a reasonably good job compared to other maintainers, but at the
> >> >>same time the direction is set by other people that have a much long=
er
> >> >>involvement with the project, and having them officially in control
> >> >>would help us forward a lot.  It would also avoid having to spend
> >> >>considerable resources to train every new generation of SGI maintain=
er.
> >> >>
> >> >>Coming to and end I would like to maintain Dave Chinner as the prima=
ry
> >> >>XFS maintainer for all the work he has done as biggest contributor a=
nd
> >> >>architect of XFS since longer than I can remember, and I would love =
to
> >> >>retain Ben Myers as a co-maintainer for all the good work he has done
> >> >>maintaining and reviewing patches since November 2011.
> >> >I think we're doing a decent job too.  So thanks for that much at lea=
st.  ;)
> >> >>I would also like to use this post as a public venue to condemn the
> >> >>unilateral smokey backroom decisions about XFS maintainership that S=
GI is
> >> >>trying to enforce on the community.
> >> >That really didn't happen Christoph.  It's not in my tree or in a pul=
l request.
> >> >
> >> >Linus, let me know what you want to do.  I do think we're doing a fai=
r job over
> >> >here, and (geez) I'm just trying to add Mark as my backup since Alex =
is too
> >> >busy.  I know the RH people want more control, and that's understanda=
ble, but
> >> >they really don't need to replace me to get their code in.  Ouch.
> >> >
> >> >Thanks,
> >> >     Ben
> >>
> >> Christoph is not a Red Hat person.
> >>
> >> Jeff is from Oracle.
> >>
> >> This is not a Red Hat vs SGI thing,
> >
> > Sorry if my read on that was wrong.
> >
> >> Dave simply has earned the right
> >> to take on the formal leadership role of maintainer.
> >
> > Then we're gonna need some Reviewed-bys.  ;)
> >
> > From: Ben Myers <bpm@sgi.com>
> >
> > xfs: update maintainers
> >
> > Add Dave as maintainer of XFS.
> >
> > Signed-off-by: Ben Myers <bpm@sgi.com>
> > ---
> >  MAINTAINERS |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > Index: b/MAINTAINERS
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > --- a/MAINTAINERS       2013-11-08 15:20:18.935186245 -0600
> > +++ b/MAINTAINERS       2013-11-08 15:22:50.685245977 -0600
> > @@ -9387,8 +9387,8 @@ F:        drivers/xen/*swiotlb*
> >
> >  XFS FILESYSTEM
> >  P:     Silicon Graphics Inc
> > +M:     Dave Chinner <dchinner@fromorbit.com>
> Use his personal private mail account? I guess that you should ask for
> his opinion at first, or it is more appropriate that he submit this
> patch by himself.
>=20

Indeed.  And does he even want the job?  I heard Linus say in a recent
interview that being a maintainer is a $#!+ job.  Is it really best for the
most active developers to be burdened with that extra work?

(hmm.. maybe I should add Dave to the Cc here .. but no-one else did so best
leave him alone to code in peace).

NeilBrown

--Sig_/ZJLaGD0NzuLPED6VFKEZ+tC
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUn13WDnsnt1WYoG5AQJGIBAAg0qKRZmT77HAxGtW7vFCX8bQxSPFxioM
Dhy4FbWpN4QnFbvVSTJhgiw380f16WbuTq05wIadnEPZrO22Pf0PNGCdORvWREkd
tBZe/pxH3Z6Wp2dR0kZGMi5Ysuvv/H0sos3tulVSGKzRUzl/J1gYevAD6LVgAwFz
Noy/PNO4ScsB5CGDlNaeKz+RKrdSv2yKpIuHwtffbsu0sRdgOvvXrMol03hnPTpj
bKw/lRbv5pq7HXCgTD+b8lCnatpTocU2W9h721vQx6hfk3fAd79hQoZd6yrbOuH+
rkxWpD73Tfta53USyvTHXLyhpH9JsKCMd5Ri4n1I841wardW6W6gAKgIyKzwez4M
uBYo1PamCgm8/wdIA0FucEAeESKpgQ6OEb7t22SOWtm2G9yNa6BxZW6GlHB2CpPe
3+g1yChee6MLvaINnQtyX5tsSHFi70IZ9iw3TTHIsav8RTGJ4mT6bU42Vx2PHHxT
rT/coh21gnZTr3DrupOOcHvYbd364A7rv6/I710w/YmYmTQCSJaXhjHZZofM7gkj
3bnchw3sZk8ONPhQJyo7mCrQi2csgcWyPveVQZmMUVRiRmtfHX3lgiWtR8FbxQRs
GhL2LoT6rVmwPzB2pQ3R1kDopJCqRybPxUA+KeLNuwcWa3zow7fHka0AefdxUlrn
ZXKa3pwNlxw=
=AVft
-----END PGP SIGNATURE-----

--Sig_/ZJLaGD0NzuLPED6VFKEZ+tC--
