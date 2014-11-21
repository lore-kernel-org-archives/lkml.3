Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbaKUSGa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:06:30 -0500
Received: from sauhun.de ([89.238.76.85]:53397 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbaKUSG3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:06:29 -0500
Date: Fri, 21 Nov 2014 19:07:47 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>,
        Michal Marek <mmarek@suse.cz>
Cc: Nicolas Palix <nicolas.palix@imag.fr>, linux-kernel@vger.kernel.org,
        Himangi Saraogi <himangi774@gmail.com>, cocci@systeme.lip6.fr
Subject: Re: [Cocci] bugon.cocci: fix Options at the macro
Message-ID: <20141121180747.GA3754@katana>
References: <20141028151824.4b41986f@recife.lan>
 <20141107175105.GC3656@katana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k1lZvvs/B4yU6o8G"
Content-Disposition: inline
In-Reply-To: <20141107175105.GC3656@katana>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k1lZvvs/B4yU6o8G
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 07, 2014 at 06:51:05PM +0100, Wolfram Sang wrote:
> On Tue, Oct 28, 2014 at 03:18:24PM -0200, Mauro Carvalho Chehab wrote:
> > The comma after --no-includes makes coccinelle to not run the script:
> >=20
> > /usr/bin/spatch -D report --very-quiet --no-show-diff --cocci-file ./sc=
ripts/coccinelle/misc/bugon.cocci --no-includes, --include-headers --patch =
=2E --dir drivers/media/platform/coda/ -I ./arch/x86/include -I arch/x86/in=
clude/generated -I include -I ./arch/x86/include/uapi -I arch/x86/include/g=
enerated/uapi -I ./include/uapi -I include/generated/uapi -I ./include/linu=
x/kconfig.h
> > Usage: spatch.opt --sp-file <SP> <infile> [-o <outfile>] [--iso-file <i=
so>] [options]
> > Options are:
> >   --sp-file                    <file> the semantic patch file
> >   -o                           <file> the output file
> >   --in-place                   do the modification on the file directly
> >   --backup-suffix              suffix to use when making a backup for i=
nplace
> > ...
> >=20
> > At least with Fedora 20 coccinelle package:
> > 	coccinelle-1.0.0-0.rc20.1.fc21.x86_64
> >=20
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>=20
> Yay, with this my patch handling scripts finally work again as they used
> to! Please let it go into 3.18.
>=20
> Tested-by: Wolfram Sang <wsa@the-dreams.de>

Ping.


--k1lZvvs/B4yU6o8G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUb39zAAoJEBQN5MwUoCm2WAIQAIiia6sa4828LTsCJMVDrloV
ChhytUvmmQZkcSYyd82RH7GVTm3bqj9a2rWBwj8f5Nh3PZS/oICbmDLzUZVrh955
hYA4Beb2ZamuT8uLj7KjQL2a042o8QB4pukekaIvQKC7OFS2SDSiiF6NK5jWwOWi
PaDJM8uVYu7kpfuVKbz/qdkyjvwmjrqDDFBOfSB04FAq9D3OkzcSeaJAoegyO7Et
OmavRlUHw8Hb+75ccGuDYAQm1ibbVDouCjM4NKAf8nwWcXAQDn0V4Vx8FGmL5h2r
3RYjhRk2bLf4GrEoF+se2dkDMbZ5Qqke7haYo5DW7KLPfRRRYT6WJDUtExmGWZkj
z12LeDK4Gt/ymhBpKIWkhMK7Oz8XmRQ4jOk8acmwHSeAdUPJhOHuL0cGzWOmB4c1
OjJP+v1dfOLj66qSEwqq7i294MFBrzGHiIfq4db6tMRH/5RWwA2YQo2wCxVQOqkH
77f3ne3RcuMg/XeffbM88xkP4qGN87FNMmyl0DiEBuSMxOS3/kY+s6bYsU3b/Kz7
S2LLH0Sjg/rC4NPNjhy6QsonVLspUTMR4tmcyEIIyGgVxzF3zXoTMBhZLseku6be
dVj3vk4xVETNigyilq1kJvmgq82PAilm7JvOOp0ZIjpF+x+50GUPN0guv40cnYwi
joXqdriXUgc9J9U8KoID
=CZbr
-----END PGP SIGNATURE-----

--k1lZvvs/B4yU6o8G--
