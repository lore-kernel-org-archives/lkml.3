Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaGQI01 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 04:26:27 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33542 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbaGQI0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 04:26:25 -0400
Date: Thu, 17 Jul 2014 10:26:13 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH] perf stat: Pass PERF_STAT_RUN environment variable for
 each run
Message-ID: <20140717082613.GF19379@twins.programming.kicks-ass.net>
References: <1405585266-28268-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fOJARmXCc2lxmu6e"
Content-Disposition: inline
In-Reply-To: <1405585266-28268-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fOJARmXCc2lxmu6e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 17, 2014 at 05:21:06PM +0900, Namhyung Kim wrote:
> When perf stat runs multiple times via -r option, it's sometimes
> useful for a workload to know which run it executing.  So pass new
> PERF_STAT_RUN environment variable to the workload for each run
> (starting from 1).

This seems counter intuitive, runs should be _identical_ otherwise
there's no point. That means the workload should very much _not_ know
these things.

--fOJARmXCc2lxmu6e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTx4ilAAoJEHZH4aRLwOS6uVsQAJ2m0Sag4LqFtRPwqaGqUDlF
ir1+LH/cUbLIEP/EDz8BqVGziPWUFEYRd7ejHgrYmakdLeLPyKozFnTzp3b3A9JG
Nyu314YesU0GuHHTf+dKkllUhHQJFqU1l+PLXEG1VC/t1CSr5At27xmeMt13qhq4
kkyrl9vsneJMGAHyGfVH+gJSUMjt3qZmxj4equhTV4yXjy4VwHx2JkuEJp8hEuTg
BVvzalfAD3Fc1SswlRyRMPwFUAjfi2GxI9rsiMEEoPtuIQn/s2UHI4kJoLiKF86x
/E5nEAGn53JtJABxOj4wF+x8CCQUlnVFxFeZFlNtCEhtyUslCAK9NVjQhUD3U7gH
dR7gekiHxDOn39y8sPg9fMz88wmW5aTDMc9atafPmPwUAPpsIYj/5yn0uI7mSCYa
CzwAgzP2++b3eKOeeyx8/6arP40is6G9a322YGN45L5aEdBjPYTOaDhyY0Dk0XbP
WUkp9xwmxXyy8VWtN8ab5pwUCV8apRBxtftz6kK3LkxG6MnZ5Jvotpz+vUS2jZqn
/CbKByvMTlA85v7OTcP8ERreyuVOw6AJsiFPP66gF+2S8tDImLmpXNMpiTlWkwiE
ZVKTrMbQcFRVa4AVmRLcmM8So8lMx2mO39V2+LiTnatTHAjOQyrLFZ5NexYED06S
PqiLAnjiMeqprjECJQ74
=rRtj
-----END PGP SIGNATURE-----

--fOJARmXCc2lxmu6e--
