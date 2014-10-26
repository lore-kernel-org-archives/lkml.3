Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730AbaJZXKa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 19:10:30 -0400
Received: from ozlabs.org ([103.22.144.67]:46910 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605AbaJZXK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 19:10:29 -0400
Date: Mon, 27 Oct 2014 10:10:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Maciej W. Rozycki" <macro@linux-mips.org>
Cc: Ralf Baechle <ralf@linux-mips.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] tc: Error handling clean-ups
Message-ID: <20141027101017.6af4e810@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.11.1410222234050.21390@eddie.linux-mips.org>
References: <alpine.LFD.2.11.1404062030280.15266@eddie.linux-mips.org>
	<alpine.LFD.2.11.1410222234050.21390@eddie.linux-mips.org>
X-Mailer: Claws Mail 3.11.0 (GTK+ 2.24.25; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/y+IRGFnVFnplogTnJ+nNqSE"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/y+IRGFnVFnplogTnJ+nNqSE
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Maciej,

On Sun, 26 Oct 2014 15:22:33 +0000 (GMT) "Maciej W. Rozycki" <macro@linux-m=
ips.org> wrote:
>
>  I posted this fix originally to linux-mips@linux-mips.org back in April,=
=20
> but it got lost and I don't want to give Ralf more stuff to handle than=20
> absolutely necessary, he is really busy these days.  Can you please take=
=20
> it directly to linux-next then?  There's nothing specific to MIPS in this=
=20
> code really.

I don't take patches directly into linux-next (unless they are very
specific bug fixes for things that affect my builds - and even then I
only keep them until a maintainer picks them up).

Sorry.  You could try sending it to Linus or Andrew Morton.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/y+IRGFnVFnplogTnJ+nNqSE
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUTX9fAAoJEMDTa8Ir7ZwVarMP/A9MbC9oqT3NanWmLCoR0pOb
BK14048BlWcqu0HRfh0s6B04z7QlhqdGmPKKmisX+cSpMXA9+SvYhptV18kJuV9o
PIw+Ho6qqGPyKudIECVWI+begzkznPuP8po5Tdd+FHUEI39WE0v+R9ut1JdnO56s
UOd3i6qEM6eM/eRrsgPx3jL4vgknCB0pWcFKM+coduPh7+rE90ARElqdaND+nQne
9JbjuVEiCVL//4mxARqYuo4uN/2ePADT2fuc9tojZw0HgGEC0k7oftpEUdYV9SRA
Uihnjgqnwdczbeq7NzXi5+wVOaFpC3u/C2pA79/Q15nMu1PA+orDKKLSWWg+4IsJ
gR/7fT+/3DVr/caOFzk4xJ01xdlxrX3bCvL45dYnOcGsOtz8rlEXqSK/MCWsQpQM
3FEmO9Mr1zPtEyp7qUJj8MioUONGcGPMYn4uiMwofthNVVMF+IXpyOONzlZxSKM+
9NiNoQZxFpQ92Avzn6EUZgYmqgRla+ge1UyjookarsuI43KkkY9304zbq4D6rhW+
HCrRc7MBSY9Hxlr1t+QAHQ/eoHiQOnpTr6V1cn3oaqcSP/e3fbesY6OUuT+dwfg8
XV6OtYcLJ8Ih0eHUj5KQsudEp+zlAQeOx3QAPdWGpKa/5AoAP1zkfC0FKVSHTXQe
ylMBCzV3vmRZLFGCM3I/
=h+7S
-----END PGP SIGNATURE-----

--Sig_/y+IRGFnVFnplogTnJ+nNqSE--
