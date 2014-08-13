Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529AbaHMLWw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 07:22:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:44076 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbaHMLWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 07:22:50 -0400
Date: Wed, 13 Aug 2014 13:22:34 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Ingo Molnar <mingo@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "Gross, Mark" <mark.gross@intel.com>,
        Paul McKenney <Paul.McKenney@us.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        Juri Lelli <juri.lelli@arm.com>, sched-tools@linaro.org
Subject: Re: [ANNOUNCE] Tools to analyse PM and scheduling behaviour
Message-ID: <20140813112234.GK9918@twins.programming.kicks-ass.net>
References: <CAP245DUSAHO_VBoBMy4KQaaA6_0a-i3Y3u4utnK8ji3UMVniyA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="o7SYQ77Phh4p2BTz"
Content-Disposition: inline
In-Reply-To: <CAP245DUSAHO_VBoBMy4KQaaA6_0a-i3Y3u4utnK8ji3UMVniyA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--o7SYQ77Phh4p2BTz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 08, 2014 at 07:24:01PM +0530, Amit Kucheria wrote:
> Workload Generator Details
> --------------------------
> The Workload Generator is based on rt-app. Shared resources, waits, signa=
ls
> and locking order can be specified for each thread in a JSON description =
to
> construct complex interdependencies. This allows simulation of interesting
> use-cases. The repository contains examples of a mp3 and web-browsing
> workload.
>=20
> The method to construct the JSON description is quite manual currently. We
> capture the trace of a workload of interest (say, on Android) and analyse
> it in kernelshark. We then construct the JSON description by hand until i=
ts
> resultant trace looks similar to the trace from the real workload.
>=20
> The immediate goal is to expand the library to cover the common mobile
> workloads. We=E2=80=99re also working with the rt-app maintainer to get o=
ur changes
> merged.

With the end goal of having a program convert a trace into a JSON
description I take it?

--o7SYQ77Phh4p2BTz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT60p6AAoJEHZH4aRLwOS6/3cQAIulGSX8fc5ulQXn5IDoNyr4
zvz2Kjd5bvqMI+5ydLHwmrjfU2Lcg1Lgo0MG5A/PQESIwbwya4yWJkKDrIW//Lf2
r+7uKvm7uctwcMmibxgKQkJK9sQG/bG4RSbqD3Q42FxRkuUmDcisdcI2koOdJGTp
YaNSF6oga0JOnqx9tJ5xJ5wiCIt5He2/Puk3a5QfyexCaHEYYR+2sXet1T34IvMO
j5mi/vyVvSApDqiD8p93Et2do+ftNDgn9ButuI1p3OblEMSxqgquTo/XbzJ4sk5K
1wOVqBk2TEbfdxgF/asjgiT8iUzRah9ZF4SWwb57CMnnqYN6z8kyEwxmWdzfEaGr
jFOHE7LkObCmnQcH+/KRopCNnJ1VFf8sl3VO3hYzEmVhthitLSKdmBaYNl9fPtO1
m8uGzbMtT3tV0B2xTD1BjtomfG8i8wTpdkn9rSVVOHLRoWZQGcRc4FPCsuI5/NCu
JUR7P2mYGK73QRi9jJkwvo9IIhaLqKeHHSUa+bWsJXNKBObc+p07Dinwai8c3DBM
Z5Iwj1ajHBkl5Y8FkWXO8KCZsmHAI3C942MIW8I2d5FLgLUORQtBEe4e2ETidWYf
qLlc7+8uV1z+zDTJxkUWFJeEjG1UCE0nSwX0CewtidAjToHWV0OD8QSVIN9T196Y
brf7c8e5HrMaU0XDH21j
=WWwd
-----END PGP SIGNATURE-----

--o7SYQ77Phh4p2BTz--
