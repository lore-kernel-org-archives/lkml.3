Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935107Ab3BNX1p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 18:27:45 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53928 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935069Ab3BNX1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 18:27:44 -0500
Date: Fri, 15 Feb 2013 10:27:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Borislav Petkov <bp@alien8.de>, rostedt@goodmis.org,
        Dave Airlie <airlied@gmail.com>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Including drm-intel tree to linux-next
Message-Id: <20130215102734.0ebe1b4826e94c83ed7a407d@canb.auug.org.au>
In-Reply-To: <20130214141953.GA5746@pd.tnic>
References: <CAKMK7uEQ7xQpsBay8SKjYM0oA0=uf3AePwZ+vEjukgOiLY9drg@mail.gmail.com>
	<20130214141953.GA5746@pd.tnic>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__15_Feb_2013_10_27_34_+1100_aLA2dtBFTOU/+ned"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__15_Feb_2013_10_27_34_+1100_aLA2dtBFTOU/+ned
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Daniel,

On Thu, 14 Feb 2013 15:19:53 +0100 Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Feb 14, 2013 at 03:12:02PM +0100, Daniel Vetter wrote:
> >=20
> > Since about a year ago we've switched drm/i915 to buffer around 2
> > weeks worth of patches so that we can do decent QA before breaking
> > everyone's tree when things land in Dave's drm-next. But that also
> > means we'll miss out a bit in the integration testing -next provides,
> > which did hurt a bit in recent efforts. Hence can you please include
> >=20
> > git://people.freedesktop.org/~danvet/drm-intel drm-intel-next-queued
> >=20
> > into linux-next? Probably best to merge it after drm-next. Note that
> > drm-intel-next are the QA'ed chunks I send off to Dave. Also, any
> > mailing lists I'm supposed to follow? And if possible please cc
> > intel-gfx@lists.freedesktop.org besides dri-devel/lkml when conflicts
> > with that tree pop up (you won't get moderation spam any more, we've
> > fixed that up).

Added from today.  I am in two minds a bit since I really like stuff in
linux-next to have been reviewed and debugged as much as possible.   But
I have added it and will keep an eye on how many problems it causes.

Problem reports will go to you, intel-gfx and dri-devel.  You can follow
linux-next@vger.kernel.org (I sometimes post stuff there that goes
nowhere else (except lkml - which noone seems to notice :-)).

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Fri__15_Feb_2013_10_27_34_+1100_aLA2dtBFTOU/+ned
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRHXLmAAoJEECxmPOUX5FExWAQAKEw6O2pzx8pJUAgm0sVK4vY
mYdqIYq3k1YD37rrGEo06NmnFE3IyZfXPqWljYMFGt4jD01dXBl7KatCnwCqmjaU
p0GUUkwi0JSs07c62QC6/cd34g8F4lyBZ0/bfQJkBpKBMTquY4aO9g1X+iQEmpV1
koEE9iJoP1KQIDivhY5kfgCcwTnUzc40cGu9rPehBmO8wRXPzLvbMgH65/kzXqTS
6CT1P131+nePZ4D/kgfnw5bMd5yaDnydYi4D/nzZlUk8pn4O3Bi0fPxGAnTmYeXn
GQqx0rOWXvqKluhJFnceziRYMQ2Gakx/aPlxsGAKqDL9zdf8MYQbLc7tf+q99Y4V
OU9O05X/zIxHMqr/nAUspAlyprJG2R+mF4cDN7IBvAcR4vJxEMs6fLUAOfbrX3aU
ioH50lHuS62/7ZYYubbgx5XIGGTpCk0m+EFxrFLq0qilEB/+NylYVsmAQvOGI5gs
dJdtuumvzk51FoqU3bf1nQM2/xtjH2Eh113OJrZJvebueDMDYRD2kxzPkLXHrvQ9
uF2dxPOnCQxShD3t2i44fNQo97kimoac6noQQavGEAqRCJZLen4gE3tLDJ3auy/n
Aa9ehq7Ok671/GEkJdkwwrz5JgYedrXQk8PDp3hsUiMx+0+8Jt4IN5QMRxZjPvdv
/HyO+v026hKLhT1UZUdf
=iti9
-----END PGP SIGNATURE-----

--Signature=_Fri__15_Feb_2013_10_27_34_+1100_aLA2dtBFTOU/+ned--
