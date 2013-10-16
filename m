Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761710Ab3JPUkI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 16:40:08 -0400
Received: from mail-bk0-f41.google.com ([209.85.214.41]:44191 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756905Ab3JPUkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 16:40:05 -0400
Date: Wed, 16 Oct 2013 22:40:01 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Shaohua Li <shli@kernel.org>, NeilBrown <neilb@suse.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the tip tree
Message-ID: <20131016204001.GB6579@mithrandir>
References: <1381949500-501-1-git-send-email-treding@nvidia.com>
 <1381949500-501-2-git-send-email-treding@nvidia.com>
 <20131016200645.GD10651@twins.programming.kicks-ass.net>
 <20131016201410.GA26785@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TakKZr9L6Hm6aLOc"
Content-Disposition: inline
In-Reply-To: <20131016201410.GA26785@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TakKZr9L6Hm6aLOc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 16, 2013 at 10:14:10PM +0200, Peter Zijlstra wrote:
> On Wed, Oct 16, 2013 at 10:06:45PM +0200, Peter Zijlstra wrote:
> > On Wed, Oct 16, 2013 at 08:51:39PM +0200, Thierry Reding wrote:
> > > Today's linux-next merge of the tip tree got a conflict in
> > >=20
> > > 	include/linux/wait.h
> > >=20
> > > caused by commits 1ab2460 (wait: add wait_event_cmd()) and fb869b6
> > > (sched/wait: Clean up wait.h details a bit).
> >=20
> > Gargh, where did that come from?!
>=20
> Also, wth does that live?
>=20
>=20
> # git show 1ab2460
> fatal: ambiguous argument '1ab2460': unknown revision or path not in the =
working tree.
> Use '--' to separate paths from revisions, like this:
> 'git <command> [<revision>...] -- [<file>...]'
> # git remote show next
> * remote next
>   Fetch URL: git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-nex=
t.git
>=20
> And I made sure to update the remote.

Mark and I use this repository as a temporary location:

	git://gitorious.org/thierryreding/linux-next.git

If we ever decide to do this again when Stephen's on vacation, we should
try to get shared access setup for the kernel.org repository. Providing
temporary service was a spontaneous decision, so we didn't prepare very
well. Sorry for the inconvenience.

Thierry

--TakKZr9L6Hm6aLOc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSXvmhAAoJEN0jrNd/PrOhqRIP/is3PWeAUUMMIYjNnWfVtKC3
HuLL9FCKaxNBjAHLfihDE80pyGymmuNtuSpidIRVJB2DTCKSiqOdrsMLkXrXqX/b
zkgw2sLkp78JwSEIAzBSTQNFDB+hBZhtvhwKOVa0sLqsKB+MVUSPqLNjEIMdnUpj
kHalwivpUFSBKspsYa8TiYqqW9ngjjPHyGZ3EgSch6tj5aspRbAtPHV/v77wlokp
dnQ8sUHTOFm4nGzoTTV9WhV6ue+W3TFtgJjEsrW3oaQoqnPiecOViTminD9EzeNK
Lr/V33VrWLxGeAwz1kbTp0P6QWZJrLBTPx5+Ux4XEpmmV7VdzJWAFsVhCs6DqnSj
AUKZ3oeONleQrGvvQq+pXYAW0PjQJNSM/CfBOGmeens+Se+yo1+6ma21WiQonlqF
HjxhQ/l+Rlm9O7faCgTgeYZ4ErHNBw6o0V5QGmJjBw33s+9AwTcTsx01NTqswabN
acFpgGGrMo26WdDUnf5WR/tDzaiHU8NmDE6ShYz9JHHYuozBrvSX4wCf/EKu2EPX
eSZqMGX2sGVFjZ1hxIYA6ttKykkbZ5Yv0C+20ByFyxWwx6CBLkfrbC1oUOVRkvZE
LRbYAC9VmfOl3z+QbY8xrIG9QGlOTKS9yWo+J/ASYpeTzuB8Imw3hgUBcU8NRm/s
xEdw4uLpJ0KzAvSmGFzU
=FpYH
-----END PGP SIGNATURE-----

--TakKZr9L6Hm6aLOc--
