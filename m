Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755581AbaHFEqw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 00:46:52 -0400
Received: from ozlabs.org ([103.22.144.67]:40454 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754758AbaHFEqv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 00:46:51 -0400
Date: Wed, 6 Aug 2014 14:46:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Containers <containers@lists.linux-foundation.org>,
        <linux-fsdevel@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] namespace updates for v3.17-rc1
Message-ID: <20140806144643.45e5dab8@canb.auug.org.au>
In-Reply-To: <87fvhav3ic.fsf@x220.int.ebiederm.org>
References: <87fvhav3ic.fsf@x220.int.ebiederm.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 boundary="Sig_/ldyByQSDKEd2wn32YQ=Q0EM"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/ldyByQSDKEd2wn32YQ=Q0EM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Eric,

On Tue, 05 Aug 2014 17:57:31 -0700 ebiederm@xmission.com (Eric W. Biederman=
) wrote:
>
> Please pull the for-linus branch from the git tree:
>=20
>    git://git.kernel.org/pub/scm/linux/kernel/git/ebiederm/user-namespace.=
git for-linus
>=20
>    HEAD: 344470cac42e887e68cfb5bdfa6171baf27f1eb5 proc: Point /proc/mount=
s at /proc/thread-self/mounts instead of /proc/self/mounts

This has had 4 commits added since the merge window opened that have no
Reviewed-by, Acked-by or Tested-by tags and only one Signed-off-by tag.

> The last change is a small semantic cleanup introducing
> /proc/thread-self and pointing /proc/mounts and /proc/net at it.  This
> prevents several kinds of problemantic corner cases.  It is a
> user-visible change so it has a minute chance of causing regressions so
> the change to /proc/mounts and /proc/net are individual one line commits
> that can be trivially reverted.  Unfortunately I lost and could not find
> the email of the original reporter so he is not credited.  From at least
> one perspective this change to /proc/net is a refgression fix to allow
> pthread /proc/net uses that were broken by the introduction of the network
> namespace.

They appear to include this last change.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Sig_/ldyByQSDKEd2wn32YQ=Q0EM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJT4bM4AAoJEMDTa8Ir7ZwViE8P/2Ok1V6Oi5EZ4tUBzBDVDB9q
cz1LRHeoMqTDjfQrFTPJ8bXcDt1rW9aYCci+0uFgeP13XkHqMBHMktReBYfr3W3H
dZOoYwisaI/fDy7STICurMGGmS9LEYQ7YCntrMq679FPAfHK2nTTbE/JpTChhlVr
6TiGIitU0wQTeSxFSQwXbr2AsQ8SzlDviuhmmBRjUBCP/NA4/I9W0uEVfZliO5Sa
0L312fmjFIStrSR0auUdvhE2dplkTZXXKrJBQGhGTnJ+UqXtam+2fjTvChYlt4bx
JlsqIG58J5u+2YOi8EeS6OxCQyoP+j/qFCcHe1j2G7cXRcF1svYlI0MjzB139gVQ
6HGeOXj/rW5w2hZxOVDeWN3QQRSZrwv0QRQ0VC5he9skiIhDt+9cB/qehX98ttQG
CQtZQJemFP9yutB7YxJL+d3WusSjGQnQ30y3W5Sy6+2DiQaK77adP+3ppBD9zjRW
/6fLYs2fvFyXEO4n/cfifzBv47eOfNr7x+kQRCKEIsvi//5vV017nF2XfsaXrLb/
qtu7RlM4Q80Ty3ab6JEhZ80DfoBX6fUoocR8A7XeA5CyjpGvYmUoWf9WBQuHW3r2
b1+No4/d30JoWhM9JuUKe+i0O4NVo2UPh9KUfhywrWFMF1tCoQrUnqk6akFdHups
zifFHi4S+VfJRvjECbdJ
=Hqul
-----END PGP SIGNATURE-----

--Sig_/ldyByQSDKEd2wn32YQ=Q0EM--
