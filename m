Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269AbaIIJML (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:12:11 -0400
Received: from casper.infradead.org ([85.118.1.10]:43661 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756239AbaIIJMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:12:09 -0400
Date: Tue, 9 Sep 2014 11:12:06 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Robert Richter <rric@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        kan.liang@intel.com
Subject: Re: [PATCH v4 20/22] perf: Allocate ring buffers for inherited
 per-task kernel events
Message-ID: <20140909091206.GC19379@twins.programming.kicks-ass.net>
References: <1408538179-792-1-git-send-email-alexander.shishkin@linux.intel.com>
 <1408538179-792-21-git-send-email-alexander.shishkin@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GHx7zIBOqPdmIPse"
Content-Disposition: inline
In-Reply-To: <1408538179-792-21-git-send-email-alexander.shishkin@linux.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GHx7zIBOqPdmIPse
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 20, 2014 at 03:36:17PM +0300, Alexander Shishkin wrote:
> When a new event is inherited from a per-task kernel event that has a
> ring buffer, allocate a new buffer for this event so that data from the
> child task is collected and can later be retrieved for sample annotation
> or whatnot.
>=20

No.

--GHx7zIBOqPdmIPse
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUDsRlAAoJEHZH4aRLwOS6BPwP/jcRa3IluVi0pmbpJQVOZk1R
ncJ4OEz4aEhiGb3wHY4EQbbxl9ZUSpQwRUq2S+AocOGtea0879RdlKdKPEHnDhzq
AdgEU0GUsaSlSRhYRUPeTauhc/umH49Kc3VQ6Q0YZdNLz1KnNYf9mGYsRq+jSIxx
ay/2zwFpEf3D1ooTN3fO1K13xxkN/Y2r3CMecoCymRUSaBnrNmnR5oBqdbi8Hfh9
QSUdJ5haEfIYEzkjnjLpSzTCKBEVG9KfVn7svFcD5HAuFqbeNd1reyBWcsaz268C
LbPxJUDyL+G/nUVC7Mz6PSHV6OneY1ZyUGrqXXpNlm2LGRbKQ7+MS1AelBaNzRTK
9tBUqNc3l+DOWGzYuCvYwCVRqlPeJ7YyJB/OG7go4fB3ue78GWwijbPVhH6TGEn5
zl9hC46a/bY78w1gNE/E5nVI02mDXumc/OFZtlUQCH4JHkPRld9H0r1FmdvVXzC4
HDdNcno/gLNgrW/2yI0oGcgTrgXqkCg0QqXqQKT3qatkNRTEK1o5e46ALpSzGzbN
uOUJcBs9Dw8fSZBdN4RCZRMq1PylFp45rSw4YEJfhnlFoZXjNz0t895jtF5DGh4x
VwtfuTwqPGrSR7NQR/xsrYoWdznXvVwLSZPwQM086p2TKNII07SzPAvulDLZFKSP
f3YP5gcNB9WtpqGAVan2
=RdGv
-----END PGP SIGNATURE-----

--GHx7zIBOqPdmIPse--
