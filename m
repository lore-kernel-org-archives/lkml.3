Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932813AbaJ2Mjt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:39:49 -0400
Received: from mail-pd0-f177.google.com ([209.85.192.177]:46055 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932388AbaJ2Mjs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:39:48 -0400
Date: Wed, 29 Oct 2014 13:39:42 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Andrzej Hajda <a.hajda@samsung.com>, Dave Airlie <airlied@gmail.com>,
        dri-devel@lists.freedesktop.org, Thierry Reding <treding@nvidia.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] MAINTAINERS: Add entry for MIPI DSI bus
Message-ID: <20141029123939.GA30610@ulmo.nvidia.com>
References: <1414403310-6316-1-git-send-email-a.hajda@samsung.com>
 <1414403310-6316-2-git-send-email-a.hajda@samsung.com>
 <20141027141717.GN26941@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="r5Pyd7+fXNt84Ff3"
Content-Disposition: inline
In-Reply-To: <20141027141717.GN26941@phenom.ffwll.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--r5Pyd7+fXNt84Ff3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 27, 2014 at 03:17:17PM +0100, Daniel Vetter wrote:
> On Mon, Oct 27, 2014 at 10:48:26AM +0100, Andrzej Hajda wrote:
> > Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> > ---
> >  MAINTAINERS | 7 +++++++
> >  1 file changed, 7 insertions(+)
> >=20
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index dd31933..476679c 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -3071,6 +3071,13 @@ F:	drivers/gpu/vga/
> >  F:	include/drm/
> >  F:	include/uapi/drm/
> > =20
> > +DRM MIPI DSI BUS
> > +M:	Andrzej Hajda <a.hajda@samsung.com>
> > +L:	dri-devel@lists.freedesktop.org
> > +S:	Supported
> > +F:	drivers/gpu/drm/drm_mipi_dsi.c
> > +F:	include/drm/drm_mipi_dsi.h
>=20
> I really prefer when common infrastructure like this doesn't get
> maintainer by a vendor. And I care with my intel hat on since we also ahve
> a dsi driver that sooner or later needs to be converted to to this stuff.
>=20
> Why doesn't the usual model of merging stuff through Dave's tree, or if
> that doesn't work well due to patch depencies, through vendor trees with
> Dave's ack?

FWIW, I've merged DSI changes through the panel tree in the past after
discussing it with Dave on IRC. It seemed like a good fit and it was
most relevant for panels anyway. Given that I had expected that Dave
would give it a closer look before pulling than any of the vendor trees
anyway, so it would be as good as an explicit Acked-by anyway.

Thierry

--r5Pyd7+fXNt84Ff3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUUOALAAoJEN0jrNd/PrOhCrcQAL1oBQJZByGlCHB0MO8eLBYB
XAjXazILr++793j+wA5ivlNgyTY7gfUweDW77RfC0M0hAL953UfLBpvfJRvOmMGv
173LcwYO7nYJeZRk6IeWhBRB4StGIgCfJcOwi9mdIZKSRIrYW6vHnCrvqQAn6QGO
Q2xcrMyuIy6yvhm9UNGDTL3+wHtRJRan9aWxc1LMkVguOKpjz38a/lKEerlgzZk+
eJMghNoCUz7EQ0rxRHFgXKLDfV9fW06AQTX7o8sk4K1vab5yNBgH3nKF5noRiXM1
Xj36Y8qF2saI3sybDcyvvIaYbyrpQNZKPZrQNwV7kx9ci+AjA5l6yXXjsJkoXhi2
Wbwf5bL5OeXdkhzhRrveqO6tyVDdu3LSPUluRw0URoonYgT16z3e/EpdLeeTQyOb
DQZnLC3KEosolDBrqWC5FmXlvfYH3KWxExjNtkkgp6GfU5DnGqucr9NVMqZ1D5LH
2ywi6c9FL7q2Nbr5sLkcFnsifHkEqJ0cXd1FwmoPX9ngKxGPTLQI4VS3690N0rW9
hRP8VBaHYEsIRMSwwjMznLNIozhl7oF0BOsTfYGEy95JPEqSzpBnD5rG5O5O30m1
QEtJCG7YSm34ogv6PoZ9Db8CZ3vP0iHYdZRVWAnNllCMYr0pjIzbQkciPJE3iSjP
+qHEXxroO2XoDPZqdsRn
=sDrr
-----END PGP SIGNATURE-----

--r5Pyd7+fXNt84Ff3--
