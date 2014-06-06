Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752252AbaFFIJV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 04:09:21 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:49672 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaFFIJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 04:09:15 -0400
Date: Fri, 6 Jun 2014 10:09:03 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>, mingo@elte.hu,
        amit.kucheria@linaro.org, linaro-kernel@lists.linaro.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/2] sched: idle: Encapsulate the code to compile it
 out
Message-ID: <20140606080903.GS6758@twins.programming.kicks-ass.net>
References: <1398859263-7632-1-git-send-email-daniel.lezcano@linaro.org>
 <2782801.UzoMhgfu56@vostro.rjw.lan>
 <53639F1B.5080000@linaro.org>
 <8539453.ED7vQGf2Gc@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xe2geHXJg22At20M"
Content-Disposition: inline
In-Reply-To: <8539453.ED7vQGf2Gc@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xe2geHXJg22At20M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2014 at 05:32:25PM +0200, Rafael J. Wysocki wrote:

> That would be perfectly fine by me, but I'm not sure what Ingo and Peter =
think
> about that.
>=20
> I can set up a branch with sched/idle/cpuidle changes.

Ingo typically likes things like that. I'm still a git Luddite, I'll
learn someday :-)

--xe2geHXJg22At20M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJTkXcfAAoJEHZH4aRLwOS68mMP/RyoRIURdFUmubVYm6NJNhWn
fqakN77Zt73bS20BCTVg5f5ALBSK2WALIC7KELGgpBfeMcPyhZyS361YYpOS8DgM
bWAo7yxs8S81UX/RdV5c3wAv/PRwHTy//U/KOGH1Tyijo30OFqH8Nyp9/9S3x/De
iwJ7EbvWxu2biqwT2it6nG3LtoPhqoGaxd3bMsMrIRzBzG1iBJGU/izcnbeHCejz
aVklrzeyinjLvgRgfu8nPFReI1pgUUhkylUwrKV2jMfNqC4O8q5XSeLzFLiAbpAr
T9mFT8wPxzX7++plHDdRVLFCHYavEqtzDI5nYJqjYdPO5SsTfQUp1qQZSlcjmUQA
zUyYPM5VS3VjoanLrkOJOVE/WNG8LsM7eKJw5p63pLYrJuznVv7mU9k/YO89xy+v
wP4Sr2ncH4bbymyRBk4kqnOhngVWxLtBRGT95bbv5ze3Hde/LLoqnKid39MljLyd
oqf09PW9+HDV/bQx0kqMhz+gVixFvbKBv6o0JoNM7KITWes6DP4ff3THuPujQtIu
xnNWb0mV51lc8Flr28ORyxVPw9Ipk6Rnktukrxa8xp5YQPXPsoGrH1FKVystbCdK
JIxXR9whGCgkinpMm8vN8sEdvjneTa6yZICFXV74h12aa9fHMJ8gujT/fRLfvZcY
joSHz4Op2jQIkVUmEVus
=PYU+
-----END PGP SIGNATURE-----

--xe2geHXJg22At20M--
