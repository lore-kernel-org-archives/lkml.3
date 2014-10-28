Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596AbaJ1VO4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 17:14:56 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45199 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaJ1VOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 17:14:55 -0400
Date: Tue, 28 Oct 2014 16:14:31 -0500
From: Felipe Balbi <balbi@ti.com>
To: Albino Biasutti Neto <bino@riseup.net>
CC: <balbi@ti.com>, <linux-kernel@vger.kernel.org>
Subject: Re: Errors: Compiling 3.18-rc2
Message-ID: <20141028211431.GF4740@saruman>
Reply-To: <balbi@ti.com>
References: <CA+bYFQZ2T4XPVhnZzfB5yWt6J11SDWf_5KzguEX0VZqmkVxYhQ@mail.gmail.com>
 <20141028194532.GK25735@saruman>
 <CA+bYFQbr4RB6XcZYD5b9W_kG6h+kvhGna0e2we67hA+Yr13wdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B0nZA57HJSoPbsHY"
Content-Disposition: inline
In-Reply-To: <CA+bYFQbr4RB6XcZYD5b9W_kG6h+kvhGna0e2we67hA+Yr13wdw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--B0nZA57HJSoPbsHY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 06:39:39PM -0200, Albino Biasutti Neto wrote:
> 2014-10-28 17:45 GMT-02:00 Felipe Balbi <balbi@ti.com>:
> > On Tue, Oct 28, 2014 at 05:41:53PM -0200, Albino Biasutti Neto wrote:
> >> Hi
> >>
> >> I was compile kernel version 3.18-rc2, very errors:
> >>
> >> # make -j2
> >>
> >> fs/open.c:822:1: error: expected identifier or =E2=80=98(=E2=80=99 bef=
ore =E2=80=98<<=E2=80=99 token
> >>  <<<<<<< HEAD
> >
> > looks like a merge conflict annotation. Are you sure you didn't have
> > merge conflicts ? What does 'git show' return ?
>=20
> $ git show
> commit e29bfaac2d572915513c1ec78c61a93373967251
> Merge: 536a517 f7e87a4
> Author: XXXX <xxx@xxx>
> Date:   Tue Oct 28 17:29:46 2014 -0200
>=20
>     Merge branch 'master' of
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux

yeah, you merged linus' HEAD to another branch and you didn't fix any of
the merge conflicts ;-)

Try the following:

$ git checkout -b linus v3.18-rc2

Then you know you'll have a clean HEAD.

--=20
balbi

--B0nZA57HJSoPbsHY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUUAc3AAoJEIaOsuA1yqREpX8QAJjmHHm2mjcnrkWXvFwkvb+z
fIFwx64NC8SM9Z5IjcLvpE0XFphaH6h9+fb/Dyle4N5Sbmjpxf9TK8m1tAN9wdQG
JrdDQBDHtEE8OQgKjkmW+nqZg6ry3HCHNW7M36rAf2d4gFOSgYNB5jXbI9KeQwJz
mImY6dJARLD+P2v1BafGy8PbKCpknBIYopkalkq6+nDpIhgLo+xVu3ymjQ3/gsIm
LFEArRHFqKshEfVcNKeVmKx0EXlsWD5OluR+TX51b9vR2YadWAITaSv+xQs0LsnZ
p77iHLozOIDJNrqBXuyisuZ1hIuTBoPoKAmSYAL3QChldJptukYtNEvhYLpGR+hR
RCvpMhkVxaNQtpuhjvabNott9j5SBnvmsGC/hAHBI4J0nOq6Bt43bG3X17/ONX42
md0RM0sC1kIQqi79QTYKVOeuFt33aRmdeNmo3gfiVq3DN0W5UXqeBZr9mpWgNLw+
BI23YlbXhVplaQH3IID7IFPKnusvP66yqLS0OpanDdyRlzUX01ApqSFPVCYRgzlE
5Yngvqu5i0JzcJIAH1KyGIgE2IVfyMmH++1QcIu7r3BaUZ7MxyYNE2ydOA8LUqdy
pqfdQb6HwsZKLVvHXYfNenwWiUvgn+UpOFcIRHcoXUZ1EwAaTc0sccqeYHLdUiRF
CKYFukflaLcQM6QHwuRo
=uFVH
-----END PGP SIGNATURE-----

--B0nZA57HJSoPbsHY--
