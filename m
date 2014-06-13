Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754243AbaFMXLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 19:11:12 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:51065 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751401AbaFMXLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 19:11:10 -0400
Date: Fri, 13 Jun 2014 18:10:19 -0500
From: Felipe Balbi <balbi@ti.com>
To: Paul Walmsley <paul@pwsan.com>
CC: Felipe Balbi <balbi@ti.com>, Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Tony Lindgren <tony@atomide.com>,
        Benoit Cousson <bcousson@baylibre.com>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sathya Prakash M R <sathyap@ti.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Darren Etheridge <detheridge@ti.com>
Subject: Re: [RESEND PATCH 1/2] ARM: AM43xx: hwmod: add DSS hwmod data
Message-ID: <20140613231019.GA24121@saruman.home>
Reply-To: <balbi@ti.com>
References: <1402676147-3711-1-git-send-email-balbi@ti.com>
 <1402676147-3711-2-git-send-email-balbi@ti.com>
 <20140613162323.GH8319@saruman.home>
 <alpine.DEB.2.02.1406131910060.340@utopia.booyaka.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1406131910060.340@utopia.booyaka.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 13, 2014 at 07:11:58PM +0000, Paul Walmsley wrote:
> > > From: Sathya Prakash M R <sathyap@ti.com>
> > >=20
> > > Add DSS hwmod data for AM43xx.
> > >=20
> > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > Acked-by: Rajendra Nayak <rnayak@ti.com>
> > > Signed-off-by: Sathya Prakash M R <sathyap@ti.com>
> > > Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
> > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > > ---
> > >=20
> > > Note that this patch was originally send on May 9th [1], changes were=
 requested
> > > and a new version was sent on May 19th [2], then on May 27th [3] Tomi=
 pinged
> > > maintainer again and go no response.
> > >=20
> > > Without this patch, we cannot get display working on any AM437x devic=
es.
> > >=20
> > > [1] http://marc.info/?l=3Dlinux-arm-kernel&m=3D139963677925227&w=3D2
> > > [2] http://marc.info/?l=3Dlinux-arm-kernel&m=3D140049799425512&w=3D2
> > > [3] http://marc.info/?l=3Dlinux-arm-kernel&m=3D140117232826754&w=3D2
> > >=20
> > >  arch/arm/mach-omap2/omap_hwmod_43xx_data.c | 98 ++++++++++++++++++++=
++++++++++
> > >  arch/arm/mach-omap2/prcm43xx.h             |  1 +
> > >  2 files changed, 99 insertions(+)
>=20
> Sorry for the delay on this.  Have been corresponding with TI management=
=20
> to figure out what to do about patches for AM43xx.  I don't have boards o=
r=20
> public documentation for these devices, so it's impossible for me to=20
> meaningfully review the patches.  Looks like boards and/or public docs=20
> won't be coming any time soon.
>=20
> So for my part, here's what I'll need to merge any hwmod or PRCM patches=
=20
> that involve AM437x:
>=20
> 1. A Reviewed-by: from one of the following folks (which should come from
> a different person than who is submitting the patches):
>=20
> Roger Quadros
> Nishanth Menon
> Rajendra Nayak
> Kevin Hilman
> Tony Lindgren
>=20
> 2. A Tested-by: from one of the following folks (who can be the same as=
=20
> the person who is the same as the person who is submitting the patches):
>=20
> Nishanth Menon
> Rajendra Nayak
> Kevin Hilman=20
> Tony Lindgren

What you're saying here is that it's pointless for anybody else in TI to
review and/or test patches because you will only accept such tags from
this list of 4 ~ 5 people. It doesn't take a brain surgeon to note how
this won't scale and, if you continue to ignore patches during the
entire development cycle and only reply after it's too late for $this
merge window, it won't help much.

Quite frankly, it's very upsetting to see an affirmation that all the
work that I (personally) and many others do is seen as "pointless" from
your side *unless* it gets the blessing from the few folks listed above.

This just makes it ever more difficult for anything, which is clearly
*BROKEN* to be fixed upstream and will just contribute to people
vanishing from mainline development.

The very fact that you will only accept patches blessed by the gang-of-4
goes against the very foundations of open source development. Just
because you don't have access to documentation - and granted, that
_does_ make things a lot more difficult - does not mean you have to
consider an entire company as a non-trust worthy organization. Specially
when there are so many here who have been doing mainline development for
quite some time.

Anyway, whatever... I just hope that if we go through *another* merge
window without $subject being merged, someone takes the patch because
this already has a ridiculous amount of bureaucratic bariers to patches
which are, to put it very bluntly, *CORRECT*.

ps: $subject in particular, has been tested by 3 different people.
Actually 4, if you consider Darren Etheridge who used $subject to help
me get display working on AM437x SK.

pps: Darren, can you reply with your (according to Paul) pointless
Tested-by ?

--=20
balbi

--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTm4TbAAoJEIaOsuA1yqRE/HkP/0wjnnWQ8iRrv4a32Za8SYau
nIlMDg7q5UmzXBUg7E26UoEgLe6RWD4Bg95BJqgWK8HS733GjRNehpUXQO9eTBJl
eWr6vot9ooVuprVA8bKsOegeQXFthc5YCXBAM+VuuOEu9dolsD5S1s1KEgiXpZf7
s0QQzf+oroQddLDUn4rkL8jWlsdUprLuzsEW57llOKwPCgfwdGlzdGeUVvyjPg9t
k/r/Lgq41TfawsZTfj7w0VRLDLpC2QX2lGHgfGudctCmss0uZs8NPkf7jV7tqqfr
RrUHa+yK5f2Raki+AYNNpIVsbrYh1h6B0fTlGS9h4HSw0lfvwXcm6BbS946jFxLW
6ffL13fXA896sWTTLZmyQy93VmJm7CRUZqowasw6FCrMtM+OCq99baKuJiUMn/aU
JQJa0yrRrBX3CELv7l2zma96X+cpoxaiTI6udR/zMith8LFJ1iX7r9cEEv7WkGD5
0nnLqb5mxN6HFGfiBDZmOcrUov/8o9HK5XorvZHG2sLQ/x8/JSwfU9b6FNFbB3zK
lcpDEsGprt+khqUcXNwngMhL5dePN+HH82+lKNc+w6SHzjXz0VYFp5W0Ll680xrd
uLYmL6Zc3qmo6+cywEECzjTPt0drzIT+eyP5htzFGS9n0ydQMxlUuk9uKlhX1F9m
3cYCz2Vhq081+dCohnCn
=6YTc
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
