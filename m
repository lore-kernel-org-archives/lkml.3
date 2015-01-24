Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713AbbAXWYk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 17:24:40 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54921 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbbAXWYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 17:24:39 -0500
Date: Sat, 24 Jan 2015 16:23:42 -0600
From: Felipe Balbi <balbi@ti.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Felipe Balbi <balbi@ti.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: perf not capturing stack traces
Message-ID: <20150124222342.GA26941@saruman.tx.rr.com>
Reply-To: <balbi@ti.com>
References: <20150123195128.GE26557@saruman.tx.rr.com>
 <20150123205959.GD3073@kernel.org>
 <20150123223745.GJ26557@saruman.tx.rr.com>
 <20150124151204.GF3073@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XsQoSWH+UP9D9v3l"
Content-Disposition: inline
In-Reply-To: <20150124151204.GF3073@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--XsQoSWH+UP9D9v3l
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, Jan 24, 2015 at 12:12:04PM -0300, Arnaldo Carvalho de Melo wrote:
> Em Fri, Jan 23, 2015 at 04:37:45PM -0600, Felipe Balbi escreveu:
> > On Fri, Jan 23, 2015 at 05:59:59PM -0300, Arnaldo Carvalho de Melo wrot=
e:
> > > Em Fri, Jan 23, 2015 at 01:51:28PM -0600, Felipe Balbi escreveu:
> > > > I'm using v3.19-rc5 on an ARM Cortex A9 board. Unfortunately, perf =
is
> > > > not able to capture any stack traces even though I CONFIG_STACKTRAC=
E,
> > > > CONFIG_FRAME_POINTER and CONFIG_ARM_UNWIND all enabled.
> > > >=20
> > > > I wonder if anybody else is facing similar issues.
> > >=20
> > > Did it work with a previous kernel?
> >=20
> > haven't checked with this board. First time I tried to use perf for
> > anything.
>=20
> And it is the first time I've heard about such a problem, not dealing
> with ARM myself, so I guess this is a case for looking if there was some
> previous kernel where this worked, then trying to bisect where the
> problem was introduced :-\

yeah, I'll try a few older kernels, also see if I can reproduce on other
boards.

cheers

--=20
balbi

--XsQoSWH+UP9D9v3l
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUxBtuAAoJEIaOsuA1yqREY04QAKD2Iw6pAQN7tCjURA8ll+aa
qVa14qrSQWadeqcvuNHwmtr6e0fTtVnEb5GwaNR9rG27XiteEv51WHnhGPR9bYWG
z3d5lyHF8Aha2KZH9kmzi8RBQ3MRuMmWQ1bmNDyXMTWGZxbNA7AseIS/yxEwiHAd
vP+cFPNdNCq51KhT7CYBPc0B+6ORjQ+xFZhSwyvGI3HbBjiaioJUbi/mPuFOQUyl
lMqrMNW+e8VI8rhLERWBJqmCLKWdKceWTGA35d1XwFR37gBZvJAwRCcyb68sWjfE
zgnQGng/kL3tX7JjwvRydByfsxDAf1wYKEuI6Hbxe9GY8mRn+ehkKiKhDr+cyJx9
rjOnpYksmqutKUHeA0wCSqeGeGdb7c9cXZ+Qpp2h2Mj7GU+oXYLm/fII6Q08DM+y
8S2Z4tvgYf74MAhLhEOiuy18OGk8+IaSxulfd1o97RT0Uk4pRz74YebW6AKoOlfs
42m6fjjEae5gpPe5dyOzqkdYpMQlfuv2gw4RLjVtKS62Q8ypFLY9zgwhIPnUbXG6
/2383K1A1PuBB2m2OJ5pLGkOlPGjtU3DRJfe9LHfCNr2qT3LBFzqVHIrX7bfw3eI
w+dWbKLi1R7VlVoI+3NdufdZ6lUU7BDJcDLkZAPirsYEJ5t85J8/kZSA6HULHL6U
9y7Pc+ihMmnsH63Ay2D1
=eaJX
-----END PGP SIGNATURE-----

--XsQoSWH+UP9D9v3l--
