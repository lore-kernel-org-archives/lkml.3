Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286AbaBFONh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 09:13:37 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58251 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751352AbaBFONf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 09:13:35 -0500
Message-ID: <1391695995.3003.108.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 0/3] Fix perf build breakages in 3.13
From: Ben Hutchings <ben@decadent.org.uk>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Date: Thu, 06 Feb 2014 14:13:15 +0000
In-Reply-To: <20140206134817.GC8026@ghostprotocols.net>
References: <1391648361.3003.97.camel@deadeye.wl.decadent.org.uk>
	 <20140206134817.GC8026@ghostprotocols.net>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Ab+tx+Si/Dkg1nyuzISr"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.239
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ab+tx+Si/Dkg1nyuzISr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2014-02-06 at 10:48 -0300, Arnaldo Carvalho de Melo wrote:
> Em Thu, Feb 06, 2014 at 12:59:21AM +0000, Ben Hutchings escreveu:
> > perf no longer compiles on powerpc and sparc due to changes in the trac=
e
> > sub-command.  This series fixes those compile errors; I compile-tested
> > in Debian sid on armhf, i386, powerpc and sparc.
> >=20
> > I would much prefer not to revert the tty ioctl decoding but I think
> > it's going to take a much more sophisticated approach to do it right
> > across all supported architectures.
>=20
> Second thought on the revert one:
>=20
> Do you have a problem of switching the big hammer to one that makes this
> work just on x86/x86-64?

That seems reasonable as a temporary measure.

Ben.

> That way at least those on these arches can have this while the correct
> solution is worked out.
>=20
> - Arnaldo
> =20
> > Ben.
> >=20
> > Ben Hutchings (3):
> >   Revert "perf trace: Initial beautifier for ioctl's 'cmd' arg"
> >   perf trace: Add fallback definition of EFD_SEMAPHORE
> >   perf trace: Decode architecture-specific signal numbers
> >=20
> >  tools/perf/builtin-trace.c | 48 ++++++++++++++------------------------=
--------
> >  1 file changed, 14 insertions(+), 34 deletions(-)
> >=20
> >=20
> > --=20
> > Ben Hutchings
> > It is a miracle that curiosity survives formal education. - Albert Eins=
tein
>=20
>=20

--=20
Ben Hutchings
It is a miracle that curiosity survives formal education. - Albert Einstein

--=-Ab+tx+Si/Dkg1nyuzISr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAUvOYe+e/yOyVhhEJAQqbkA//ZzsVOQ9xnMwY8tx90x9/IGfypJNXzXHV
E1oOfDGZHYg1D/DGjQEKx7ZzgINN03XKXu7G/L4B27RSuIheXmJespj+nB8YnhSF
DaS3TZWOaYR4yKVCVYi14asYdATOW8cQljkzPlmlge1+c3RDk1jmHnhPs+SbUeeK
OvjqxF+timZCy+aW0Zg7E9UYY4A07C/sUOrIdLZO5CCrzROry6mPtZmLOGR0Db70
V/vHfw9bO2wfn+kiql3ysziN3AgBUne1Y3gGpkCaB/QAdlyedpr8h65uzB1kiFx9
e06RgZQ1GUt7igkwd+LSdp8yY6MkRbOoasSqqQN7jXj2gtAhNm1QPj4NfVS/Avle
P67pq/c8zb14a46ONA+So9RDwz5NR5wdTkq/2U9CPmzycszBls7v5DUaK6W04R0I
eQABJG5czl+sJZepskwSCPB3V1o+lM5uZFjcOOD7NXMJhk/s8U0dQCB6S1wh9ins
brzQCwG8OeR9GVbj8RI8dXhBo1GfWoRFmoJeT2GglB3Ja1PwMIeLmqjDLK6ypL5d
Aya0pYXQWnEdNKnRRnG8iH9CVmXbU/W5W4guwJzTOPBRHoFRj9olV13xL7WFsMhY
CN5RGw6bWezz91VMRNVItQ0n84UdJohbdzovilz2COmpNC5zH5iV56W24s8npkZn
UHZBJZelmms=
=6W/r
-----END PGP SIGNATURE-----

--=-Ab+tx+Si/Dkg1nyuzISr--
