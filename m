Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751716AbaG1G64 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 02:58:56 -0400
Received: from casper.infradead.org ([85.118.1.10]:57468 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaG1G6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 02:58:55 -0400
Date: Mon, 28 Jul 2014 08:58:44 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 02/27] perf tools: Fix jump label always changing during
 tracing
Message-ID: <20140728065844.GK6758@twins.programming.kicks-ass.net>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
 <1406302629-11790-3-git-send-email-acme@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Ngz69hoXASxZo3zU"
Content-Disposition: inline
In-Reply-To: <1406302629-11790-3-git-send-email-acme@kernel.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Ngz69hoXASxZo3zU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 25, 2014 at 12:36:44PM -0300, Arnaldo Carvalho de Melo wrote:
> From: Adrian Hunter <adrian.hunter@intel.com>
>=20
> Intel PT decoding walks the object code to reconstruct the trace.  A
> jump label change during tracing causes decoding errors.
>=20
> The "Enable close-on-exec flag on perf file descriptor" patch caused
> there to be always a jump label change.
>=20
> It was found that using a per-cpu context instead of a per-thread
> context for the probe of the close-on-exec feature, made the problem go
> away.

per-cpu events are privileged, wouldn't this change make CLOEXEC always
undetected for normal users?

Also, the $subject doesn't related to CLOEXEC at all.

--Ngz69hoXASxZo3zU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT1fSkAAoJEHZH4aRLwOS68aQP/1y/4SAKHxcPfZWFCPytxifv
4KY1rjaa3lEWRDT6s1ePmSWnTqsRokguGBaQWuddwqlfdIVmo/Un4aQVJCkq9Y7g
dUl/2HHA+k3cKq7wBBj/mKmyvBVcQIciDbc8xMQGBbSyWfP/cx8j43IAYbf7fqb/
7DksYPg/9nQMhWpHX7CHpS2Z/4MRQzftabAov4TVdXqt/hlzBLylA2xLIG78XNWf
MpEhB/hXKaYwN1z1jDL2deMl0+X7pIkNyKSygOSh0DpJnOp2sw4FKKHv7ZfqW9gr
tBU5Gp98Kdg9jlMaEF+QAaMEsWSL/QJmS3QebOxUOvJcTmdOm0cl39Lq+AwMwrlY
BRs3sQrU3KPmx3VSDBDEh73M+OXbd3+sCmjAgSitwxBhd1zgTLIXAL3avFIu8YFB
EG2NjlQyQvN/9VgNOEBhWmRN5c8SMhPDuiUgyKLteSBZiUrZMStrZ9yysEUzCCB/
sotR4cAOS050hPswYptMRfWUdJRtGXEe/WYUpYTJVsQ4XQC6l9jTCWgBcVZ+aRic
pf1nmvp5vitpyvZlA/eArchAcWoxJQsk82MuK2fn966yhwn6kXkaL9bsgl4ctx2r
93GPM5e6XB9Kvv+utbr/E9mdKjr1UkC/9zWBpoTi9SKBfDAsbJ5EM2FHp2x3LK7O
tw+4HNofCDUWeYK5P5h+
=rlsd
-----END PGP SIGNATURE-----

--Ngz69hoXASxZo3zU--
