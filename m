Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab3LQEge (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 23:36:34 -0500
Received: from ozlabs.org ([203.10.76.45]:59393 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751954Ab3LQEgc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 23:36:32 -0500
Date: Tue, 17 Dec 2013 15:36:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <balbi@ti.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Anton Tikhomirov <av.tikhomirov@samsung.com>
Subject: Re: linux-next: build failure after merge of the usb-gadget tree
Message-Id: <20131217153625.744ebbe433f3d624d11af2bb@canb.auug.org.au>
In-Reply-To: <20131209041152.GC20608@saruman.home>
References: <20131209145803.4aba29ca2eba4444070e43ce@canb.auug.org.au>
	<20131209041152.GC20608@saruman.home>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Dec_2013_15_36_25_+1100_/k1KCpW4C9ERgLU9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Dec_2013_15_36_25_+1100_/k1KCpW4C9ERgLU9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

On Sun, 8 Dec 2013 22:11:52 -0600 Felipe Balbi <balbi@ti.com> wrote:
>
> On Mon, Dec 09, 2013 at 02:58:03PM +1100, Stephen Rothwell wrote:
> >=20
> > After merging the usb-gadget tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > drivers/built-in.o: In function `otg_set_state':
> > (.text+0x14f7de): undefined reference to `usb_bus_start_enum'
> >=20
> > CONFIG_USB is 'm' in this build.
> >=20
> > I am not sure what changed to cause this, maybe e1d2e31975e1 ("usb: phy:
> > Add OTG FSM configuration option")?
> >=20
> > I have used the usb-gadget tree from next-20131206 for today.
>=20
> I see what caused it, will fix it up with a patch which should probably
> be backported a few kernels back. Thanks for letting me know.

I am still getting this error ...
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__17_Dec_2013_15_36_25_+1100_/k1KCpW4C9ERgLU9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSr9TOAAoJEMDTa8Ir7ZwVzOkP/3aYPZ6nqyqjqUiPDYjirRzy
0vPZ1Lv+u3x1DYnHaXvRL7ARqaJho9G+AhyGWo3YZw3upfmqucA7EP0h5ZBK9seO
a18r6yyY229UY8hSFjzKwiXO1SnTneUhSbIUmB4SLQxXxQDo9KcgcPlhSmE6Or1Z
g4p+msq2uaTFPoPG+ioKGhJ3j9J8eF1Jjux6UAruCN1KDFQr6Z0SP+dGWLbqybyJ
6q1N5Mzr3LR/AI6JO9f/GvOio1TqObTE+E/JJu/Yr+JOrP2zzTMLZtObMWvqGoiQ
kjMc/RcRmxuv41hbwECvjz4467uLKDYrtsdwhlHZZkbWXxCY9NhuTTMa4QksGAr2
vKChs5ki/H2xFMuV1y8qUzI4ZrDZVKBbw8itITGrxH8oKY2Mva2MaYzGhYbMDbxs
Fco4UzApTcdF9OK6HML3gi0ZxmQg5P/FO5cXlMtGT7U721BIG4gcOI090of4Mi5X
JPZtGljVWZX6phmaNigTMUgSEFr2KU36MynXwmursg7BigDL2Ym2juhCV1bTYx3I
f2+4PP5fJJgoWan1oMF/smRueC3dyDjNtRPGP+ITPY6DDnuH+oqfiDzYZvRzIZZO
MBxDSyQlRtz02xGu8OvEH5HjUsxif2rO3K0Eik1NqSE/r+qaGpVhveuAio62tjpL
h7qEClJuUE4chDcYuEQJ
=iihW
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Dec_2013_15_36_25_+1100_/k1KCpW4C9ERgLU9--
