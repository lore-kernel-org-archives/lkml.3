Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027AbaGaGxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:53:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:45693 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755522AbaGaGxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:53:20 -0400
Date: Thu, 31 Jul 2014 08:53:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Davidlohr Bueso <davidlohr@hp.com>, mingo@kernel.org, jason.low2@hp.com,
        aswin@hp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -tip v2 6/7] locking: Move docs into
 Documentation/locking/
Message-ID: <20140731065308.GL19379@twins.programming.kicks-ass.net>
References: <1406752916-3341-1-git-send-email-davidlohr@hp.com>
 <1406752916-3341-6-git-send-email-davidlohr@hp.com>
 <53D95D68.1000402@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EpkyL+bqoEXyQ6vo"
Content-Disposition: inline
In-Reply-To: <53D95D68.1000402@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EpkyL+bqoEXyQ6vo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 30, 2014 at 02:02:32PM -0700, Randy Dunlap wrote:
> On 07/30/14 13:41, Davidlohr Bueso wrote:
> > Specifically:
> >   Documentation/locking/lockdep-design.txt
> >   Documentation/locking/lockstat.txt
> >   Documentation/locking/mutex-design.txt
> >   Documentation/locking/rt-mutex-design.txt
> >   Documentation/locking/rt-mutex.txt
> >   Documentation/locking/spinlocks.txt
> >   Documentation/locking/ww-mutex-design.txt
> >=20
> > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
>=20
> Did you read and use Documentation/SubmittingPatches?  see:

Not in the last few years, covert changes to that file are likely to be
missed by everybody already doing kernel work for a living.

> Please use "git diff -M --stat --summary" to generate the diffstat:
> the -M enables rename detection, and the summary enables a summary of
> new/deleted or renamed files.

Pretty pointless as I'll pull the lot through quilt, which will destroy
any such niceties.

--EpkyL+bqoEXyQ6vo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2efPAAoJEHZH4aRLwOS6NpAP/jFXN2mlMrtsNmIxNsLoySOX
g1x2Flm+FOgL/TZ6b1Ng/UZL1zvjD7r2feGa6H0FFi7Qf24ufd6/qabHbXkswdzU
3RDhEiR6v4W4rQWatI00WfAl+AtyjzcLR55ngcM2G2SLWXgJTR4TxsdUFdtzd8t6
t4EcX5DD2sM1MDUirH5mGezu8irrX0rUc5UclVhuYpDN0ihWY4AQkdx5xZwIBskm
kGdh/rIwcPUTrP3Ln1W6SnDjPcvrCaFUz22zBpLvAjqLxyEcDlwUPJ5rTtNtsgu+
PSWaSZFUe+wrsDVYesPzqbloRbTILtqwvqhMudd6KAgkpIr0t/fSnJx7jUtAleoN
PWywinbFCekAqiK8d/frAYHqgr6spm7ENypgPAaq5I4nW5/sIXoRCKu+USrcBD6H
slHbBJaW+o1dyUXh5q5r1G+e/2KlRN5sjOgR3vY4I+LXN3yEfJS2GsWMd6SaCTEz
ZCm72PTGbn8gg1D365RGFzIHMmCThQyoOdwRRdX2TRQukKtscXEmF3JydS2IximT
zVNgFv7a2SCleiG7WRBB0Aqzhew3A9hNXE4MZ/R+kO7tRS39CGcR9p0CpL+Rhfrt
UHEduG2apqVp+uZXEWSJKgISxKcw2QWZoShpyVyj2cBhcHzQvd5TO47cnRsHcfSr
lh5W7+GQ1+jTyJ9mYxQx
=1LLN
-----END PGP SIGNATURE-----

--EpkyL+bqoEXyQ6vo--
