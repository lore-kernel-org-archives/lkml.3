Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845AbaFXX7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 19:59:38 -0400
Received: from ozlabs.org ([103.22.144.67]:41480 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963AbaFXX7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 19:59:37 -0400
Date: Wed, 25 Jun 2014 09:59:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Moore <paul@paul-moore.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        James Morris <james.l.morris@oracle.com>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: linux-next: the selinux tree needs cleaning up
Message-ID: <20140625095928.3161ebe1@canb.auug.org.au>
In-Reply-To: <32647147.KmAPzBrbMT@sifl>
References: <20140618084046.1bce12cc@canb.auug.org.au>
	<20140620085931.6427678d@canb.auug.org.au>
	<1474416.aEfMv8Ny53@sifl>
	<32647147.KmAPzBrbMT@sifl>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/B=lbAxXCGsgWy6geVO_AYlu"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/B=lbAxXCGsgWy6geVO_AYlu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Tue, 24 Jun 2014 14:03:08 -0400 Paul Moore <paul@paul-moore.com> wrote:
>
> On Friday, June 20, 2014 12:06:28 PM Paul Moore wrote:
>=20
> {big snip}
>=20
> > Stephen, assuming for a moment that I created a fresh branch, based aga=
inst
> > 3.15, and then added the SELinux patches for 3.16 (basically the few new
> > patches that were in the ole #next branch) would that serve as a reason=
able
> > basis for a new SELinux #next branch?  Around the -rc5/6/7 timeframe I =
would
> > send a pull request to James to pull from this next branch into the Lin=
ux
> > Security branch for 3.17.  Once 3.16 is released, I would merge that in=
to
> > this new #next branch and continue with the next round of patches.
> >=20
> > FYI, more or less, the above is the process we've settled upon for all =
of
> > the trees that get accumulated into the Linux Security tree.
>=20
> Does the above work for you in linux-next?  I'd like to try and resolve t=
his=20
> sooner rather than later and I imagine you feel the same ...

Well, I see that James has pulled your tree, so past problems are now
moot. He has some duplicate commits in his tree now and Linus will get
a few more when he next pulls James' tree.  We just need to avoid this
going forward.  And given that James or Serge will, from now on, *pull*
your tree (not cherry-pick from it), things should be fine.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/B=lbAxXCGsgWy6geVO_AYlu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJTqhDnAAoJEMDTa8Ir7ZwV6VkP/3Ww0fkWRIfibWMbeHNzdImS
zdksO+M9iRIKGRklU2W3Ccu6wAPGCe6qNSEqr4DhCFLLxk3aKJ5XgMr3GkflFZj8
kGj2hf1R+Tf6FOfOoBSudhcIyt0yV5ZtwnCtN40yetZybG2uEokvQUYJoxPyuach
HotiyWBw+LK9ObD8/ASFyToweGW06oqBURlzKKjzOXT6ENZgPj4MW2VoKuF/NrhX
KVEzaX5LhRkxXAfTxlyG5AMGPbgMHvCXScryO7u9kxtT33O5i8T/GYrV6IuY35vY
H/hwdGLxeI7TZ/6Va9Tw2CTwssEOmHUS9Qvt+DBL7Y0Vv6jwTogVIQvR2MAOsIuV
FaEJJ5N8JwvLegWe8b3jZSq4Ngvs4rS/kyMR5qua1mqykhSdWKXiYfgeSk+fZAPB
6lJMFZk4ffQUMdtdZEeNL11GJ7cQPjPnezcjFNbCenI63MdgZrFagmOZW3tu4KbG
fahzech1D7TPEj4M45bpgaBRtGQ2QWKQgp1sROLdoTDFQpJgi5b4+GdDtr8GAy8H
HC4VsDmUDKnkPyjgF7cXzoUmy3h5UnnxlrLQ23SuNkDqydTm4LoINE2IdapL7nGV
d1h8XNs7yUbv+QM6vS3nd6+o0VYPW0D2cq9F2D0upEnokohuUsW4XwjiH2+cmwqq
uqo/niiVWu4tTX+qC2X+
=dnts
-----END PGP SIGNATURE-----

--Sig_/B=lbAxXCGsgWy6geVO_AYlu--
