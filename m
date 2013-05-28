Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758528Ab3E1BsT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 21:48:19 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:52108 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755256Ab3E1BsR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 21:48:17 -0400
Message-ID: <1369705674.3469.413.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 22/42] sched/debug: Fix sd->*_idx limit range avoiding
 overflow
From: Ben Hutchings <ben@decadent.org.uk>
To: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>, Libin <huawei.libin@huawei.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, jiang.liu@huawei.com, guohanjun@huawei.com,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Tue, 28 May 2013 02:47:54 +0100
In-Reply-To: <20130510075941.GB6364@gmail.com>
References: <20130423215205.523980967@linuxfoundation.org>
	 <20130423215207.778285571@linuxfoundation.org>
	 <1368152071.17344.5.camel@deadeye.wl.decadent.org.uk>
	 <20130510075941.GB6364@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Q2BfRcCnVb7nVWKjKyS9"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Q2BfRcCnVb7nVWKjKyS9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2013-05-10 at 09:59 +0200, Ingo Molnar wrote:
> * Ben Hutchings <ben@decadent.org.uk> wrote:
>=20
> > On Tue, 2013-04-23 at 14:52 -0700, Greg Kroah-Hartman wrote:
> > > 3.8-stable review patch.  If anyone has any objections, please let me=
 know.
> > >=20
> > > ------------------
> > >=20
> > > From: libin <huawei.libin@huawei.com>
> > >=20
> > > commit fd9b86d37a600488dbd80fe60cca46b822bff1cd upstream.
> > >=20
> > > Commit 201c373e8e ("sched/debug: Limit sd->*_idx range on
> > > sysctl") was an incomplete bug fix.
> > [...]
> >=20
> > It seems like both these commits ought to be applied to earlier stable
> > branches.  Or was the lack of range checking a regression after 3.4?
>=20
> Both should be applied indeed.
>=20
> They are not a huge problem as all these facilities are for debugging and=
=20
> are root-only, but the two fixes should be applied together or not at all=
.

I've queued up both of these for 3.2.

Ben.

--=20
Ben Hutchings
If at first you don't succeed, you're doing about average.

--=-Q2BfRcCnVb7nVWKjKyS9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUaQMyue/yOyVhhEJAQqetBAAl4WHThhR/+u92hy3RQjkxcGy1dGqAi0b
pye43gpgTWGjVhgD5DiM8KLmGpoFvG3LWQTg7Rp3r/bm7dRiGpvt3RbE3DV8jAJ3
/f6K9lB1sLMjwAE9xtUMi0gDvR1jacULxyO7HaXoyhV17fG8B9qmDCbMJYwD/sEM
7A9/YWG1eCxYbp8uuRhn2gCzpuj5jaVjoPuiEt4kjkfBf1+S4hk3MIWFKQpcNGaB
BH7QEYxvRsryYEn/cVZQg6J1iZPtBE4C0g2qlHHJm/eeecsub/aL5d0+Ux7JVclL
ZvSH67399K5GYObzxKdqNMfm8VAJHBKL+cWJa8HAUsFoB44RpjMdkqMnPcpNH2nP
Bo0HVx+knvb92C+Pbd2IT2Uf1l7DzDFdMSp1K3JG6ICqI90Wu2rAaZdpYV/RDViS
JbWftIlV0q09H7qikTDGITgcEOBZuNMDiknTe9qkrNf7qCjx4boEdztx32vwT3L6
tUnCiU9kulZFaF993Wn3oGqRSwbPi+d0sB2e13nGUVbftxR5oiZ7PS4IozqnA0LP
KHiDHPwVlZhyPo56a+HCB9ui5XOjrNFOYTOayv97Z2ZEh1WqsaA19RDNfbwn6Jl5
k+Qt0H10Tjpb0xh6uKNJ3cSAlTxbQmLxBFLWpZn+7I2ECehJJS9o1c9G6WbfJvLd
OlzE4pHEfHk=
=ae+a
-----END PGP SIGNATURE-----

--=-Q2BfRcCnVb7nVWKjKyS9--
