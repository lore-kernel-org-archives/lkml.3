Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaHAPDM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 11:03:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:52995 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbaHAPDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 11:03:10 -0400
Date: Fri, 1 Aug 2014 17:02:46 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Jirka Hladky <jhladky@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Aaron Lu <aaron.lu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, lkp@01.org
Subject: Re: [LKP] [sched/numa] a43455a1d57: +94.1%
 proc-vmstat.numa_hint_faults_local
Message-ID: <20140801150246.GC3588@twins.programming.kicks-ass.net>
References: <53d70ee6.JsUEmW5dWsv8dev+%fengguang.wu@intel.com>
 <53D72FF5.90908@intel.com>
 <20140729023940.37b6aebc@annuminas.surriel.com>
 <20140731104241.GA9918@twins.programming.kicks-ass.net>
 <20140731155723.GY3588@twins.programming.kicks-ass.net>
 <53DA6BDA.8080000@redhat.com>
 <20140731162702.GZ19379@twins.programming.kicks-ass.net>
 <53DA7129.7020100@redhat.com>
 <20140731173705.GC19379@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0tC/8VcTcTa+VwnR"
Content-Disposition: inline
In-Reply-To: <20140731173705.GC19379@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--0tC/8VcTcTa+VwnR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 31, 2014 at 07:37:05PM +0200, Peter Zijlstra wrote:
> On Thu, Jul 31, 2014 at 06:39:05PM +0200, Jirka Hladky wrote:
> > I'm doing 3 iterations (3 runs) to get some statistics. To speed up the=
 test
> > significantly please do the run with 20 warehouses only
> > (or in general with #warehouses =3D=3D  number of nodes * number of PHY=
SICAL
> > cores)
>=20
> Yeah, went and did that for my 4 node machine, its got a ton more cores, =
but I
> matches the warehouses to it:
>=20
> -a43455a1d57	tip/master
>=20
> 979996.47	1144715.44
> 876146		1098499.07
> 1058974.18	1019499.38
> 1055951.59	1139405.22
> 970504.01	1099659.09
>=20
> 988314.45	1100355.64	(avg)
> 75059.546179565	50085.7473975167(stdev)
>=20
> So for 5 runs, tip/master (which includes the offending patch) wins hands=
 down.
>=20
> Each run is 2 minutes.

Because Rik asked for a43455a1d57^1 numbers:

546423.08
546558.63
545990.01
546015.98

some a43455a1d57 numbers:

538652.93
544333.57
542684.77

same setup and everything. So clearly the patches after that made 'some'
difference indeed, seeing how tip/master is almost twice that.

So the reason I didn't so a43455a1d57^1 vs a43455a1d57 is because we already
fingered a commit, after that what you test is the revert of that commit,
because revert is what you typically end up doing if a commit is fail.

But on the state of tip/master, taking that commit out is a net negative for
everything I've tested.

--0tC/8VcTcTa+VwnR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJT26wWAAoJEHZH4aRLwOS6+gUQAKlLsJF4051xp7nGEOQuJhoR
PE899EevVXGHRlgs8o2gnGkCt3UnPdIFWihFtEqA2My1MHcVIzpkz+5nnmEZhBA9
nIwF2coF2qGro8WURaA3bXR7bADIWfZcnk3KZjJa2ibT87f+wHRq4/Firrb8GRU7
rairqulh83IV3FFdLlqAgkMuL20IH9dhPGNkJ4FrOzS6oz2qbXO6329qH/VC05+Z
XAH61pEVfN7BYbOS2TNAfEGCgzV6Lr01kPhc/qeOLbauVCzVUENaw9Qe3gOpskFM
PxjRqv3R6PkNtfL2oA/Zbg+7bz/X32R5mo2o+HCqQyT4IjURBRQsydfeszS4vdms
/cokqo1b2H0CnU2BMZLxMSsb36Ql6xjcNdp2/jkHnZ5tFKdfy2/c5Jcmf/2ajwyo
rA/vxHq6ykhtZSw71+3J7NnrNU0l4KrZflE66XhaJ9dVOTs826QIpFW0D0rzaHJv
7j9GCze5SG4Dt0xki2ocJJsyRTnBnxwlZpxOU7xcDIzGfTjTfsmuXwaSfmzXlmVr
oXEOjkP0BUKcW8RVdM7/KkyGjmzX9mQOmDXggr3BFmrRmVJEeCg63M0nktG1OrVa
A+IowCffoH7PRnP2K5fVgaKpYGhGdGgazCN9VO1XzfqXJdmyaQLTG1kh8vkOZb6x
9zKJUksAPV3jfyNgDuPg
=ddls
-----END PGP SIGNATURE-----

--0tC/8VcTcTa+VwnR--
