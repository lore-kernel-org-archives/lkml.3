Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab3CBDme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:42:34 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:36906 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752132Ab3CBDmc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:42:32 -0500
Date: Sat, 2 Mar 2013 14:42:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the ftrace tree
Message-Id: <20130302144229.f41f56c36992497a1530d65f@canb.auug.org.au>
In-Reply-To: <1362192318.1231.67.camel@gandalf.local.home>
References: <20130301134738.ce925e1643a35b0a2c4ff275@canb.auug.org.au>
	<1362192318.1231.67.camel@gandalf.local.home>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Sat__2_Mar_2013_14_42_29_+1100_ZKI_Yz5syWdckOBS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__2_Mar_2013_14_42_29_+1100_ZKI_Yz5syWdckOBS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Fri, 01 Mar 2013 21:45:18 -0500 Steven Rostedt <rostedt@goodmis.org> wro=
te:
>
> On Fri, 2013-03-01 at 13:47 +1100, Stephen Rothwell wrote:
> >=20
> > After merging the ftrace tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> >=20
> > kernel/trace/trace_kdb.c: In function 'ftrace_dump_buf':
> > kernel/trace/trace_kdb.c:29:33: error: invalid type argument of '->' (h=
ave 'struct trace_array_cpu')
> > kernel/trace/trace_kdb.c:86:33: error: invalid type argument of '->' (h=
ave 'struct trace_array_cpu')
> >=20
> > Caused by commit eaac1836c10e ("tracing: Replace the static global
> > per_cpu arrays with allocated per_cpu").
> >=20
> > I have used the ftrace tree from next-20130228 for today.
>=20
> I rebased, and it should all be good now. I also fixed breakage to the
> new snapshot feature. Here's my diff:

Of course, I wonder if this is intended for the current merge window
(since it turned up in linux-next so late).  If not, then please don;t
put it in your -next included branch until after -rc1 is released.  If
you are aiming for this merge window, then good luck!  ;-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Sat__2_Mar_2013_14_42_29_+1100_ZKI_Yz5syWdckOBS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJRMXUlAAoJEECxmPOUX5FE4bcP/jOJOJd+jwfc9s6XsboifQi9
1nNzupOV+1WnjxIsm7/jiP0uIgxb+Bn/UtQgjx1Xru3YpW3thwI9DvDYG+rm0F2j
mf19iVFOXi8snF2HMHdQJa3m8z6fkjpahPPLLfufXzoMEzBFoNsKX3dBq/SxTaue
BK3mGCZDV0TIqye2z1VV3skdE5imSJnTL9ocpsI2DwKBxmxCq7AL98Oky4j/iF0D
2FdNrZAT7nPxUTSuy6SknYaK8r4879W9ryqI3Z55wLrBdc4EMsdPgQE6m7qpwB15
p9dwgAhH/wUwOrwRxUfx2zw9izF+TBUsEnXgMS6Fi1DaKNI6tPYMkL/TzDm/m+oW
EtOI7O4p8bcJLwy+Q7EALVoY3Bsx0pMuIK9q1lEst6RErxoe/uPJpDCRhhkxAoG6
kPK0lQbxSN/2RDgW15ho3gN8Rhqh+PLbap2u1koJCFsszHdsaoOJ4yws7Yea9Gr3
zbFVk97Dl8BhalhB4qtiALyVPW4z6fwdhn0YaC/109DyPAtaYnRFLRi7gHWCf8uU
uJMAyx6+TBYPvQy47jm5tGZQZUB9pt5pzl5fBQjh9WJ1tUMxI63BUPVPJDKXQ+b/
8FqI+EkOQTDY3OLbw7vovPkCwY5C9HGk/GwtlPiIrdSeu90NWBVcV3jMBN8MfheL
RQfE0zJni5bPD/1FNrP8
=mIbV
-----END PGP SIGNATURE-----

--Signature=_Sat__2_Mar_2013_14_42_29_+1100_ZKI_Yz5syWdckOBS--
