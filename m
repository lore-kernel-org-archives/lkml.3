Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936286AbaFJHmt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 03:42:49 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57325 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933692AbaFJHms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 03:42:48 -0400
Date: Tue, 10 Jun 2014 09:42:42 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Stanislav Fomichev <stfomichev@yandex-team.ru>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Stuart Hayes <stuart.w.hayes@gmail.com>, david.vrabel@citrix.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] hrtimers: add fast path to hrtimer_get_next_event
Message-ID: <20140610074242.GW3213@twins.programming.kicks-ass.net>
References: <1402305825-3015-1-git-send-email-stfomichev@yandex-team.ru>
 <alpine.DEB.2.10.1406091304140.3830@nanos>
 <20140609111115.GK26511@stfomichev-desktop.yandex.net>
 <20140609125931.GL26511@stfomichev-desktop.yandex.net>
 <CAKohpon3s3P2WE8oGiKgw8BU-3zGCPPjq=Bo9gAG4+7vVhTfdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+1d8mk/W7pQzMfc7"
Content-Disposition: inline
In-Reply-To: <CAKohpon3s3P2WE8oGiKgw8BU-3zGCPPjq=Bo9gAG4+7vVhTfdw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+1d8mk/W7pQzMfc7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 09, 2014 at 06:58:56PM +0530, Viresh Kumar wrote:
>=20
> Even I was concerned about a bigger diff earlier and so didn't comment
> to rewrite it this way :)

WTF is wrong with you people? Who bloody cares how big diffs are? The
clarity of the resulting code is _far_ more important.

Please as to stop taking bong hits.

--+1d8mk/W7pQzMfc7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTlrbyAAoJEHZH4aRLwOS6eYAQAJvn/+hweFmTbz3qF4jm3iX+
Bti8R0Rc0Act+EqwTvuMHgpdN8CnvPvWSXB3ICor5A+/KW6F1XpaUP2bK27CErsd
QQR7x/R0yCu+KnB4j9W3PgJ2StP8owwAbGQJmFbOg6tSlwnxxwSsOmM0piYa61T2
KDpaeSpC0rgGZYYNqEWiCxPj69m4dFIQN3ryd0hsI/p47FcuNaXwiUSNKtgo0Uh9
fAxFODRokbPC3PFzv1YcMRW2I5HpE2ivA+ejikY3UdJEj0iTorviwcsfMmCS1b1W
TzC3MgnWfWZWJ9rlRkSfso0/ZX1TLwqZImYIEOglj5bRS1syDydJPfQsIO1IktPy
9ChPslUIBoXRH7YRXZYY1UP6C0J69RuV+gYHNHxe8r6kfe80uVgmWdlfZJ5xGD/j
ErxZwEyCxEUfXcJlu2G9dYFjoD2CUWOWP+AvKaH5NeoNv1pajaQPIDezOsJS0kM/
dOurbx7+/9kNaEzCtA5GGQ/jUOubEM+5yc8Pmz44XA5o77lCJRm77u+aa2ON5Fhu
WEfHhnhzAzL1SI2lR3n3r7s1vVX82K7nTTh4nyePRw5GBzOFeD2bVSrrh9xLEjIr
4oR4PnmLubvG1Fmxp+T2XP/ZuhfSKbcJ88pPNatIHczghyOQaR5X9Fh9L7Q2+Njd
149Dn+qpExvNTbh1ofuZ
=kIWC
-----END PGP SIGNATURE-----

--+1d8mk/W7pQzMfc7--
