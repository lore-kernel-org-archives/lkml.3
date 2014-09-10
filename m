Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606AbaIJIfP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 04:35:15 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52409 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaIJIfM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 04:35:12 -0400
Date: Wed, 10 Sep 2014 10:34:58 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Henrik Austad <henrik@austad.us>
Cc: Juri Lelli <juri.lelli@arm.com>, luca.abeni@unitn.it,
        rdunlap@infradead.org, mingo@redhat.com, raistlin@linux.it,
        juri.lelli@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] SCHED_DEADLINE documentation fixes and
 improvements
Message-ID: <20140910083458.GQ6758@twins.programming.kicks-ass.net>
References: <1410256636-26171-1-git-send-email-juri.lelli@arm.com>
 <20140909211739.GA20822@sisyphus.home.austad.us>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xPl3m8z7rSaEhmQ5"
Content-Disposition: inline
In-Reply-To: <20140909211739.GA20822@sisyphus.home.austad.us>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xPl3m8z7rSaEhmQ5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 09, 2014 at 11:17:39PM +0200, Henrik Austad wrote:
> On Tue, Sep 09, 2014 at 10:57:11AM +0100, Juri Lelli wrote:
> > Hello everyone,
>=20
> Hi Juri,
>=20
> Looks good! Didn't spot anything and pleased to see that minimal main()=
=20
> made it into the appendix! :D
>=20
> > This is version 4 of a small patchset that fixes and improves SCHED_DEA=
DLINE
> > documentation.
> >=20
> > Patch 1/5 fixes and clarifies terminology; patch 2/5 aligns Section 4 to
> > the current interface; patch 3/5 improves and clarifies what admission
> > control means on UP an SMP systems; patch 4/5 introduces an appendix ab=
out
> > testing; patch 5/5 introduces an appendix with a minimal main() for
> > application developers.
> >=20

> To the whole series,
>=20
> Reviewed-by: Henrik Austad <henrik@austad.us>

Thanks guys!

--xPl3m8z7rSaEhmQ5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJUEA0yAAoJEHZH4aRLwOS6en4P/334xPy53JxrAxLfpjNklfkq
3WUZFpTdv4UZB+g62ozBztkJfcUOy1Kby5Lpeea/z8wchhzTJmiLCeTiYP1BoD9G
x77snB2VoGk0VcQ9tIcYK8pK2kdKfMM89HS1SK813xYc5E4HoALRV1500jXX3hpw
PtWBXzxEz5rsxnvsv979iBmL5YYzSgjeJkXibgkvcgf/QYZkQUj9isZtlI2nhuyq
fZGf4drebZg+qoYXfR8DMrxvdQSGx6nWSzdAYS4DUb/UU/TuMwyFyAqWXoXBT1mZ
SVQVaNKSl42fFr9ZGmw9dZ198Aa4WnZPZeq2rBBg66j3am6FmJkGkW4qjDYmeJ5l
KFuItkr29NWn767ldQl0yHFK/33JnkUbMzzmL1nAauV4bxJDTmJxcrsD7VGHAkHm
IhMigEcND2zgQo+2MYnKsTJDe2dxlOSfyWGfzbIQOKdLK0qZY87Q4vmdNZ6jseLl
F/BjBcFGaitUsqv8UaWH+jVfic/ofEs6bN8cTFAPBaDtr2+xFHbgnZvVsHvEyXXU
3O7q52UtloiNiZ7fwT751DVirv4xmZ5YiJ5UBItOd1yJMRrXOYC9+o6KcG+wy/QJ
k3VX+T0Om5nJ8L+eHUxinJHRPbjnxSyLbbNnUinPezcA1Auxv/6otznbeIMy/TF3
VkGyF3yXRH2v6RYdpzig
=8pAI
-----END PGP SIGNATURE-----

--xPl3m8z7rSaEhmQ5--
