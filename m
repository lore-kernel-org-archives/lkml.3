Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaG2QFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:05:17 -0400
Received: from top.free-electrons.com ([176.31.233.9]:48854 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751587AbaG2QFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:05:15 -0400
Date: Tue, 29 Jul 2014 18:03:09 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sunxi@googlegroups.com,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Arnd Bergmann <arnd@arndb.de>, andriy.shevchenko@intel.com,
        dmaengine@vger.kernel.org
Subject: Re: [PATCH v11 0/2] Add support for the Allwinner A31 DMA Controller
Message-ID: <20140729160309.GS3952@lukather>
References: <1405626376-471-1-git-send-email-maxime.ripard@free-electrons.com>
 <20140725131217.GS8181@intel.com>
 <20140725163746.GC20328@lukather>
 <20140725164218.GW8181@intel.com>
 <20140728101402.GD3952@lukather>
 <20140728141812.GE8181@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bk6L21jbBNK7V1Rv"
Content-Disposition: inline
In-Reply-To: <20140728141812.GE8181@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bk6L21jbBNK7V1Rv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 28, 2014 at 07:48:12PM +0530, Vinod Koul wrote:
> On Mon, Jul 28, 2014 at 12:14:02PM +0200, Maxime Ripard wrote:
> > On Fri, Jul 25, 2014 at 10:12:18PM +0530, Vinod Koul wrote:
> > > On Fri, Jul 25, 2014 at 06:37:46PM +0200, Maxime Ripard wrote:
> > > > > Can you please send follow patches for these:
> > > > > - don't recall if I pointed earlier, but can we use direct conver=
sion for
> > > > >   calculating convert_burst() and convert_buswidth(), latter one =
at least
> > > > >   seem doable
> > > >=20
> > > > Ok. Do you still want the error reporting for the invalid width and
> > > > burst size?
> > > I think for convert_buswidth() we can do away with a switch case and =
convert
> > > the numbers directly
> >=20
> > Well, it's already using a switch. Do you want me to remove completely
> > the function and move the switch where it's used? It's used two times
> > now, so I'd like to avoid duplicating it.
> You can probably remove switch in these function by converting them
> arithmetically..
>=20
> > > > > - don't use devm_request_irq(). You have irq enabled and you have=
 killed
> > > > >   tasklet. This is too racy. You need to ensure no irqs can be ge=
nerated before killing
> > > > >   tasklets.
> > > >=20
> > > > Ok, would calling disable_irq before killing the tasklet an option =
for
> > > > you ? that would allow to keep the devm_request_irq.
> > > disable_irq also does syncronize, so it might work. But then again if=
 the
> > > probe fails after registering irq due to some other reason, and you g=
et into
> > > races with unitialized driver as well.
> > >=20
> > > I think it might be easier to amnge by working with plain old request=
_irq()
> >=20
> > Yes, devm_free_irq like Russell suggested seems to both address your
> > concerns, while not having to care about it at probe.
> OK, pls send the fix

Ok, will do tomorrow.

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Bk6L21jbBNK7V1Rv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT18W9AAoJEBx+YmzsjxAg9uAQAJQJMpFtZ7OWK0oAhyMyG+qv
PNJD8sB2P7KpE5astD/jKU9r6rLPom2Fjn1DHJmLXqlxVIpZsEB9QZiKD+RSgrT2
d+HXK8IUO5GAyDl3heN6F7KTwA5VyMimOimuA357yzWXFy//3w8lVTU0907eLJzT
/guCO8tl82OPv4cakQnong2D5SNlesBQxaOHwoIAd+YwVX06YL0gprvfBvxRaMSS
KnQayCtEpOblQQE6rTU2353Icpi1ZfIfj0CpdRNRiLI3vUwMCrwZyERWFaN+oczM
1WF/PenZ0djFOt+sdjV28ENl72QmxjCa2etogoeWjePde9Ywv/z3N1c5wimpjeZa
F6mVMtN9QgySxoidXPWG2U8nKurpwPtYNvbbET6+AnYoNRKYDzT/J8ClD4WRjBUC
kW9/glN7tTbsc/BkQ2QI6FibtZvWIHd5TqIrysOuCMDYCZhIHIq7vMiK4g8+zI01
Yp18GSjCTe3xFzetQnFMc/r6Cr98dNWrg5D8UcvrWQYMtWXTCKTr0J+ett3fDSr/
u1c0sdmg/zdUkE4otrjrlDLz3+x0bCSqZrpxwbZeA3eh7IiU0jKd1Xcq2GBom1po
Es4hhqhfFSszDc696R9T+c3OWO5vwe9FXIb2EHTZHQ7bub4+sRLNVYx2STe+G8lO
trgJYuuPOowqUh+YH5rd
=g96g
-----END PGP SIGNATURE-----

--Bk6L21jbBNK7V1Rv--
