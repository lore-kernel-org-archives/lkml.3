Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080AbaGNQNU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:13:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:52974 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755689AbaGNQNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:13:12 -0400
Date: Mon, 14 Jul 2014 18:13:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>, luto@amacapital.net,
        hpa@linux.intel.com
Subject: Re: [PATCH] perf: Add vm_ops->name call for mmap event name retrieval
Message-ID: <20140714161301.GQ3588@twins.programming.kicks-ass.net>
References: <1405353439-14211-1-git-send-email-jolsa@kernel.org>
 <20140714160947.GB9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AFQGHouA0VN8Ovbt"
Content-Disposition: inline
In-Reply-To: <20140714160947.GB9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AFQGHouA0VN8Ovbt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 06:09:47PM +0200, Peter Zijlstra wrote:
> On Mon, Jul 14, 2014 at 05:57:19PM +0200, Jiri Olsa wrote:
> > Following patch added another way to get mmap name:
> >   78d683e mm, fs: Add vm_ops->name as an alternative to arch_vma_name
>=20
> Please add to your .gitconfig:
>=20
> [core]
>         abbrev =3D 12
>=20
> Also, you failed to CC the two people involved in that.

In any case, this patch appears to be tip only for now, so I'll queue it
in perf/core.

--AFQGHouA0VN8Ovbt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxAGNAAoJEHZH4aRLwOS6H7wP/jFCeGMOfye1jNW28FlCrkc2
kQ1cMai7J4hveCzytcdxpE4XwSLKs2iOmOeLDs/QYMdmMSPK+xjxTBSz8rT1piZi
lm8UZoujZlBfBJh1wzb2y9JU66VOI9tOax/HJMsb79ihFFC5mxJ/22qhANn0HJ7h
0Bs5iDha7O71dQbLaejRC1UHgpdmLv4TE5Rdqc2NbH4Jvs9ib21CNky41SQD+Can
51VRxs3RWXscqf7EcX+uIjKv6PWRSJPSO8J/NjrU7l6ZlEdpwNbY/85REF1S8+FN
OasdX+yMwsoBTuxwh8inHt2ZjA0jJvlDeDNRce9I+TUslM2h5YTt1xpv54lPafTn
4XayH8NVV7vh6jJOMoqpjhGn/eoKKtqC/3eRU5dcw22y72CThclN2/CbREu6ehXl
hidzBWB/wAMG0zW7GZIH5Vgqay71sYbYOAjVo36YLsxItpdsiVah4uhFiMInuKmI
z0cfVHmp76eDzgqlD6F1NEPkiVZVVPX0Dqj7TYtIX+Mu7C5wS6OuWRGzi/Ip/jJl
nh7leYjd/PXeQZ+/GdxY4Owm1CMnHvzs4jJ8ewTge5ClAK46d4xakGwnJiiGFhrh
yEKUlYcHvElp/KuPKzj0vK+DPSrbWzVjuoWwYB4x/hllI3bskbC2pKlA+8+6pvHg
0nrIOw5B+yqowMYcOpK2
=NhYB
-----END PGP SIGNATURE-----

--AFQGHouA0VN8Ovbt--
