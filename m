Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883AbaKGRuE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:50:04 -0500
Received: from sauhun.de ([89.238.76.85]:55768 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751960AbaKGRuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:50:02 -0500
Date: Fri, 7 Nov 2014 18:51:05 +0100
From: Wolfram Sang <wsa@the-dreams.de>
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
Cc: Himangi Saraogi <himangi774@gmail.com>,
        Julia Lawall <julia.lawall@lip6.fr>, Michal Marek <mmarek@suse.cz>,
        linux-kernel@vger.kernel.org, Nicolas Palix <nicolas.palix@imag.fr>,
        cocci@systeme.lip6.fr
Subject: Re: [Cocci] bugon.cocci: fix Options at the macro
Message-ID: <20141107175105.GC3656@katana>
References: <20141028151824.4b41986f@recife.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1SQmhf2mF2YjsYvc"
Content-Disposition: inline
In-Reply-To: <20141028151824.4b41986f@recife.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1SQmhf2mF2YjsYvc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 28, 2014 at 03:18:24PM -0200, Mauro Carvalho Chehab wrote:
> The comma after --no-includes makes coccinelle to not run the script:
>=20
> /usr/bin/spatch -D report --very-quiet --no-show-diff --cocci-file ./scri=
pts/coccinelle/misc/bugon.cocci --no-includes, --include-headers --patch . =
--dir drivers/media/platform/coda/ -I ./arch/x86/include -I arch/x86/includ=
e/generated -I include -I ./arch/x86/include/uapi -I arch/x86/include/gener=
ated/uapi -I ./include/uapi -I include/generated/uapi -I ./include/linux/kc=
onfig.h
> Usage: spatch.opt --sp-file <SP> <infile> [-o <outfile>] [--iso-file <iso=
>] [options]
> Options are:
>   --sp-file                    <file> the semantic patch file
>   -o                           <file> the output file
>   --in-place                   do the modification on the file directly
>   --backup-suffix              suffix to use when making a backup for inp=
lace
> ...
>=20
> At least with Fedora 20 coccinelle package:
> 	coccinelle-1.0.0-0.rc20.1.fc21.x86_64
>=20
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>

Yay, with this my patch handling scripts finally work again as they used
to! Please let it go into 3.18.

Tested-by: Wolfram Sang <wsa@the-dreams.de>


--1SQmhf2mF2YjsYvc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUXQaJAAoJEBQN5MwUoCm2mWQQAINtgQwJ9w9qsMizaDMjy6Cy
8SBWgInzmBdc85hYNulKSPv8GPe9fLXiqB7ZbGV91Jq8tWOhZjPWukqmitNtDxOM
w+rv+5+aBznKDGsZJPUe5qvR12IyS4Oud/06x/AEaZ3yTa1IqJMrzeAiqs0JKi6W
NZU2FuqO/Y9pFZsuQ2F3XC+7wt3K2ZR6PpvZF9u1JTqfg/hfn5JgdAZbTHOFWwbj
pTI4Wy8D/tLHjpDthTLRWrZ01IwI6dHsYD63MX0vO9kqrOGJa0aqBHZ68ammUJqL
sIGnVAmitj408SXMjFl3odRcNioo98r0dgzORqiSWNxZKFg7NFZ9ZPWj1LnB12Zz
Euw4Pn0oxT9F9vVTFMVBiIWV0byUvVfKFYHAqOebqTvQX1IJ0C4nnJDvFzf4QVM0
cNnB6CAQUXKR9fQKKTK717U/znX5TtpN2Us7DNtBp06yC3ZQgxMBFl+bPwjST+Dz
dqZj1GeuvDN2xo2QmMWqKaBgJb/4XE8EZJqk7alA6ZJNxeFbrw4atIq6DQ7d6B5d
NcMbqp6ffc65ROaGaZMZJA8VkGNnEVnk815iHj8FKaGdQrdqmIpmr4gRD9+nKU13
qYQCdskTIDkxQWuV5WbW+2tepZVyqWnPPCewMbJOLVk67IlQ0QJp/wQvdiZPJ0an
Jny39TrqXIhz1Rzg93bl
=BoY7
-----END PGP SIGNATURE-----

--1SQmhf2mF2YjsYvc--
