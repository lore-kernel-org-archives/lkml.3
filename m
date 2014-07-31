Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaGaP5g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:57:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41834 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805AbaGaP5f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:57:35 -0400
Date: Thu, 31 Jul 2014 17:57:23 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Rik van Riel <riel@redhat.com>
Cc: Aaron Lu <aaron.lu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org, jhladky@redhat.com
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1%
 proc-vmstat.numa_hint_faults_local
Message-ID: <20140731155723.GY3588@twins.programming.kicks-ass.net>
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>
 <53D72FF5.90908@intel.com>
 <20140729023940.37b6aebc@annuminas.surriel.com>
 <20140731104241.GA9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GOaLjq+VdFesH+wR"
Content-Disposition: inline
In-Reply-To: <20140731104241.GA9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GOaLjq+VdFesH+wR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 12:42:41PM +0200, Peter Zijlstra wrote:
> On Tue, Jul 29, 2014 at 02:39:40AM -0400, Rik van Riel wrote:
> > On Tue, 29 Jul 2014 13:24:05 +0800
> > Aaron Lu <aaron.lu@intel.com> wrote:
> >=20
> > > FYI, we noticed the below changes on
> > >=20
> > > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git mas=
ter
> > > commit a43455a1d572daf7b730fe12eb747d1e17411365 ("sched/numa: Ensure =
task_numa_migrate() checks the preferred node")
> > >=20
> > > ebe06187bf2aec1  a43455a1d572daf7b730fe12e =20
> > > ---------------  ------------------------- =20
> > >      94500 ~ 3%    +115.6%     203711 ~ 6%  ivb42/hackbench/50%-threa=
ds-pipe
> > >      67745 ~ 4%     +64.1%     111174 ~ 5%  lkp-snb01/hackbench/50%-t=
hreads-socket
> > >     162245 ~ 3%     +94.1%     314885 ~ 6%  TOTAL proc-vmstat.numa_hi=
nt_faults_local
> >=20
> > Hi Aaron,
> >=20
> > Jirka Hladky has reported a regression with that changeset as
> > well, and I have already spent some time debugging the issue.
>=20
> Let me see if I can still find my SPECjbb2005 copy to see what that
> does.

Jirka, what kind of setup were you seeing SPECjbb regressions?

I'm not seeing any on 2 sockets with a single SPECjbb instance, I'll go
check one instance per socket now.



--GOaLjq+VdFesH+wR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT2mdjAAoJEHZH4aRLwOS6M+kP/RD0SOAHigylQc6H9zG08DKz
aPlJSp0xH3v4WtjFkTtmiSCZSnQLog7VOpa8RiUxTzB7rS5VjJfKoyM1klv9iJe1
PW1cTGb1pfTAikpfxohwInHRRc+LzH1+DqwW7tSYfPaE0jlsvIp3jiW9g5aGLGUb
Qw4nTJc/MVovYuD2TE01VMOYZIHIIhOrrogw1TtQLbozopx7pf4D/lILqoUe7/nd
zUWX4VUzC/62tB9W54GnBqQjlmApap95tNHWwPgtDfEfvR62L3apNUzKCbqqQxV+
0fxbgfOGqZQcCif6n2HiuXyCDnfB5Bw2t9cKazMdkcpZTJrcquBsXSr94r77d8Et
pF/yHL2+OPkDg8fOsyfbN1VNjuCEAO+FdcMaIJmquIAnqHUyEEYPIb/i5FLFlB8g
Uh8Vgbafbde3yzccMnJ9KtFWdC02ORvoGmZXqCpiedqkxzv9+crwEDrUlwSZu/oS
necnnNtV8rGw3u+I7N4EiN8YsVi3dLS6hEed0sp4WPRrELYoQGnnetwI7zsnDWks
aPHhb31TIcK9b44ZaEZnEtPrZ7X+5qyKmm+ZdrTG6Jk4FQ7krdjqxtJgX7WweLOC
e8DaC/yMBqt4J+WbVtvY6671aX92s6RFuIXFVF4qnqLABmXU/wYUI8fyVgCNGsdn
Si7yycmqNfRMXiROgAh3
=QJ0z
-----END PGP SIGNATURE-----

--GOaLjq+VdFesH+wR--
