Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755230AbaIVXoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 19:44:13 -0400
Received: from ozlabs.org ([103.22.144.67]:36335 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755157AbaIVXoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 19:44:10 -0400
Date: Tue, 23 Sep 2014 09:44:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: josh@joshtriplett.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: Please add the tiny tree to linux-next
Message-ID: <20140923094403.2f5a24dd@canb.auug.org.au>
In-Reply-To: <20140922225156.GA929@cloud>
References: <20140922175301.GA27348@thin>
	<20140923083442.15400844@canb.auug.org.au>
	<20140922225156.GA929@cloud>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i586-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/eiaAutw3.XLifCpfatfwrUb"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/eiaAutw3.XLifCpfatfwrUb
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Josh,

On Mon, 22 Sep 2014 15:51:56 -0700 josh@joshtriplett.org wrote:
>
> On Tue, Sep 23, 2014 at 08:34:42AM +1000, Stephen Rothwell wrote:
> >=20
> > I do not want code for release N in linux-next until after (N-1)-rc1
> > has been released.
>=20
> So, rather than moving tiny/next-next to tiny/next as soon as tiny/next
> gets merged during the merge window, wait until the end of the merge
> window (and the release of -rc1) to do so?  That makes sense, to avoid
> causing confusion and unnecessary conflicts during the merge window.

Yes, that is exactly my motivation.

> The code in tiny/next right now is based on 3.17-rc1, and is intended
> for 3.18.  I'll send a pull request for 3.18 as soon as the 3.18 merge
> window opens, and any patches I receive after that point will go into
> tiny/next-next.  I'll wait to move tiny/next-next to tiny/next until
> 3.18-rc1 is released.

Of course, bug fixes should be merged as soon as sensible/possible in
any case.  Some people run a second branch for bug fixes which they
merge into their -next branch (if the fixes warrant it) after Linus'
merges it.  But that may be overkill.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/eiaAutw3.XLifCpfatfwrUb
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJUILRIAAoJEMDTa8Ir7ZwVBBsP/iWxdRi0RxU1LKcPZ1akVjR3
SA8M0uVWanncQ+Szu4f9GMv7X+j2bcf35TQ/33oF//aZ+qTwKIjkXgfxlnU3AaXs
CThpY7pmX+emI7fh6mzTYszB4RKXSnGAnlZQLW/UZgU7E48G6RCQZP8tcjldXRaL
hh+F+rWnYRPrWH2GxNju3GdAhmJh3/46fTFlbS8tu0InAPNGXIRGPa8fsCF0hpeW
DIDfViiQvM7NH9B2Uk4Nn3qDXkfId7yRPYFc7TJV/EcxD2qOZrqKEAx0O60mEC1g
Ms3hzYHwyyNO2KC37gDoensgaub/2sxgOEWCsLlRtoGvdcdJoeMI5yk9S8tkGABP
HPfXkRWkp0khLU+qv3zYXeM4LDQNMvR1Cm3UsnoThtO8HkAhJhYrEuOhi48kSL0u
5U5LaJZBaQcZpbQ+6vpvqklnXSpVcBLzaJ54DYdj71oowYiOD3IgcWNGZ871TmVb
wzFcijhNqXh3cfpzIPO5a9TB6WOQMtUeyGQvGc8B6vhwxVJmvnuZaWSlzXkf/JSR
EkrJ53oPT7N8lt8xgb4amMhwTbe58692/F+rSCToaux88DtT4DACq0iYmMX5o3K+
2qy6Oph0qUKMxCUnKnudtPa8xWwLaIcj0cMVGJFgffmZHfuk5BatInOIikmUUV0k
VDvRxpnlMixicoNOh87h
=o9kT
-----END PGP SIGNATURE-----

--Sig_/eiaAutw3.XLifCpfatfwrUb--
