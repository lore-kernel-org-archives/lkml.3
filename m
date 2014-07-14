Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424AbaGNQfH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:35:07 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46222 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbaGNQe7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:34:59 -0400
Date: Mon, 14 Jul 2014 18:34:46 +0200
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
Message-ID: <20140714163446.GH9918@twins.programming.kicks-ass.net>
References: <1405353439-14211-1-git-send-email-jolsa@kernel.org>
 <20140714160947.GB9918@twins.programming.kicks-ass.net>
 <CALCETrWZChK=p2v+-ez7s04ed5POawSqGrvST24m0c1TjFMVxw@mail.gmail.com>
 <20140714161713.GD9918@twins.programming.kicks-ass.net>
 <CALCETrWdY9mj3cGcebJ6jJ1YA6werwfPFf3cqUEAGa77mPD=dQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NyVXgNZ34wipDCDo"
Content-Disposition: inline
In-Reply-To: <CALCETrWdY9mj3cGcebJ6jJ1YA6werwfPFf3cqUEAGa77mPD=dQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NyVXgNZ34wipDCDo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 14, 2014 at 09:29:43AM -0700, Andy Lutomirski wrote:
> On Mon, Jul 14, 2014 at 9:17 AM, Peter Zijlstra <peterz@infradead.org> wr=
ote:
> > On Mon, Jul 14, 2014 at 09:14:41AM -0700, Andy Lutomirski wrote:
> >> Looks good to me.  Sorry I missed that.
> >>
> >
> > Can I make that an Acked-by?
>=20
> Acked-by: Andy Lutomirski <luto@amacapital.net>

Thanks!

--NyVXgNZ34wipDCDo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTxAamAAoJEHZH4aRLwOS6gJ8P/3kbz8z1f0ZOYeX7ZN3kFOWL
2cg/pFeXcTj/Fw8mbfqL5N/vlSrGAMNSeoyGAhPB+UBcsPu7gLMrvcftHnfwLujm
0CelsGP3yhuJEl3oOZ2QCuHNFjLHpuQkf4+49LvaQEbriqYYcAmzzA1Syw8P6e6x
d6+btC9G8RcgOYU3TLh78Nu7yWjEdRhFL5sl5AVYvOpuMeRew7OPTRMrnzJr1SPR
7vJisIT3wqPsMpHfyZwaTdEn2NnNRrM138D23VDipW46YrC5/jN9r+iUoOeP9tGm
dCNtX6jfG4eFSb9AGeSGk4x1Es+1oBb3QQe05gKzGEb4qbP00jI97t7Mb1KLpmK9
x1Ym2CHpTuiPSHas9/b4yq41Fhz3QCAMYfniM+T6k4Md6HmRpOqdKTY3izpx2yDJ
zdPRR2JinUvtt3Q98keBt9GmyVCIB+hheii0dLbp5p0AFribD9zSnKsmCBHurTqP
nEY38tH47FoU4F7gqYbQtJKtHTAu22HtZXsTPB79E0zjaKz4NOGLQdq4pGM8W83C
2Bvo0Cfp+fXSiJK4xI9dD6qqr2WNGWcDNQMjDsSdAoqDqH/9DctcZJGMVuxlULyy
iyZJJJx72lBFnHSsR551bu0L+8CI4Yse+L7eXFMd1tqegZu9p6kIWRXqDMlPA/ME
WlZ+SfTzLB5i4nKhe/0i
=NsuC
-----END PGP SIGNATURE-----

--NyVXgNZ34wipDCDo--
