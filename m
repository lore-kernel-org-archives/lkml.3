Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754919AbaKEQOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 11:14:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753191AbaKEQOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 11:14:20 -0500
Date: Thu, 6 Nov 2014 00:14:16 +0800
From: Amos Kong <akong@redhat.com>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: stable@vger.kernel.org, gregkh@linuxfoundation.org, rusty@rustcorp.com.au,
        amit.shah@redhat.com, virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [3.16 stable PATCH 0/2] virtio-rng: two backports to fix stuck
Message-ID: <20141105161416.GB19104@air.nay.redhat.com>
References: <1412981509-30025-1-git-send-email-akong@redhat.com>
 <20141104043227.GA13409@air.redhat.com>
 <20141105160249.GG9403@hercules>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gatW/ieO32f1wygP"
Content-Disposition: inline
In-Reply-To: <20141105160249.GG9403@hercules>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gatW/ieO32f1wygP
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 05, 2014 at 04:02:49PM +0000, Luis Henriques wrote:
> Hi Amos
>=20
> On Tue, Nov 04, 2014 at 12:32:27PM +0800, Amos Kong wrote:
> > On Sat, Oct 11, 2014 at 06:51:47AM +0800, Amos Kong wrote:
> > > I received two mails about faile to apply patches to 3.16-stable tree:
> > >=20
> > > FAILED: patch "[PATCH] virtio-rng: skip reading when we start to remo=
ve the device" failed to apply to 3.16-stable tree
> > > FAILED: patch "[PATCH] virtio-rng: fix stuck of hot-unplugging busy d=
evice" failed to apply to 3.16-stable tree
> > >=20
> > > Amit already backported two patches for 3.16-stable, then cherry-pick
> > > of my two patches works.
> > >=20
> > > Thanks.
> >=20
> > Ping Greg, thanks.
> > =20
>=20
> I'm now doing the extended stable maintenance of the 3.16 kernel, as
> Greg has EOL'ed it.
>=20
> Anyway, I will be queuing these 2 patches for the extended 3.16
> kernel.  Thank you!

Thanks a lot!
=20
> Cheers,
> --
> Lu=EDs
>=20
> > > Amos Kong (2):
> > >   virtio-rng: fix stuck of hot-unplugging busy device
> > >   virtio-rng: skip reading when we start to remove the device
> > >=20
> > >  drivers/char/hw_random/virtio-rng.c | 7 +++++++
> > >  1 file changed, 7 insertions(+)

--=20
			Amos.

--gatW/ieO32f1wygP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUWkzYAAoJELxSv6I5vP9jRSwP/1+dUka3wv4bPl+FG1JjKNn+
PUaJGk4zSWe9Uo8yN/+L5T/W/qvutwt4uw+IRTgRVuK2Rf8eGjZsCrmcADnCDQe1
qNFz5lkT7g47xWv/Ikr9lrigBFUJGdHmj29/FwDb7UyXNaIWmChoDULwKYAnJAg7
DqGiEOdJ4X2ztz1ieQO0VkhkDieM1p6PYkBx3JEhALlSSGt/zPLPTN0MxH5hXOv1
ivRzsV+rgG7mCrZ+IFYNuLkqd6yHvr6wU9UsvRpXknZ+h8AYn6DT4r5ZLg+Uv3XG
LeFFAqp9OFWqCryHwDPfjW+8mnCjdxddl/w86rItbG17G6NEmWG8s5JqfOiRGMFS
nMsyyCCJGx/6C39TXzym5RNk4rho2fNrE1O5qZkCs2iFIoPCiO8TuFkvq7nvZ7DX
AprV4nOVgcuKMOEEb7T3rsUzEnS75h1ZK8XmRmfERDui/d7JKRI/91+ru8TsTSbp
qUJbhCtf5F2I2woHQmCVziuez9btZ5qBx15mKtJtZvRQY6QOnFVFi3BwekZ5lEBw
Pt/PAQoDZGK/nj+Y/GFjbA/SZnL+2RXFx2EXofcYsTNTl0u5ib5d8LFuVZJGkYNZ
LeUxIeR+VIEF5IxPWKKUTMG/JjW67EoxkA8RWihT9IIU8pkzyhcodqlpErpyEt8X
f+1iwleNlwNgd1NP6+7P
=5g+q
-----END PGP SIGNATURE-----

--gatW/ieO32f1wygP--
