Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801Ab3FRLAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:00:36 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:52411 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751436Ab3FRLAe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:00:34 -0400
Date: Tue, 18 Jun 2013 13:00:28 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Airlie <airlied@linux.ie>, Stephen Warren <swarren@wwwdotorg.org>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/tegra: Include linux/types.h
Message-ID: <20130618110027.GC6322@mithrandir>
References: <1371470294.26299.21.camel@x61.thuisdomein>
 <20130617203353.GC5265@mithrandir>
 <1371503099.26299.27.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5G06lTa6Jq83wMTw"
Content-Disposition: inline
In-Reply-To: <1371503099.26299.27.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5G06lTa6Jq83wMTw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 17, 2013 at 11:04:59PM +0200, Paul Bolle wrote:
> On Mon, 2013-06-17 at 22:33 +0200, Thierry Reding wrote:
> > That has already been fixed in linux-next.
>=20
> This header was added in v3.10-rc1. The fix in linux-next will ship in
> v3.11. Isn't that fix appropriate for (one of) the upcoming v3.10
> release candidate(s)?

It's not really a bug and it can easily be worked around by including
linux/types.h explicitly. But you're right, there's still a chance of
getting this in before the final release of 3.10 and I can prepare a
pull request for Dave.

Thierry

--5G06lTa6Jq83wMTw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRwD3LAAoJEN0jrNd/PrOhl84QAKKHWEOIoKvdCDUg5JMXxmrD
I9HGbk/xxtrzu7W9sPxIfxmg9PyzGbVHtNUp6uR+uP2SOU3yHf2z7zQKleR2PkEC
BW+7CP4f5XEUzMgcRi9nHT6nn9dL8v+HL8HaCljBlj9LOHckWRL7wIX/O146jpOD
GahVfSVDV+Na1hv/tQV0XIJI4j14KF54QJ1P5t/l6Q6fJspZ56B+YiKUMWJlfpZM
Jl29Tsn7FLWRPGq8DBdYX6tBeDunWkgE48sEIHXD7GBIwF2yQO4hT1QTKR5d/jZP
KALzVit42yLBAAV1+oNqFpSCStGDZE4purbShHdw7Y3H0ZHmjL04Ju13Peie7ePR
0CqASG0S2gpENphexQA61iINw7mK8FaN3VrqVZghX6/78Ost0ko+OmwwxKooVrvP
zZgLvog9hNR/mYzhAcfDzVdDccTa/N90X2Is/Pa0BfFxSVgzDvmqcMzxDNqQ53Ql
SrG8Cn51M5r07Zp2TibU4EuSj96jmZ+XIqJ8iIyTPuNeZxk/KdDK7kb0MNJzamDn
YyQIwohV/3O6YTE1jHW8puXlRdwBr0KKhKzqLxSjNOAbjwbiRXJmTiUa5IIS4Kag
87QqIu9ogDLjanT9AyTzKRuDwaCBxKldnF2rbM6CkgNG1mrywfVHj7Zr8Y9kE2RG
OEAoBuUyvmqMgda6M5N/
=vVRb
-----END PGP SIGNATURE-----

--5G06lTa6Jq83wMTw--
