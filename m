Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933562AbaGPA5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:57:07 -0400
Received: from ozlabs.org ([103.22.144.67]:49356 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932935AbaGPA5D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 20:57:03 -0400
Date: Wed, 16 Jul 2014 10:56:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH 3.15 14/84] serial: imx: Fix build breakage
Message-ID: <20140716105656.539105f1@canb.auug.org.au>
In-Reply-To: <20140716004202.GB6908@kroah.com>
References: <20140715231713.193785557@linuxfoundation.org>
	<20140715231713.621762682@linuxfoundation.org>
	<20140716102414.337e58ce@canb.auug.org.au>
	<20140716004202.GB6908@kroah.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/4jrN1Qt+K2_/Yk+NcnT.ZNa"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/4jrN1Qt+K2_/Yk+NcnT.ZNa
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Tue, 15 Jul 2014 17:42:02 -0700 Greg Kroah-Hartman <gregkh@linuxfoundati=
on.org> wrote:
>
> On Wed, Jul 16, 2014 at 10:24:14AM +1000, Stephen Rothwell wrote:
> >=20
> > On Tue, 15 Jul 2014 16:17:11 -0700 Greg Kroah-Hartman <gregkh@linuxfoun=
dation.org> wrote:
> > >
> > > 3.15-stable review patch.  If anyone has any objections, please let m=
e know.
> > >=20
> > > ------------------
> > >=20
> > > From: Peter Hurley <peter@hurleysoftware.com>
> > >=20
> > > commit 8bec751bd63847b4044aab8b215db52aa6abde61 upstream.
> > >=20
> > > Fix breakage introduced by
> > > commit c557d392fbf5badd693ea1946a4317c87a26a716,
> > > 'serial: Test for no tx data on tx restart'.
> >=20
> > That commit only entered Linus' tree at v3.16-rc5, so this fix
> > shouldn't need to go into 3.15-stable (unless the original patch was
> > backported as well - in which case maybe the backport commit id should
> > be mentioned as well).
>=20
> c557d392fbf5badd693ea1946a4317c87a26a716, is marked for stable (and is
> earlier in the series) so leaving this as-is, should be fine, as that
> commit id will show up in the stable kernels as well in the changelog
> entry.

Ah, ok.  So you don't merge "fixes for fixes" to save bisection
problems, then?  (Just asking)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/4jrN1Qt+K2_/Yk+NcnT.ZNa
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTxc3dAAoJEMDTa8Ir7ZwVXR0P/i/zoqUo9Q07Pkyi3/Cdt1aH
T0HpTWBOMLPtUPYDcpDd5Yqg8Jvjs73dZmA0aL4N3yE8DUfmGC8yB827MU/BWlv5
9eqkOBGqepPw/ljYs+oQRAjoSFC2MY09/oaTSjjZX5xvHKLN9mBM/2vQUtCjUDi4
JX5JGzE25pvaLuJZVpgvcxh6LoUu0kjVm3CORb/J2cPkNqmYF/NB1rAUwDCHULSE
asksooMsce6Luvf4vZXBeY2WVdJkMCpGoAiDfdlH/xV74lxdsej8eCQTgJlz/L1J
q1rdhJgmLmSwNOr44lkfCmZNYez7VSjnMKpTc0JuQy1Q9LRx6o8rjSuf2Be0Cfk3
21OeFAJnDe8T9JW9akrTT8y+I+9BNsxnTbH7UZk307LUsHDyAi+oO1tFr7QcCmE8
aj2zpOnBIL8eTTS5KhNu8adYl04kLDuYxXnmsoZ0JXl+Kbh+bJwiw8oaAmh2gkMS
wL9b8N8iMM8z0RkN/ylsFuglxv0ZA6RbAfTLJCkWcNZu1W+HfxLY91/UqSy06mfw
sgatfhAQmHXq4dYS874uj2OoPzA8Iv8HSZmobyjm3+qKmX9FAVvtvkVBOPU+jAZE
VtBwkryF/gH4Z/Rn6IVBBouc265vYLW3sFefRbGreeyOzaWqQmh9Q79KF4858/Rw
NSY+9Ws4Qw9J8XGo6UhN
=btCR
-----END PGP SIGNATURE-----

--Sig_/4jrN1Qt+K2_/Yk+NcnT.ZNa--
