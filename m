Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab3CBERM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 23:17:12 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:50064 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720Ab3CBERK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 23:17:10 -0500
Date: Sat, 2 Mar 2013 15:17:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the ftrace tree
Message-Id: <20130302151700.89f98f5c132a913510b5a621@canb.auug.org.au>
In-Reply-To: <1362196529.1231.80.camel@gandalf.local.home>
References: <20130301134738.ce925e1643a35b0a2c4ff275@canb.auug.org.au>
	<1362192318.1231.67.camel@gandalf.local.home>
	<20130302144229.f41f56c36992497a1530d65f@canb.auug.org.au>
	<1362196529.1231.80.camel@gandalf.local.home>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__2_Mar_2013_15_17_00_+1100_z3WG7sT6YEITOe56"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Mar_2013_15_17_00_+1100_z3WG7sT6YEITOe56
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Fri, 01 Mar 2013 22:55:29 -0500 Steven Rostedt <rostedt@goodmis.org> wro=
te:
>
> Oh crap, sorry. Quite the contrary. I should have waited for -rc1 as
> this is intended for v3.10.
>=20
> I made some major changes and wanted testing on it as soon as possible.
> I've done tons of testing on my own but I wanted a broader audience. Do
> you want me to pull my tree and reset it to what is only for 3.9?

Yes, please.  The reasoning is that until -rc1 is out we don't want to
complicate life for people whose code has not yet been merged by
reporting problems in code that will not be merged until the next merge
window.

That is why my daily reports during the merge window start with:

"Please do not add any work destined for v3.10 to your -next included
branches until after Linus has release v3.9-rc1."

But I am beginning to realise that not many actually read those reports (I
had the date wrong on two of them this week and it was only noticed after
the second one :-().

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__2_Mar_2013_15_17_00_+1100_z3WG7sT6YEITOe56
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRMX08AAoJEECxmPOUX5FEMdUP/1VnlklmOqjetVgVLMUm+vMM
k6rFiWLXxHTqPyy9D/DfGuRBqvEHhaorS8347H2Qqxt6jZNHVniQydyh6IUm0bHd
3xnuW+WVJfsS3YQKtjoAOC7ShTgtOgc/1inWZp96I63j2g+pKS2phxyCPk5XTN/Q
utJlcJBErCoPWebqauTYXiM/M5GLGijFYcvrbQg9yarsnM3SXgB+QUdBxed8JE9x
Hyc54FdcWcfB2JLmeVVih6VzgdUtTy4I97vUKO8YzJSZjDZXAGu/IXGQgx7HnO5h
6p1JvoKGk6OARu5z5YxIHNEXPwYK4lztVsLErAb2+LvPi9fyEB0WZLg7agyAa6hM
WPbibQ5+4E4gD0It6un3Oasd2DL0D8cH+P3vQn0vvvFV69Eyd05M3gkDf40+xfe1
aPXcC/7IQzY2WeGOqxgmffIb+5jlIim5FMkq6dZtyQbCLXYZY5vImvnonToHEvTg
LM0tq/i442Rw6EikWTP1eDh7IwiIvHMTtCTBTEWt1m74FGxDEquU7BmLcBhFSke0
ii+ymnRc22sJNca9FD2+mWcMCJRbhT0eOGO7ne4YTSzYdUQMRCw4vdpkiZV+tO68
b1Z4DXevlmMn9GwvrOMmkB5tS1qIJRMUgyBlrYUrZVmtl7mknLM/Bl/cdrCprFC6
QAk1IUzLGGreAUHyUlvU
=ugZP
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Mar_2013_15_17_00_+1100_z3WG7sT6YEITOe56--
