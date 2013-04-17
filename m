Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752948Ab3DQACt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 20:02:49 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60435 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3DQACs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 20:02:48 -0400
Date: Wed, 17 Apr 2013 10:02:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: "Tivy, Robert" <rtivy@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>
Subject: Re: adding rpmsg.git to linux next
Message-Id: <20130417100233.a31e740ec21c96150fde0d81@canb.auug.org.au>
In-Reply-To: <CAK=WgbbVP+3eugev8szRBCV84uZLdKP6QXAH_Fr89SXDs-V5GQ@mail.gmail.com>
References: <CAK=WgbY=4rosYr2g3fYYk6WrqXjN7f=5Dk5+D-h3cWrOtVmNag@mail.gmail.com>
	<20130416100715.cd726b96944237ef975ebe7d@canb.auug.org.au>
	<CAK=WgbbVP+3eugev8szRBCV84uZLdKP6QXAH_Fr89SXDs-V5GQ@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__17_Apr_2013_10_02_33_+1000_dKAZA.efXJPgjYAQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Apr_2013_10_02_33_+1000_dKAZA.efXJPgjYAQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ohad,

On Tue, 16 Apr 2013 20:51:13 +0300 Ohad Ben-Cohen <ohad@wizery.com> wrote:
>
> On Tue, Apr 16, 2013 at 3:07 AM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> > On Mon, 15 Apr 2013 09:28:17 +0300 Ohad Ben-Cohen <ohad@wizery.com> wro=
te:
> >> Could you please add:
> >>
> >> git://git.kernel.org/pub/scm/linux/kernel/git/ohad/rpmsg.git#for-next
> >>
> >> to linux-next to include new stuff coming from Rob?
> >
> > Well, you could tell me something about it.  Like what is in it and how
> > it will be merged up to Linus.  Does this have anything to do with the
> > remoteproc tree I already include?  Who is the official maintainer (the=
re
> > is no mention of drivers/rpmsg in the MAINTAINERS file).
>=20
> Sorry for not mentioning this.
>=20
> This tree isn't new and is being used to send pull requests to Linus
> for some time. I guess that most (all?) of the pull requests contained
> fixes which needed no linux-next presence, so it never occurred to me
> the tree isn't part of linux-next.

All good, thanks for the explanation.  I have added that tree from today.

> commit d8115db52b99eefb99bcbf992edc349e691b4ca7
> Author: Ohad Ben-Cohen <ohad@wizery.com>
> Date:   Tue Apr 16 20:34:49 2013 +0300
>=20
>     MAINTAINERS: add rpmsg entry
>=20
>     People and scripts look for this.
>=20
>     Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>

Good idea.

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

--Signature=_Wed__17_Apr_2013_10_02_33_+1000_dKAZA.efXJPgjYAQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRbeaZAAoJEECxmPOUX5FEo/MQAKAOWcD78WCIaqy5SPO7kr44
S5yKRlJTQXub0Hp9pmJWmCT+i9T5S/Y7u9LbLEiDmNQ/1tKaFke2fmtloU9KrzIW
ifHnSRTbH6/tVTTKwLjpOhVHlCvn/ItBO/q1MhpFPRk/B9Y2tY7MypeREzte5egQ
dIZgReliltdPe5ObxS+ohYbyOM1dx6xE+TyVKFY+OwHhyxp+UsJCR/wxQz76cFLv
3FAwH7zsaLv+BGPSbW+jtwkwvVD5/4i78VtQ/eAm5NO4jmefSM/1+ZdvjzzuDg7P
va+Ej9Oe2HnL7n75jxID6zOB10Ndl8y488y0enEvKz6k8hMJ8plk179XyGSK1ce6
NzpMJQk44PggSuMFdqH/ecCNE2WwCYH+QL3eWYM4tc4kPgv4gLao7aOCJa8YY3r2
N+bWqDu8iLhPwLEXuH55Derev+rQFsSC2+80X0BMfB0ewsb/2FfiiztaY779Obzr
SQKjQ3x3/o7T9EVRiW2xS+oGq0U8hBQQWhR/BVjBtxfUChUNvVCUdYuWTWQ6tRDk
jCL5HC5aWy0+t03j0ypn+QWZZe+tHqtwVT+v9B0yiwbNIzgPJMXnmH88bsWCTfbj
dYwA3tQzocT0NQGXS54tXNNoycoyptO30ClCFKVj9IruuNC29VAvekAdzoR78moI
xaswWHEWW/i0tQeP+H20
=4wHY
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Apr_2013_10_02_33_+1000_dKAZA.efXJPgjYAQ--
