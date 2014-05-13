Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaEMTxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 15:53:36 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59876 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060AbaEMTx1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 15:53:27 -0400
Date: Tue, 13 May 2014 14:52:55 -0500
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arm-kernel@lists.infradead.org>, <balbi@ti.com>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/8] usb: xhci: avoid warning for !PM_SLEEP
Message-ID: <20140513195255.GC1151@saruman.home>
Reply-To: <balbi@ti.com>
References: <1399557141-1346645-1-git-send-email-arnd@arndb.de>
 <1399557141-1346645-7-git-send-email-arnd@arndb.de>
 <20140513152829.GK1151@saruman.home>
 <7882044.S9pqnTAVYy@wuerfel>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nDtE8k2pYjsRXajv"
Content-Disposition: inline
In-Reply-To: <7882044.S9pqnTAVYy@wuerfel>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nDtE8k2pYjsRXajv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2014 at 09:39:37PM +0200, Arnd Bergmann wrote:
> On Tuesday 13 May 2014 10:28:29 Felipe Balbi wrote:
> > > diff --git a/drivers/usb/host/xhci-plat.c b/drivers/usb/host/xhci-pla=
t.c
> > > index 151901c..3473296 100644
> > > --- a/drivers/usb/host/xhci-plat.c
> > > +++ b/drivers/usb/host/xhci-plat.c
> > > @@ -202,7 +202,7 @@ static int xhci_plat_remove(struct platform_devic=
e *dev)
> > >       return 0;
> > >  }
> > > =20
> > > -#ifdef CONFIG_PM
> > > +#ifdef CONFIG_PM_SLEEP
> >=20
> > can we just drop the ifdeferry altogether, including from SET_*_OPS
> > macros ? This is just ridiculous that every merge window we have tens of
> > patches fixing the ifdef in several drivers.
>=20
> That would work for me. Another suggestion that came up before was
> to change the SET_*_OPS so that the compiler silently drops the unused
> functions, but unfortunately that would require changing all drivers.

either way would work for me, and such patches would probably be merged
through the trivial tree.

--=20
balbi

--nDtE8k2pYjsRXajv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTcngXAAoJEIaOsuA1yqREupQP/1nuosH0L21r/iyfJJvDGgZb
ea/HJi7UCcuqInD12fPj5k12sZ73QKmewkJ2pJhStFCWj3Q2Wj+mB5MGeSzpHQ2A
UVnsIr61WijWM2rJSFOHU2tRM8hZX43xGD884S0TvH9FpC4RuArIgW8Y4da5xAJU
fk2Gg/Y8irFdQVtGxhoYr9XpO9NLlwHJuyl00XxevMoaBjPeePOLP0YZrZF8K/5J
rlbJVCoc/BEDG9RKKn4VQdSzxdNM21HgRpqHgPp2mmZGc0Hj9UUScYm4ejg+1kmJ
RBj87JUil7ITvU1Th+qnVqaFtvIEdrjkXeVJzMFigsWQZ7ZfJP+WCtbcDXAUocgi
qKJjX3bPYUltKHMFgdNLsdJmY7qVc7N/DO4Ih05gSVRX6vdBzeJ2BpOsz8H39Ua9
JD05bDBXdp9Mv6tkfRh9GQJvIalIRgyk3sjTED7YXBk8QRuotZdTp+5dNpQ6ep4u
fkGqBpZ5mCxA8knZW2bULI897bWN1+AbhcCahMuN0smv4tykAJ8wJwUBicYwZp4I
YL25cWPjIbb1pedeOC47ufGX2VcOoExvz52J6qYEQ8/+tq+6YHD2xNNPAcaXYuCR
pFvLbXbLOY3yHCbcVvbGPGer78VDcvMKRdqAQFxVH7U98D8Qf9FSqYk3XvMxnq+w
igeOQaYWuSqyyUg2Mon+
=x80T
-----END PGP SIGNATURE-----

--nDtE8k2pYjsRXajv--
