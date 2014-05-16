Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568AbaEPQAF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:00:05 -0400
Received: from casper.infradead.org ([85.118.1.10]:40400 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361AbaEPQAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:00:03 -0400
Date: Fri, 16 May 2014 17:59:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Don Zickus <dzickus@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 6/6] perf: Add dcacheline sort
Message-ID: <20140516155958.GX11096@twins.programming.kicks-ass.net>
References: <1399999697-65875-1-git-send-email-dzickus@redhat.com>
 <1399999697-65875-7-git-send-email-dzickus@redhat.com>
 <CABPqkBQE-HLV3JLo4-sXBJos38SY0RUhC-gLeauawrf3Cgojtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rz/qo3iW6Lu5yGf1"
Content-Disposition: inline
In-Reply-To: <CABPqkBQE-HLV3JLo4-sXBJos38SY0RUhC-gLeauawrf3Cgojtw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rz/qo3iW6Lu5yGf1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 16, 2014 at 04:09:59PM +0200, Stephane Eranian wrote:
> > +#define CACHE_LINESIZE       64
> I had something similar to your patch here in my original series for
> perf mem, but I never pushed it.
> I think this is a useful feature to have.
> However, I don't think you can hardcode the cache line size to 64.
> This is generic
> code. There may be architectures where the line size is different from 64.
> So I think you should add an option to change the default line size or pr=
ovide
> an arch-specific definition.

# cat /sys/devices/system/cpu/cpu0/cache/index0/coherency_line_size    =20
64


--rz/qo3iW6Lu5yGf1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTdjX+AAoJEHZH4aRLwOS6DK8P/RNJ1f8Wy0JAmHjZRzeCjNEq
C3x+iFqe9/4jXFQlLrkkSdIFMlijRl9CSmCyfwiajvtzxvqXvpA1na+hClO91CMs
uYw+gh4eByPqPGPoy6D1evPftziONN7GPFbsNL9UxsjPVfQwyXQNamjDS0ILglKy
j1QNVjjcvZbfCCN+6Jn2SnOE4fWAmqmaBi50Z64cbK5UcOFsOqsgN0l2tZU4fQQl
qvY/fM/4UHENIVXBOiq2mtHu/M9j+kdHHcYpG+Js9vicNg4wupOpujRvs30ghYJr
mX+gY89QQbjohgCrvit8nhX+mTHSp1AeOvnf4cwB69QB/rCDQfLB9sLmSPTBuw8V
PDvvtoXvry9iQFeTAFnYdx+07T0ixxWtu9UJvZCg66UE8nqebtgmwqeqbBTEBNwr
2Rd1bXpMFrBr9ul6jylzRFTEKS1x8+1EIqGcMr22rcf+4zhFiydxiPbZeujPU7i6
Zmimbtamj4WRK2GtQThIoFzWzbAwiXpX+xTVC6020fi6jPjrpmTq3pLjMIN3tpkx
KzJUA4Bm+Gjkj0q/3OoZg5R72mx4qqdUJ2KsWFdGFdOmGIRhz/h6SUYAOfbNYOPS
eHcIGUoxpRPGsV4iooIQA4TmI6p9g6j+XBBYGZsm2XAZzkj8DudFsIpWslas2wYt
hYkeI4cZy8YAZmRYey1x
=NoG+
-----END PGP SIGNATURE-----

--rz/qo3iW6Lu5yGf1--
