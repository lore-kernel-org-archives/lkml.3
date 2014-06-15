Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751330AbaFOJig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 05:38:36 -0400
Received: from mail.kernel.org ([198.145.19.201]:59142 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbaFOJif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 05:38:35 -0400
Date: Sun, 15 Jun 2014 11:38:25 +0200
From: Sebastian Reichel <sre@kernel.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton@enomsg.org>
Subject: Re: [PATCH] MAINTAINERS: power_supply: update maintainership
Message-ID: <20140615093825.GB29771@earth.universe>
References: <1946020.rieJTheGae@vostro.rjw.lan>
 <1402759929-15418-1-git-send-email-sre@kernel.org>
 <20140615112042.4e72c1f8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TRYliJ5NKNqkz5bu"
Content-Disposition: inline
In-Reply-To: <20140615112042.4e72c1f8@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TRYliJ5NKNqkz5bu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

On Sun, Jun 15, 2014 at 11:20:42AM +1000, Stephen Rothwell wrote:
> Hi Sebastian,
>=20
> On Sat, 14 Jun 2014 17:32:09 +0200 Sebastian Reichel <sre@kernel.org> wro=
te:
> >
> > Take over maintanence for orphaned power supply subsystem
> > and move the git tree to a new kernel.org based repository.
> >=20
> > Signed-off-by: Sebastian Reichel <sre@kernel.org>
> > ---
> > Hi,
> >=20
> > As suggested by Rafael in [0] I volunteer to take over the orphaned
> > power supply subsystem.
> >=20
> > [0] http://www.spinics.net/lists/kernel/msg1744793.html
> >=20
> >  POWER SUPPLY CLASS/SUBSYSTEM and DRIVERS
> > -M:	Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
> > -M:	David Woodhouse <dwmw2@infradead.org>
> > -T:	git git://git.infradead.org/battery-2.6.git
>=20
> OK, the master branch of that tree is in linux-next as the "battery"
> tree.  My contact for that tree is Anton Vorontsov (cc'd) and its
> latest commit is from January.

He switched with Dmitry Eremin-Solenikov in January:

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/MAINT=
AINERS?id=3D573189354b7c97cd2256b87cf083ee435584594e

> So should I dump that tree in favour of the one below with you as
> the contact?  If so, whatr branch of that tree should I fetch?
> (And should I change its linux-next name?)

No. David Woodhouse offered me git access to the existing tree
yesterday and Dmitry suddenly gave a life sign again:

https://lkml.org/lkml/2014/6/14/94
https://lkml.org/lkml/2014/6/14/106

In short: ignore the patch. Probably your contact should be changed,
though.

-- Sebastian

--TRYliJ5NKNqkz5bu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTnWmRAAoJENju1/PIO/qas+MP/RjHMNIIpPyImrlOUAQsk647
SqtFrnQh77tPVzQBe3Ruf7693TEZC8ElYXbQQeZm5/3LERcAw+eiTc7ZEhpl4XR6
kCDNdwnserPKztCLXQQVJ2ulYdQY0PEBpH9gDOkUOC+XlVdAxzYckeKX8PatHZey
xAbJERE1NEXUSAsAzCdugecZ080pO53uDyRFs8gaQMvVwdYksfZXjIU/zDoyQjsb
Ny6DaH6rHRNvQ+MaLJVhY/p72p85dBpCSkKtK5sbdTfa+Myyh2g+2PydtQM6ODGw
T3lmeJu0fHRa2HeHak9rP07kqr4C7ELFI5hE/ATMcv2cpI9yGm9V/eDVS6FQ/r1t
cxJLKtdmbkr9CBUOSFFcBEm3nImyRJt3Y6+zp4+dOQbsyz41onsNhss8WRxdPQ3u
qA6h0TKIDIcWZ1zgxA6oqSo7HaOSUEtv9Z76hTQM6oHpJmMIBAb/weWVHxJzj/4r
/6rSwNP5l+fjRQEM2Xij6X4gkUuK0xFXN/G0aZLQc9ckpyBTYAMkJouvtmfpz6iJ
X83n7pAytsdNcm1KWUc14iQeuohdMt4h5MpBIz+8NA9jEaCE7U/VzzMbZ0LL4X8z
ara8FIuniNxxn2ZkOg3311U1hpsTk6a6P7hJS+qufYQpFfiC419myHma2Q9tPd0A
ZlaoYLCojHZGqbCA6p+L
=oWdI
-----END PGP SIGNATURE-----

--TRYliJ5NKNqkz5bu--
