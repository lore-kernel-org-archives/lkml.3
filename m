Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845AbaKJB1d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 20:27:33 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603AbaKJB1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 20:27:32 -0500
Date: Mon, 10 Nov 2014 12:27:22 +1100
From: NeilBrown <neilb@suse.de>
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
Cc: Tony Lindgren <tony@atomide.com>, Samuel Ortiz <sameo@linux.intel.com>,
        Lee Jones <lee.jones@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        List for communicating with real GTA04 owners 
	<gta04-owner@goldelico.com>
Subject: Re: [Gta04-owner] [PATCH] mfd: twl4030-power: Support compatible =
 "ti, twl4030-power" again.
Message-ID: <20141110122722.34b27c4c@notabene.brown>
In-Reply-To: <ABCF9D6C-DD71-4DE3-BF1E-3C41DC8086FF@goldelico.com>
References: <20141108112227.256f93ce@notabene.brown>
	<ABCF9D6C-DD71-4DE3-BF1E-3C41DC8086FF@goldelico.com>
X-Mailer: Claws Mail 3.10.1-162-g4d0ed6 (GTK+ 2.24.24; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/gBcwjLF+=ijyeWptVha20.h"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/gBcwjLF+=ijyeWptVha20.h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 8 Nov 2014 08:24:28 +0100 "Dr. H. Nikolaus Schaller"
<hns@goldelico.com> wrote:

>=20
> Am 08.11.2014 um 01:22 schrieb NeilBrown <neilb@suse.de>:
>=20
> >=20
> > commit e7cd1d1eb16fcdf53001b926187a82f1f3e1a7e6
> >    mfd: twl4030-power: Add generic reset configuration
> >=20
> > claims:
> >    Let's add device tree support and configure things for warm reset
> >    as the default when compatible =3D "ti,twl4030-power".
> > and
> >    Documentation/devicetree/bindings/mfd/twl4030-power.txt
> > claims that "ti,twl4030-power" is still a valid "compatible" setting.
> >=20
> > However the current driver fails to probe with that 'compatible'
> > setting.
> > Restore the old default.
>=20
> I think this is a duplicate to=20
>=20
> 599a1ca80d1d8269d54fdc4abdec8e65141381fe
>=20
> (in linux-next)


Ahh, so it is.  Thanks.

NeilBrown


>=20
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
> >=20
> > diff --git a/drivers/mfd/twl4030-power.c b/drivers/mfd/twl4030-power.c
> > index 4d3ff3771491..1a7794f6be15 100644
> > --- a/drivers/mfd/twl4030-power.c
> > +++ b/drivers/mfd/twl4030-power.c
> > @@ -776,6 +776,10 @@ static struct twl4030_power_data osc_off_idle =3D {
> >=20
> > static struct of_device_id twl4030_power_of_match[] =3D {
> > 	{
> > +		.compatible =3D "ti,twl4030-power",
> > +		.data =3D NULL,
> > +	},
> > +	{
> > 		.compatible =3D "ti,twl4030-power-reset",
> > 		.data =3D &omap3_reset,
> > 	},
> > _______________________________________________
> > Gta04-owner mailing list
> > Gta04-owner@goldelico.com
> > http://lists.goldelico.com/mailman/listinfo.cgi/gta04-owner


--Sig_/gBcwjLF+=ijyeWptVha20.h
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVGAUejnsnt1WYoG5AQKMXg//RxxhN2pEWoGamXpid4FYpqPRzSTGm/PO
Y9rS+XeVQGhDsCogPaXilj/8awu/hk1OmMzxv9wmMm5br3jic89LFasNtb8uOxRc
PhLkMY0rV7CEtIqDavPJPYGg6B4MbTFU7bbCdR8hji1g4wUtECLuVcfrBBjTcaJx
rvSKXY4fB0SNBHGGNlhdLopjqj45xNW8xW56qKuqvbBsYWC3GsGN/uMOWdnkG+Gd
Ggnb8igosI8l6N7Yl8DzhZDpoh5/t9Clr9lMmsDXvZclaQquhQcPLCxUBROWcBfR
g3A7H51M3zqBt2qAhmYdTCyvxvCR4IUylnDiyrrBvj/8miohfu0A0BJz4L5ARoOu
nozQKs5U66DiFQkiO+MSEqF8N3or/6UIhNYn0Ek13YZp/AdoN+5Z3E+hEAPNOcsU
NTo5Tfkx8I5js73GIhVwW6hhW4C+CPc/UqLznfVouw33feTs1TkhSG4G0NDXXY3s
WeV/zwRJpb4dEk4O2mew4MjxBkASoAZRTcRKRiVXEKLT4pp1n4G8sqnhRC/dl/aB
dMLSf2+/E8ovw4OYNMKsJ1zprszzjxB6SMdVVAq6jCAGBSrWAewIbX8UFKsJ1RLw
WFcEmspx/frwt+ZLn7+REy1qzip5n5akHNnosxX9+Ys788V4lmfhP1ak9oRBt0Y0
qcxwtXq2bpE=
=zYpX
-----END PGP SIGNATURE-----

--Sig_/gBcwjLF+=ijyeWptVha20.h--
