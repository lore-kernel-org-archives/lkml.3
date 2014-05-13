Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758243AbaEMAbn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 20:31:43 -0400
Received: from ozlabs.org ([103.22.144.67]:37064 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970AbaEMAbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 20:31:40 -0400
Date: Tue, 13 May 2014 10:31:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Rientjes <rientjes@google.com>
Cc: Pekka Enberg <penberg@iki.fi>, Christoph Lameter <cl@linux.com>,
        Jim Davis <jim.epost@gmail.com>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, penberg@kernel.org,
        mpm@selenic.com, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: randconfig build error with next-20140512, in mm/slub.c
Message-ID: <20140513103133.6bc4f22c@canb.auug.org.au>
In-Reply-To: <alpine.DEB.2.02.1405121336180.961@chino.kir.corp.google.com>
References: <CA+r1Zhg4JzViQt=J0XBu4dRwFUZGwi52QLefkzwcwn4NUfk8Sw@mail.gmail.com>
	<alpine.DEB.2.10.1405121346370.30318@gentwo.org>
	<537118C6.7050203@iki.fi>
	<alpine.DEB.2.02.1405121336180.961@chino.kir.corp.google.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/B=G6tMlww+oykd_M.dSPIsr"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/B=G6tMlww+oykd_M.dSPIsr
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 12 May 2014 13:36:53 -0700 (PDT) David Rientjes <rientjes@google.co=
m> wrote:
>
> On Mon, 12 May 2014, Pekka Enberg wrote:
>=20
> > On 05/12/2014 09:47 PM, Christoph Lameter wrote:
> > > A patch was posted today for this issue.
> >=20
> > AFAICT, it's coming from -mm. Andrew, can you pick up the fix?
> >=20
> > > Date: Mon, 12 May 2014 09:36:30 -0300
> > > From: Fabio Estevam <fabio.estevam@freescale.com>
> > > To: akpm@linux-foundation.org
> > > Cc: linux-mm@kvack.org, festevam@gmail.com, Fabio Estevam
> > > <fabio.estevam@freescale.com>,    Christoph Lameter <cl@linux.com>, D=
avid
> > > Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>
> > > Subject: [PATCH] mm: slub: Place count_partial() outside CONFIG_SLUB_=
DEBUG
> > > if block
> > >=20
>=20
> That's the wrong fix since it doesn't work properly when sysfs is=20
> disabled.  We want http://marc.info/?l=3Dlinux-mm-commits&m=3D13999238552=
7040=20
> which was merged into -mm already.

I have added that to the akpm-current tree in linux-next today (pending
Andrew uploading a new mmotm series).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/B=G6tMlww+oykd_M.dSPIsr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTcWfqAAoJEMDTa8Ir7ZwVFOMP/2L/ChH7fzCE3PirPajR+PYt
R8poy1StN+KM0ih9Cyo+2dVpcWxSk4AmoZUMzbi2kq7RyuqZzplnmRibC9++hG/7
Y4VoqoyK+7R5029Qk+ZpdKy8QbhgCZM9dPQ8NxhB4CEdt6pR2f8JKm6RNoqm8ucT
TFo/4BXsjqkeGiBA741Q0Ew0T8g6d2mJA8FpkheN1qXF4H8SaZVnXXepgY1Y0suI
UXcNyzWvWz9ilMf3QzyWbkU/HHo/WhJlO7UxIz0B3RrqWl5c92rrX6Cto5n9LSzU
DkpHbbHG8kQ2ZH5eWurZPh6z/36H5C3X4sTbr3t3DY4qihmPyenvA8ZkdzqRNasa
XW1yTFPmSCJuiQM/k7XIPJeJWaagZEig/YACio6IdBjIbkKjWfsGuUJPcT3CQS/G
gKZShQKJEek3C5Cd5NtsfNFPaswfU3FmfJ5ULl7nVMrOu3TqWGg8fZjI7kAL9Acx
igL/L6uanpqQ77ODrqmxFuvQbeg3nTHq1XLlXbFK7THssa4wWRO3wHIuyBgYhmQT
0duZ39JiETpuukwHjPFsaYqcdchZyQwnkM1rJIzVf57Tg6i2ns3hXKnBA/MAuY2h
T8tKPu2Ho/Ixkl99y4Z8nOEa1xgtrIG5K/ta5rgGLvixmyOyu397BPiyZTpQxYmH
8hflewb9t6yALaEQ2aJd
=OARB
-----END PGP SIGNATURE-----

--Sig_/B=G6tMlww+oykd_M.dSPIsr--
