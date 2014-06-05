Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751848AbaFEM7g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 08:59:36 -0400
Received: from casper.infradead.org ([85.118.1.10]:52112 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795AbaFEM7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 08:59:35 -0400
Date: Thu, 5 Jun 2014 14:59:29 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: Matt Fleming <matt@console-pimps.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
Message-ID: <20140605125929.GH6758@twins.programming.kicks-ass.net>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
 <1401917658-26065-10-git-send-email-eranian@google.com>
 <CADknwL5S8QpzCAgrKHjbGTbEx7nA8L=Vu8d-UWAYCg6X25OcGw@mail.gmail.com>
 <CABPqkBSimH8Ob_q3dDtQiW_OwuS9nA4Gsx87H26ywNcmYd38Xw@mail.gmail.com>
 <CADknwL6s2ttb5E2JDr6bc_XkwpxnW5ecU-3Ns88=gvgPvLYkPg@mail.gmail.com>
 <CABPqkBQUUb+yEvC8y3oLc0DUbF3DJPzbt3sNL7Zqzufh6EYdRw@mail.gmail.com>
 <CADknwL71NC5wBG1tnqgJ6iiA4y+HYomGpufOn7V+MP2=m7+Mig@mail.gmail.com>
 <20140605125022.GF6758@twins.programming.kicks-ass.net>
 <CABPqkBQMi5NoL1EFB8ajopF8QbF3kiFgk6NkSkaqzruVaEQJOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Bg2esWel0ueIH/G/"
Content-Disposition: inline
In-Reply-To: <CABPqkBQMi5NoL1EFB8ajopF8QbF3kiFgk6NkSkaqzruVaEQJOQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Bg2esWel0ueIH/G/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 02:55:05PM +0200, Stephane Eranian wrote:
> On Thu, Jun 5, 2014 at 2:50 PM, Peter Zijlstra <peterz@infradead.org> wro=
te:
> > On Thu, Jun 05, 2014 at 12:16:01PM +0100, Matt Fleming wrote:
> >> On 5 June 2014 11:19, Stephane Eranian <eranian@google.com> wrote:
> >> > How would you know that you have a uniform workload from inside
> >> > the kernel?
> >>
> >> That's what I'm asking you ;-)
> >>
> >> >> Does cpu_sibling_map not give you some indication of whether HT is
> >> >> enabled? I think the topology_thread_cpumask() is the topology API =
for
> >> >> that. But I could most definitely be wrong. Hopefully someone on the
> >> >> Cc list will know.
> >> >>
> >> > Remember trying some of that, but when perf_event is initialized, th=
ose
> >> > masks are not yet setup properly.
> >>
> >> Oh, bummer.
> >
> > So we init perf very early to get nmi-watchdog up and running, but
> > there's no reason you cannot register a second initcall later and flip
> > the switch from it there.
>=20
> and what initcall would that be?

Pretty much anything !early_initcall() is ran after SMP bringup iirc.

--Bg2esWel0ueIH/G/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkGmxAAoJEHZH4aRLwOS6ossP/1J/YlOPFB4Iyz5koV6ouCU1
iaZmybbT7XKovIBmq1Q2I6dnlYMhpXGCCyVdgncMWNUgbTTB772AJFBpKnwaMIJd
J6U8BK4fRSExXcMGXw/WIwQJfdWLoLydlv87YzFs8vSJMGbekrwyqle5KgMowJFZ
2FMw728Ljoph7+wWGbghF8NRa80bCZQ9vJXCK6+XDJKRzh1DnCOWcrvir8xujex7
rkvCiAND+s/OfMPdQiTFv67gOKixl4AeVwTpji/ouRp9O12xTCej876nWdioUXCT
ppm98tkWPcMaemAbvUnMorZ6Hp8dAZJawL4QbqILFck9nnol6SrTrriGjxBcf+dB
vZtkLU7xFTX6fsElPvKIo8gzyOfDZnC/oDFtAjDQMbTo9xwvATzf647f/2d3FWFe
/wK946KYgF4/Jjkr0e66wO7z1o1gHhIFoBPRJnfqAOIMzONUY0G6O84rVdp0FW+1
HbQ1A7GzCq33LFFBBEOesMkJJNLDZ8XOnXgJCPk/gFCpRzOA39WdOU4zzX2MWwt3
uz3tNBiG5IwTZ4OVbe8oYvkl1A6rNTjkOnGjWZ/2Oent+EwjsIiS7pRm8obT8p/w
XciesohzhFOjIss3ltvXXYbjQk/pFOPtMbfdRArNCJki6obAYp8bv8nDvAbo/jwF
cD2YPvFpCTnYHB2hiiBY
=RDgi
-----END PGP SIGNATURE-----

--Bg2esWel0ueIH/G/--
