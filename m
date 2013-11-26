Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab3KZDyU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 22:54:20 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:32944 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751119Ab3KZDyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 22:54:19 -0500
Message-ID: <1385438057.23855.36.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.2 73/87] fs: buffer: move allocation failure loop into
 the allocator
From: Ben Hutchings <ben@decadent.org.uk>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, azurIt <azurit@pobox.sk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>
Date: Tue, 26 Nov 2013 03:54:17 +0000
In-Reply-To: <20131125151339.GS3556@cmpxchg.org>
References: <lsq.1385387069.559528559@decadent.org.uk>
	 <lsq.1385387069.232027452@decadent.org.uk>
	 <20131125151339.GS3556@cmpxchg.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-xQCGXXfKzwhoSZUuYrRK"
X-Mailer: Evolution 3.8.5-2+b1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xQCGXXfKzwhoSZUuYrRK
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-11-25 at 10:13 -0500, Johannes Weiner wrote:
> Hi Ben,
>=20
> On Mon, Nov 25, 2013 at 01:44:29PM +0000, Ben Hutchings wrote:
> > 3.2.53-rc1 review patch.  If anyone has any objections, please let me k=
now.
> >=20
> > ------------------
> >=20
> > From: Johannes Weiner <hannes@cmpxchg.org>
> >=20
> > commit 84235de394d9775bfaa7fa9762a59d91fef0c1fc upstream.
> >=20
> > Buffer allocation has a very crude indefinite loop around waking the
> > flusher threads and performing global NOFS direct reclaim because it ca=
n
> > not handle allocation failures.
>=20
> Please don't apply this, it's part of a bigger series and was only
> tagged as a reminder.  I'll send the full series to stable when the
> current cgroup instabilities are ironed out, just to be sure these
> patches are not the problem.

OK, I'll drop this.

Ben.

--=20
Ben Hutchings
Usenet is essentially a HUGE group of people passing notes in class.
                      - Rachel Kadel, `A Quick Guide to Newsgroup Etiquette=
'

--=-xQCGXXfKzwhoSZUuYrRK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIVAwUAUpQbaee/yOyVhhEJAQpd5g/9F/stnJhlloGudUPDQAdTR5X5IbNTgDLQ
z761Y4H6V/7HTSkW2pOguMozIwx5PArAycXnMJBesqmJ9RNxgdDAalTuTVrD2VTb
hmwzJmrwuTcOlLIdOF6s4Ybv8LM9zr7Q/9dGAp3xWAffCLKjyFStmHsJOWEknmzZ
0FZpHVizyYhcPQMq5m+neUDjMuizNcLHX4qiVjeHEhbQm3IKxIBlac+mMUrTnFsv
l+P/wMAS4G98ZVvks6RmScBP+t27CanuuSG+jHnmZv9iS2U+jAo1qeJsPLzve/7a
djZZ5rdXCIRtdDKC4tV7OqY+zcDWyhrZwP68LYCcha22vn8R3AKZUR8pVulMgSAX
gBwaPlBPHmuD58z3p4B+H5imhnTs9CKngDJfree2phlS88H03UUrdUJBsq2VBqx4
QJ603/Hin7kY3XguruyZBMJWC7POmTdwgPIGHABf+GyQioV+msY3wR0Kw74DEqYV
t7wXVqAgTsjoKwjkFvWNydwTlJhN1gUihrqCNitoFOFJ1bqNRBMWh9EgllMtssDb
+/jk2LgptUgRcf4MQcQ5xItztH2u2RRgZiRegBzcK+ee9fCf7Kd7yT67FTOjAf4P
TMb6g5axSEjmq6ZggdU7tqyFkx5ph4hM0HOqF3NM7yru7RkUtAVILBy4uCMefToO
Nhz+zEljcXA=
=kfSr
-----END PGP SIGNATURE-----

--=-xQCGXXfKzwhoSZUuYrRK--
