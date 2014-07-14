Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756325AbaGNQRc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:17:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53142 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755615AbaGNQRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:17:25 -0400
Date: Mon, 14 Jul 2014 18:17:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jiri Olsa <jolsa@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] perf: Add vm_ops->name call for mmap event name retrieval
Message-ID: <20140714161713.GD9918@twins.programming.kicks-ass.net>
References: <1405353439-14211-1-git-send-email-jolsa@kernel.org>
 <20140714160947.GB9918@twins.programming.kicks-ass.net>
 <CALCETrWZChK=p2v+-ez7s04ed5POawSqGrvST24m0c1TjFMVxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ar8KwLu88Tj76bHi"
Content-Disposition: inline
In-Reply-To: <CALCETrWZChK=p2v+-ez7s04ed5POawSqGrvST24m0c1TjFMVxw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ar8KwLu88Tj76bHi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 09:14:41AM -0700, Andy Lutomirski wrote:
> Looks good to me.  Sorry I missed that.
>=20

Can I make that an Acked-by?

--Ar8KwLu88Tj76bHi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxAKIAAoJEHZH4aRLwOS6dYoP/A6GP2TIavNaC6cIF+BCdAiI
ojS1tPOxr78fWgYOe1T0/XBGZxvKSY46RQhMHazw3qltDvekI8mpcqOfTUA9KsQj
tuDqqDBpa7wVCeMYGVmpjjsmACfg+omoYaHiFK02G6JdNhKqn4hxNB+TA0UKd+mr
zfU3b/haZ0ks76Lo11SADjLTSDn/DwAIcVCBwFU6piYJWaPNXEP2Egn+mZr8mDWM
+1pXsJ+kZX2f9aXmcu99ISK+BvnAS1LtSlnBl1dnNO1ICh/GHzL1yUf0pC91bV95
avxuTPtgbDHnPX7ZlcXy/HFYoukMks4f4izE/r3nzLfs4USqvTDxYCWgbe7luK7T
30RZgTcNEOmumTIZ44OdP3w/NyjxbMaTLm7fei2VnO4bES2AiJFgsrEb0pWKg6PP
wq8lO+vidT+OuSeC/XjeYX0gnjDc0UGCcVMB82q2bNbffrSEkMj5Ka2ujmeJochi
rlcLvghASoO/BknWDjCCbnUIUYiNEoCdAxnv1I9Ei2gtiLdq+95vNKGGNWgC5c5x
LUAO9VbbkityXPWOaUSsiEQIotC6dOBxkPSo54HA5hPe4NCBWMdCFDYgQdcX49U8
PJngDoyVv9u+1eprrr/bWFNvW8Teze+6FzaHYc40iM0Bytk9KC0G2FdejGGlMT5f
IFL4BEOmruL7F/lUVqTU
=hWLs
-----END PGP SIGNATURE-----

--Ar8KwLu88Tj76bHi--
