Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546AbaGQIk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:40:26 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41982 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030AbaGQIkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:40:23 -0400
Date: Thu, 17 Jul 2014 10:40:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] perf stat: Pass PERF_STAT_RUN environment variable for
 each run
Message-ID: <20140717084011.GG19379@twins.programming.kicks-ass.net>
References: <1405585266-28268-1-git-send-email-namhyung@kernel.org>
 <20140717082613.GF19379@twins.programming.kicks-ass.net>
 <CAM9d7ciELhfJwdNBSJPCJcrVr43+hs+80m-FK7bE1mkuBcv0yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MyoNyhmGqzMI/8rd"
Content-Disposition: inline
In-Reply-To: <CAM9d7ciELhfJwdNBSJPCJcrVr43+hs+80m-FK7bE1mkuBcv0yQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MyoNyhmGqzMI/8rd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 17, 2014 at 05:31:14PM +0900, Namhyung Kim wrote:
> Hi Peter,
>=20
> On Thu, Jul 17, 2014 at 5:26 PM, Peter Zijlstra <peterz@infradead.org> wr=
ote:
> > On Thu, Jul 17, 2014 at 05:21:06PM +0900, Namhyung Kim wrote:
> >> When perf stat runs multiple times via -r option, it's sometimes
> >> useful for a workload to know which run it executing.  So pass new
> >> PERF_STAT_RUN environment variable to the workload for each run
> >> (starting from 1).
> >
> > This seems counter intuitive, runs should be _identical_ otherwise
> > there's no point. That means the workload should very much _not_ know
> > these things.
>=20
> But I think it can be useful if a workload wants to save logfiles
> based on the iteration number for example.  If it doesn't want, it can
> just ignore. :)

That's the wrong way around. Also, there's --pre and --post hooks to
preserve logfiles if you really have to do that kind of thing.



--MyoNyhmGqzMI/8rd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTx4vrAAoJEHZH4aRLwOS6AUUP/0SuqzaaQaS5MC+Ewwuu2SCr
yQjzZHRYVVSfghzGyQjlYhluDcMI0d4RTB+jmrMwR3sQsX6+0LjSlNjlSSt60g4+
ois2IDZzaFs86yA3OPl6V4M3zwu0of86kaVaJBvQAaJnDKp98dfciz1WFnGkbLab
jBIvCxtDNHYxX0JouhobPuKxmIlxBkWSHJzdLQ+cHIozfopNtEaTtkWdPw9+NuIk
vty2fhtbjLHEhrjTplWaScxg5GupAOMtbUeU/vMOjS7obNuOldfOU9Aitaw3+4Nl
IE0xdME9TXcOPjDkH7MfnlaeV598WkMHgf31hr1kLVkgyJVWtmv4ZBXa6V8z4bnL
jh2YPDm2uxcIW/8WwWICSfIcIfMKmYiUJhQ8mWcWIVaZCwNy0MhGMeJhuOTwxMYY
HqwZNrEWcCbwxDXAq4tdB3fg4F0whxHr61tze60dJzRTQibWV8M/Q9ngQLwdeWOk
CxzuoMnfL0kKw6uizhZStO2qjImVg84oi6/e/jPpw0E1raom3AouzwH1gcGAR+Cu
hp8DCXtUcJcn9CXC/pjxU371qnxzo1R4Tj9Otk8hc7QrdAGvX8mWqq4hDDP1Sy4A
k8YhMUrajCkKDAbqGFUzORj7zdNhbXNDlud7gn+l0TNUrzymQGczGpe0GSSjuHkf
Le9fIdlQuXMUsiOVVFgj
=svHK
-----END PGP SIGNATURE-----

--MyoNyhmGqzMI/8rd--
