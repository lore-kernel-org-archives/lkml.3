Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754208AbaIHPr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 11:47:57 -0400
Received: from ozlabs.org ([103.22.144.67]:38878 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651AbaIHPr4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 11:47:56 -0400
Date: Tue, 9 Sep 2014 01:47:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Mark Brown <broonie@kernel.org>, linaro-kernel@lists.linaro.org,
        Geoff Levand <geoff@infradead.org>, linux-kernel@vger.kernel.org,
        Marc Zyngier <marc.zyngier@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irq: gic-v3: Tag all low level accessors
 __maybey_unused
Message-ID: <20140909014747.0931d51e@canb.auug.org.au>
In-Reply-To: <20140907140255.GB30828@titan.lakedaemon.net>
References: <1406748194-21094-1-git-send-email-broonie@kernel.org>
	<20140817170453.GE12769@titan.lakedaemon.net>
	<20140906125412.GA32429@sirena.org.uk>
	<20140907140255.GB30828@titan.lakedaemon.net>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/3.21rB1nB+AaGHi2SECRbG3"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/3.21rB1nB+AaGHi2SECRbG3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Jason,

On Sun, 7 Sep 2014 10:02:55 -0400 Jason Cooper <jason@lakedaemon.net> wrote:
>
> On Sat, Sep 06, 2014 at 01:54:12PM +0100, Mark Brown wrote:
> > On Sun, Aug 17, 2014 at 01:04:53PM -0400, Jason Cooper wrote:
> > > On Wed, Jul 30, 2014 at 08:23:14PM +0100, Mark Brown wrote:
> > > > From: Mark Brown <broonie@linaro.org>
> >=20
> > > > This is only really needed for gic_write_sgi1r in the !SMP case sin=
ce it
> > > > is only referenced in the SMP initialisation code but it seems bett=
er to
> > > > have these functions all next to each other and declared consistent=
ly.
> >=20
> > > > Signed-off-by: Mark Brown <broonie@linaro.org>
> > > > ---
> > > >  drivers/irqchip/irq-gic-v3.c | 10 +++++-----
> > > >  1 file changed, 5 insertions(+), 5 deletions(-)
> >=20
> > > Applied to irqchip/urgent
> >=20
> > This appears to have disappeared from -next and the warning is back.
>=20
> Hmm, interesting. Here's what I have in irqchip/for-next,irqchip/urgent:
>=20
>   c44e9d77fd1c irqchip: gic-v3: Tag all low level accessors __maybe_unused
>   ddc86821ee2c irqchip: gic-v3: Only define gic_peek_irq() when building =
SMP
>=20
> and:
>=20
> $ git tag --contains c44e9d77fd1c | grep ^next | sort -V
> next-20140820
> next-20140822
> next-20140823
> next-20140825
> next-20140826
> next-20140827
> next-20140828
> next-20140829
>=20
> To see whether I forgot to add /urgent to /for-next or if
> irqchip/for-next was dropped, I did the same search against the first
> commit I added to irqchip/core:
>=20
> $ git tag --contains 1c36d42c4ffe | grep ^next | sort -V
> next-20140822
> next-20140823
> next-20140825
> next-20140826
> next-20140827
> next-20140828
> next-20140829
>=20
> Also dropped on the 30th.  So, unless I really screwed up, -next is no
> longer pulling irqchip/for-next.
>=20
> Stephen, could you please look and see if this is the case?

I am fetching it ok.  Unfortunately, in the hand over to Mark last week
he ended up with an old version of my control file and so that tree was
net being included.  Sorry about that, it should be fixed in
next-20140908.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/3.21rB1nB+AaGHi2SECRbG3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUDc+pAAoJEMDTa8Ir7ZwVaWgP/iGRaTB+9G9tZ1D2ttpLTsE7
lIzXcCinppjkHymC89rgHSEA/6uyhLeaouNEapxR910g0UrpNrsyJHy2tdeklWa0
dQK0w4deDKE1qR1C9v3R0X0wnjCkWhSZk6uKIeKgkOpXuqe3YBIpAnRCe/GVFSdz
OgU0+NlMqDOEaTXJn1Cza5TVpdP71wZvHaxPbnfQrsj/tz259hL2ZVt+CH6WUN4u
j9DmW9+Ph1pk5P8qN3w1hxvk3eVRGzzoe3hIg54Hfk2S6tv/u7wk0NUr5+E4xbcg
/yBqKm5m86w2SxCGn+rKS4pBpkg1IWCYxrOTiUIm7RGCxImHxXpEObL0N3HFEJN7
WWBCaP8o6FvLlQKHDejBR799OclFYr1LEVp6JG+S19CYobz4nN/NKGjf1vJNqnrv
DCKLUDqohBt3DO85D+iBDx72XPuZTp/XddOcv7gBviI4i+i3PDxZScFqUblE3nkO
HrP7LnEYxKeoNq9r7WuLwhPrYZk+XQV4WPnqtVSe/Sh/KpTtREHer98pRBYmm4OD
j9OTJW8Y8KqmCntf24XhyBqOzrg7YvMa4/FdvEA49st0181/jGmP7JiGZIn8upOG
Q85Q93xN3//GDQhU2VIJtzhj5hj/+3/k+vV8OdnROQnZo+CBUEg74u5z9G3zaU3q
eNukaIpcBLZKz0jmhcv1
=9pCh
-----END PGP SIGNATURE-----

--Sig_/3.21rB1nB+AaGHi2SECRbG3--
