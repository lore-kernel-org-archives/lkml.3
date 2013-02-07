Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759355Ab3BGVI6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:08:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758876Ab3BGVI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:08:57 -0500
Date: Thu, 7 Feb 2013 15:08:38 -0600
From: Clark Williams <williams@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] scheduler include file reorganization
Message-ID: <20130207150838.02226207@riff.lan>
In-Reply-To: <20130207195257.GA29985@gmail.com>
References: <20130207094650.76302f47@riff.lan>
	<20130207185608.GA25223@gmail.com>
	<20130207191345.GA28960@gmail.com>
	<20130207195257.GA29985@gmail.com>
Organization: Red Hat, Inc
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PB_greM/_NNtLeD=AIL7UHt"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/PB_greM/_NNtLeD=AIL7UHt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Feb 2013 20:52:57 +0100
Ingo Molnar <mingo@kernel.org> wrote:

>=20
> * Ingo Molnar <mingo@kernel.org> wrote:
>=20
> >=20
> > * Ingo Molnar <mingo@kernel.org> wrote:
> >=20
> > > Yeah, that looks pretty good.
> > >=20
> > > I'll give it some testing.
> >=20
> > Found one build error so far, applied the fix below.
>=20
> Another one was in NOMMU mode (fixed below) - a hidden sched.h=20
> include file dependency in mm/nommu.c.
>=20
> It's looking good otherwise!
>=20
> Thanks,
>=20
> 	Ingo
>

Huh, I did a build with an allmodconfig config file. You must be doing
some odd permutations.=20

I have both of your fixes applied, send me any more you find and I'll
regenerate.=20

Clark

--Sig_/PB_greM/_NNtLeD=AIL7UHt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlEUF9YACgkQHyuj/+TTEp1HfACg4qry+tTJbbig3dy8FRSGg9A+
RAUAoJxL7ota1rDj0XZHxOswgu6kZt2X
=nh3v
-----END PGP SIGNATURE-----

--Sig_/PB_greM/_NNtLeD=AIL7UHt--
