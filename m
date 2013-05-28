Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758779Ab3E1Dbw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 23:31:52 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52394 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758717Ab3E1Dbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 23:31:50 -0400
Message-ID: <1369711901.3469.425.camel@deadeye.wl.decadent.org.uk>
Subject: Re: UML build broken since 3.0.75 (also affects 3.2.x)
From: Ben Hutchings <ben@decadent.org.uk>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Antoine Martin <antoine@nagafix.co.uk>, stable@vger.kernel.org,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>
Date: Tue, 28 May 2013 04:31:41 +0100
In-Reply-To: <CAFLxGvx8aFWkPuFh4W3ffDRw-vtqYCHeBGtj4=KeOFvv2AyFBQ@mail.gmail.com>
References: <51A0989A.6070100@nagafix.co.uk>
	 <20130525121851.GB3746@kroah.com>
	 <CAFLxGvx8aFWkPuFh4W3ffDRw-vtqYCHeBGtj4=KeOFvv2AyFBQ@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-RbX3Cs8De9I75KrNCknL"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RbX3Cs8De9I75KrNCknL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2013-05-25 at 15:44 +0200, richard -rw- weinberger wrote:
> On Sat, May 25, 2013 at 2:18 PM, Greg KH <gregkh@linuxfoundation.org> wro=
te:
> > On Sat, May 25, 2013 at 05:55:22PM +0700, Antoine Martin wrote:
> >> Linus' vm patches broke the UML build in 3.0.75 onwards:
> >>
> >>   CC      mm/memory.o
> >> mm/memory.c: In function =E2=80=98vm_iomap_memory=E2=80=99:
> >> mm/memory.c:2363:2: error: implicit declaration of function
> >> =E2=80=98io_remap_pfn_range=E2=80=99 [-Werror=3Dimplicit-function-decl=
aration]
> >> cc1: some warnings being treated as errors
> >> make[1]: *** [mm/memory.o] Error 1
> >> make: *** [mm] Error 2
> >>
> >>
> >> This fix is just a copy of what is found in later kernels.
> >
> > What is that git commit id?
>=20
> commit 4d94d6d030adfdea4837694d293ec6918d133ab2
> Author: Richard Weinberger <richard@nod.at>
> Date:   Tue Feb 7 01:22:47 2012 +0100
>=20
>     um: Serve io_remap_pfn_range()
>=20
>     At some places io_remap_pfn_range() is needed.
>     UML has to serve it like all other archs do.
>=20
>     Signed-off-by: Richard Weinberger <richard@nod.at>

Queued up for 3.2, thanks all.

Ben.

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-RbX3Cs8De9I75KrNCknL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUaQlHee/yOyVhhEJAQqDsBAAiMx6LTlaxS+gQQe+eufxSqm4n+CaOnrO
bjUEYaFLQeGbepeCswumt3C7KOr514ldekhtFXhMrWWHIsSthc2qElonWw4VJyiY
tc8cpjZKQgfbOhY9IbQQxPkOZLN3ggtbDq9dzB7PrDxqkqEmMf4LBi6PL/zA4MIU
8rEWFln2fUKCUxrVjNTr0mJl2DffpE0EupxV4B5FQUXf4igl/L7lO0z138qngO6R
V9YcpabPBpM4gsjO5UtrCtOLQKhXTWPYfY8MlMMWLevJ8ozEhZtA+vSq0TALDYzI
uPGlXSHpui88Ch1yCHePKjxBFxVH4lGoCHQesm3alhpqiEnIKCJiLQnavw4jxxUY
b1SBP1sHIXIfew/M86y8Z2QsLPf1kOSqaGyTbrTennEzlC0lKf+inHZTVWT0Prvo
FeYR1NMyesMzdXv6kgosRfUFaqepAr/XVBPFzr0UxA3kGO+338lKmQ0ZWf7x/fBa
PCtjrn/C3/lBIIcXIhkzoo8AyohqvHfg7SC2ST4HYplchkGAi3g43+I34t+cmXLD
tIeuw+GR1prQSOyuUH98PMmc8fWnrwN7ubPl5KCCwKbWqPySCFfnwbaNT8Xt+QWz
HdO87ogNsautWrfdK+k8LZJa1VZFX3wjYWajnHpsNgqEGCuqOrpTMfUXWBS5n50+
gjE/wgKRm5E=
=4YC7
-----END PGP SIGNATURE-----

--=-RbX3Cs8De9I75KrNCknL--
