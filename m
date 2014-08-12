Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754835AbaHLURT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 16:17:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:41026 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbaHLURR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 16:17:17 -0400
Date: Tue, 12 Aug 2014 22:17:04 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Juri Lelli <juri.lelli@arm.com>, luca.abeni@unitn.it, mingo@redhat.com,
        henrik@austad.us, raistlin@linux.it, juri.lelli@gmail.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] Documentation/scheduler/sched-deadline.txt: improve
 and clarify AC bits
Message-ID: <20140812201704.GR19379@twins.programming.kicks-ass.net>
References: <1407858555-14371-1-git-send-email-juri.lelli@arm.com>
 <1407858555-14371-4-git-send-email-juri.lelli@arm.com>
 <53EA58B4.8050307@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="h1hvxSAjN7m6FVpB"
Content-Disposition: inline
In-Reply-To: <53EA58B4.8050307@infradead.org>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--h1hvxSAjN7m6FVpB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 12, 2014 at 11:11:00AM -0700, Randy Dunlap wrote:
> > + wcet and its period (or minimum inter-arrival time), and represents
>=20
>    "wcet" seems to be used here without any explanation of what it means.

Occupational deficiency I suppose: Worst Case Execution Time. Yes it
would be good to spell that out at least once.

--h1hvxSAjN7m6FVpB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT6nY0AAoJEHZH4aRLwOS61AUP/1MGB+FjxCIZiQK8KwTkr8CK
NKtZqXdrvoIuFaY3QSB4JUnDB72fHpMWObRGWDsh1tzaNOY1CAmoDxOmkpmTjmix
nwnPaH5/EOsQMZ+Eel8hWJoQTDLArBWAoPgJ3qFpD8OlrDBTHnA+aWAnqGxHPbIV
OUvQSFXlXSlr5LlD0zaMcQGCqV1o2kYtx5HeWvAoo8qzM90lM/SiMvobN3YQNcCR
6hjTMyCWqW/+maDt7+lUxXIi3yfQSo87IHc1TBJRrnnWucT46of2X0jksYBYbs1P
H99CKUfNicIYg7455bedrPwYerrBrHCtA83TD2t+W3RmNoDWJYa6+ZCFEimIr4l+
lPtkRkEegAgHCbaf4yNGKJ76wWZaTlVk+ope682KBHCr/cyfT9q0zbdU9wkqgURj
Zo1gIiHG87DNIKbXPLt0ZbPLP1dQaOdakCKVGVi8pDiUA+e174VbM0PTdg/sHdpC
Gs0QO01IrynvszrVUZy9o4gvJFH5wzlgJDhT0Z08jEePuAfdCwnXj3USyJl1vrSm
7WwRH+Qsr8tLSSizo4k07EgCyFREzzcRYJVaYK3fFMbQISvT1RoUUZtIODgob3sF
brt1xSW8Im60E62LHdpfr+w4ZrjniuevQ1ZJjp0jV8za/FZbdgMIxtUD8nO73HPi
WqJiKyKV5S99c7pvGWDa
=nx4N
-----END PGP SIGNATURE-----

--h1hvxSAjN7m6FVpB--
