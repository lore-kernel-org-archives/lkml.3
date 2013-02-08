Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946469Ab3BHO6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 09:58:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1059 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946249Ab3BHO6q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 09:58:46 -0500
Date: Fri, 8 Feb 2013 08:58:28 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] scheduler include file reorganization
Message-ID: <20130208085828.02e61518@riff.lan>
In-Reply-To: <20130208141841.GB30334@gmail.com>
References: <20130207094650.76302f47@riff.lan>
	<20130207185608.GA25223@gmail.com>
	<20130207191345.GA28960@gmail.com>
	<20130207195257.GA29985@gmail.com>
	<20130207150838.02226207@riff.lan>
	<20130208141841.GB30334@gmail.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kxkaIq3lMIEcpEAV8ER_3B4"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/kxkaIq3lMIEcpEAV8ER_3B4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 8 Feb 2013 15:18:41 +0100
Ingo Molnar <mingo@kernel.org> wrote:

>=20
> * Clark Williams <williams@redhat.com> wrote:
>=20
> > On Thu, 7 Feb 2013 20:52:57 +0100
> > Ingo Molnar <mingo@kernel.org> wrote:
> >=20
> > >=20
> > > * Ingo Molnar <mingo@kernel.org> wrote:
> > >=20
> > > >=20
> > > > * Ingo Molnar <mingo@kernel.org> wrote:
> > > >=20
> > > > > Yeah, that looks pretty good.
> > > > >=20
> > > > > I'll give it some testing.
> > > >=20
> > > > Found one build error so far, applied the fix below.
> > >=20
> > > Another one was in NOMMU mode (fixed below) - a hidden sched.h=20
> > > include file dependency in mm/nommu.c.
> > >=20
> > > It's looking good otherwise!
> > >=20
> > > Thanks,
> > >=20
> > > 	Ingo
> > >
> >=20
> > Huh, I did a build with an allmodconfig config file. You must=20
> > be doing some odd permutations.
>=20
> Yeah, randconfig coverage and cross-arch build coverage. One of=20
> the build errors triggered on allnoconfig, the other on the=20
> blackfin architecture.
>=20
> > I have both of your fixes applied, send me any more you find=20
> > and I'll regenerate.
>=20
> No need, I fixed your series locally and pushed out the result.
>=20
> Wanna split out some other parts of sched.h? ;-) I can do the=20
> build coverage testing part for those as well.
>=20
> Thanks,
>=20
> 	Ingo


I figured that was coming. :)

I'll look at it again and see about pulling the autogroup/cgroup stuff
into it's own header. After that it's probably going to require some
serious changes.=20

Any suggestions?

Clark

--Sig_/kxkaIq3lMIEcpEAV8ER_3B4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEVEpQACgkQHyuj/+TTEp25FgCgwLaCblTIFuYJvGPkByftLYS9
5IUAoJAjNoxONBaU95GF3S+5c2c7VYHl
=7NCX
-----END PGP SIGNATURE-----

--Sig_/kxkaIq3lMIEcpEAV8ER_3B4--
