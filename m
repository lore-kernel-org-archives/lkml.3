Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab3CDVLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 16:11:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37131 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758773Ab3CDVLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 16:11:17 -0500
Date: Tue, 5 Mar 2013 08:11:02 +1100
From: NeilBrown <neilb@suse.de>
To: Kees Cook <keescook@chromium.org>
Cc: Dan Williams <djbw@fb.com>, LKML <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Alasdair G Kergon <agk@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] md/raid456: remove depends on CONFIG_EXPERIMENTAL
Message-ID: <20130305081102.73211ef9@notabene.brown>
In-Reply-To: <CAGXu5jKpdVFoEvbGv3K620XDx2bjqQYeCLE511h-071XaPQUGg@mail.gmail.com>
References: <20130223074001.GA5199@www.outflux.net>
	<CAA9_cmfa1hhijh4g_hSwMy_GR81rxjEFMurJwSvhBruh1R5dtw@mail.gmail.com>
	<CAGXu5jKpdVFoEvbGv3K620XDx2bjqQYeCLE511h-071XaPQUGg@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/+sQlSWdjxSVU6gD8Nvdt+vk"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/+sQlSWdjxSVU6gD8Nvdt+vk
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 4 Mar 2013 10:59:30 -0800 Kees Cook <keescook@chromium.org> wrote:

> On Tue, Feb 26, 2013 at 5:27 PM, Dan Williams <djbw@fb.com> wrote:
> > On Fri, Feb 22, 2013 at 11:40 PM, Kees Cook <keescook@chromium.org> wro=
te:
> >> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> >> while now and is almost always enabled by default. As agreed during the
> >> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
> >>
> >> Signed-off-by: Kees Cook <keescook@chromium.org>
> >> Cc: Arjan van de Ven <arjan@linux.intel.com>
> >> Cc: Dan Williams <dan.j.williams@intel.com>
> >> Cc: Alasdair G Kergon <agk@redhat.com>
> >> ---
> >>  drivers/md/Kconfig |    1 -
> >>  1 file changed, 1 deletion(-)
> >>
> >> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> >> index 7cdf359..0cc3a3d 100644
> >> --- a/drivers/md/Kconfig
> >> +++ b/drivers/md/Kconfig
> >> @@ -158,7 +158,6 @@ config MULTICORE_RAID456
> >>         bool "RAID-4/RAID-5/RAID-6 Multicore processing (EXPERIMENTAL)"
> >>         depends on MD_RAID456
> >>         depends on SMP
> >> -       depends on EXPERIMENTAL
> >
> > In this case MULTICORE_RAID456 and the related code should go as
> > well... now that there are patches to supersede this implementation in
> > md-next.
>=20
> Can my original patch go through as-is for Linus's tree? Right now,
> this is the last use of EXPERIMENTAL in v3.9-rc1. If we can drop it,
> we can remove the config item entirely from v3.9.

My pull request which removes CONFIG_MULTICORE_RAID456 completely was a lit=
tle
late and missed -rc1.  Hopefully it will appear soon.
But if it isn't gone by -rc2, I have no objection to your patch going in th=
en.

NeilBrown

--Sig_/+sQlSWdjxSVU6gD8Nvdt+vk
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUTUN5jnsnt1WYoG5AQJKcg//UpFsNV3bHA2HOwaT+dKw2NB3qk6yFfOM
fE/vcqlsb7Vx8IkJ76TIFRmYfnd+tiHObUBk9Elwqox1UWd/D2DkAUO8mqcq1TgB
lbJk8WXH904ixFB8+M/XQGDCGaP4K+S1J+jXwanzkfVxOhOBYEaTbfZjrcWOGZTg
FVpQVJLs3o7DXux1kk2SEO3zziw8w+38LOrobz0jRMJY4l72EzxV0GvE5hG9y1Jn
2LZkGJMq30Cx2aZ2b8E8A9BqM5rLvQehS1HFNLdHYVjWu2DNHLk0/9ffCNc799+l
vCPke8jcdPPorSN8IqAfNKvKn/79wOx476l3lIMF7CCy/RHLA2A9cgQZsCJffcEN
CYoCs61aYXdDtdjFDA9X2cZKabSmaq3IIVI8MNs6z8VQe1Q+s8kgbMR6WlqA85Rx
a943q21J+DY8JUdIrRc6a6k+BJfcINvtRxPr2MbKFRp0Hgw0ope43N5U9+t4hZ4V
4XXHLiO9P8qtUmat74nIQeARyGY5FF2odInZnkmMgfkzaQFvITO5I/LiDa9a1Bpm
5gpekEGhBnN5asdKxHhKUx2sqbXMxT4BQlXIoqb+ygpzOqwI8KujbjkonjEOc7GS
hY8E3QHtO2NqYHtuzlBzEY6NSkEcApesgUQblkgHsGBoVYPHgV0xV8XRPragm+Rj
+0QSwqSm+Vs=
=FmSN
-----END PGP SIGNATURE-----

--Sig_/+sQlSWdjxSVU6gD8Nvdt+vk--
