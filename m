Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107Ab3LIUnj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 15:43:39 -0500
Received: from ozlabs.org ([203.10.76.45]:38251 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932582Ab3LIUnh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 15:43:37 -0500
Date: Tue, 10 Dec 2013 07:43:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Felipe Balbi <balbi@ti.com>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Anton Tikhomirov <av.tikhomirov@samsung.com>
Subject: Re: linux-next: build failure after merge of the usb-gadget tree
Message-Id: <20131210074330.7875f55f1a0e25bd4c2acf0d@canb.auug.org.au>
In-Reply-To: <20131209194032.GC28441@saruman.home>
References: <20131209145803.4aba29ca2eba4444070e43ce@canb.auug.org.au>
	<20131209041152.GC20608@saruman.home>
	<20131209194032.GC28441@saruman.home>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Dec_2013_07_43_30_+1100_D+qEVVyQtU0F1iWS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Dec_2013_07_43_30_+1100_D+qEVVyQtU0F1iWS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Felipe,

On Mon, 9 Dec 2013 13:40:32 -0600 Felipe Balbi <balbi@ti.com> wrote:
>
> On Sun, Dec 08, 2013 at 10:11:52PM -0600, Felipe Balbi wrote:
> > On Mon, Dec 09, 2013 at 02:58:03PM +1100, Stephen Rothwell wrote:
> > >=20
> > > After merging the usb-gadget tree, today's linux-next build (x86_64
> > > allmodconfig) failed like this:
> > >=20
> > > drivers/built-in.o: In function `otg_set_state':
> > > (.text+0x14f7de): undefined reference to `usb_bus_start_enum'
> > >=20
> > > CONFIG_USB is 'm' in this build.
> > >=20
> > > I am not sure what changed to cause this, maybe e1d2e31975e1 ("usb: p=
hy:
> > > Add OTG FSM configuration option")?
> > >=20
> > > I have used the usb-gadget tree from next-20131206 for today.
> >=20
> > I see what caused it, will fix it up with a patch which should probably
> > be backported a few kernels back. Thanks for letting me know.
>=20
> Do you still have the .config which caused that build error ? I couldn't
> reproduce with CONFIG_USB=3Dm && CONFIG_USB_OTG=3Dy.

See above, it was just an x86_64 allmodconfig build.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__10_Dec_2013_07_43_30_+1100_D+qEVVyQtU0F1iWS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJSpit3AAoJEMDTa8Ir7ZwVMxkQAIR3BX6cJQ4NoZmRCCvAXls5
lP32KltNZG3gIbI7ZKvCqtkR5O8TasiLp8Y2WypWeRL5jgrtLn0KRuUfIM1fQ9Ys
FgLPFvcX/wl6PPhD3OR+VWIoDXMXKJUilG5mdg3nw3ZUprU5u2vaBXacdPCBzQbL
T1mHbunJ/rGmq6KoslzO+hJZ5hnBEouI5p5qHHB8IgkXfvAGnd4BR7JJ6Ujlqjav
2rOa2dBfPRsE90aVTjB2KW+Urp6zPMTrTqVOhum+3iHjpBqKyDpr4eax5sYoDQJ4
DQjyPtACpTwLtOgSCk5JY8c4coXE8TaKEzj45N6cUF9HrCK2STml0/yytOg5ep+8
oW9qUJXjMRtbv4TuTSdH//eUb2EjKoJAZx7LmhJ0RMr27xJ0aczZ7RcI5QZcv409
doqTW/Wsf3RVLDAe8MsQ7TWQEbZAPb27buEubYZ6t+Xt+O7sZjIAbiCDIh0SOlkF
PX0dA3DiTZehnpcXoeMX//BqCkHezCxor5GNxYp5xc8Joyh++4CId1MfhXqzb50l
foK5JhyNxxNEEnmcI5eBlk9oAn2UMg/i5H7b85R8PndV/VJ2vdGgYjNXAYd+IpoP
i3JNAI8BPtklkZMldN/JYi6h5wuQWIfVOHNn+G7uAGUT41FKAeOtts9JH6/PCVFX
zrs2kL6lWMJiXykeu5+E
=vb/g
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Dec_2013_07_43_30_+1100_D+qEVVyQtU0F1iWS--
