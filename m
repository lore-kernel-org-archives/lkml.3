Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbaIHJqP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:46:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:38136 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754137AbaIHJqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:46:09 -0400
Date: Mon, 8 Sep 2014 11:45:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/9] perf: Remove redundant parent context check from
 context_equiv
Message-ID: <20140908094548.GA6758@twins.programming.kicks-ass.net>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
 <1408977943-16594-2-git-send-email-jolsa@kernel.org>
 <20140902105036.GH5806@worktop.ger.corp.intel.com>
 <20140908094348.GB1172@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6W/vd+xQRxZFP9Eu"
Content-Disposition: inline
In-Reply-To: <20140908094348.GB1172@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6W/vd+xQRxZFP9Eu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 08, 2014 at 11:43:48AM +0200, Jiri Olsa wrote:
> On Tue, Sep 02, 2014 at 12:50:36PM +0200, Peter Zijlstra wrote:
> > On Mon, Aug 25, 2014 at 04:45:35PM +0200, Jiri Olsa wrote:
> > > As described in commit:
> > >   1f9a7268c67f perf: Do not allow optimized switch for non-cloned eve=
nts
> > > we dont allow optimized switch for non cloned contexts.
> > >=20
> > > There's no need now to check if one of the context is parent
> > > of the other in context_equiv function.
> > >=20
> >=20
> > OK, so talk to me about that patch; it looks like you're slowly
> > reverting: 5a3126d4fe7c ("perf: Fix the perf context switch
> > optimization").
> >=20
> > So what exactly is the problem? I'm still jet-lagged and not seeing it.
>=20
> the problem is, that we cannot allow non-cloned context
> to be part of the optimized switch for reasons explained
> in commit 1f9a7268c67f

The thing is; I don't understand those reasons. That commit log doesn't
explain.

--6W/vd+xQRxZFP9Eu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDXrMAAoJEHZH4aRLwOS6ftoQAJxXWWRxn/GVyeCHJAWd2dBU
ms9V3qAWvuGKMC6zukFUrMIe9g2NbEQIdGlka/Iqzm32Mg1KRHaoqoMhBicxdfC6
bc6Geg0lGgVP4/0pKv2Hj2+iEtuvU4kDsRy5fGukeXCDtrSR5F7sYrsOxpXrDqJd
DvIEPHaZl5beUE0vMhO9AbIBP2X7M/34bA72/yLJxKjdMFDtjwSTaWsRY08BWZc7
4z1T4UTG/Ecv7CQIWBtwiKlNmQMVCCLctxfOBOqNDs7YJt3PX6LschMJ2P5Uo+ex
CkSQQjGIgWOFulWVqsOkiFrtymovfsfSSrhho0/ltBFpaDSuYjQhas2BM6ZvvWiw
HpRB2wYz9WvyywMNbN4f5rFgL9gpL3D/3GV2NaCIQGHTIob2jf3tPuSnrxshITDT
Ha7PsuhbG1D8tSPxosH52BbzdjlqPvtRB3vWdHzrYKHxmFGvfcMKTSoF8epxE2Fo
rUp3aWhbhFZ/EXLnCE2OSDGsyFvVVOv7m98LQvkgAE/vlehmxwnj5GD3iWQDkBBa
QQI4EJvaXCD2zMkt6IoKog2ivprafYd8Vxa+xWRDA4Gb3fSBJfnw0IidVkxwsmhp
zTEjHjo4nsTfzS7P05/bhkIMkeX0g5Obcu2ut1RVHIeSjfFmhY6HI9ZFgfD5pDMW
4kpd4798NiUCDsppm5sM
=ecoM
-----END PGP SIGNATURE-----

--6W/vd+xQRxZFP9Eu--
