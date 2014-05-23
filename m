Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751424AbaEWHeZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 03:34:25 -0400
Received: from mail-ee0-f47.google.com ([74.125.83.47]:39556 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178AbaEWHeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 03:34:22 -0400
Date: Fri, 23 May 2014 09:31:59 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Alexandre Courbot <acourbot@nvidia.com>, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>, Lucas Stach <dev@lynxeye.de>,
        "nouveau@lists.freedesktop.org" <nouveau@lists.freedesktop.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] drm/ttm: introduce dma cache sync helpers
Message-ID: <20140523073159.GE6310@ulmo>
References: <1400483458-9648-1-git-send-email-acourbot@nvidia.com>
 <1400483458-9648-3-git-send-email-acourbot@nvidia.com>
 <20140519083355.GA7138@ulmo>
 <CAAVeFuKCx677Uxcu3XNLkU+er-GBAxqdj_hUDUXHwUN+CS5EsA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hwvH6HDNit2nSK4j"
Content-Disposition: inline
In-Reply-To: <CAAVeFuKCx677Uxcu3XNLkU+er-GBAxqdj_hUDUXHwUN+CS5EsA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--hwvH6HDNit2nSK4j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 02:49:40PM +0900, Alexandre Courbot wrote:
> On Mon, May 19, 2014 at 5:33 PM, Thierry Reding
> <thierry.reding@gmail.com> wrote:
> > On Mon, May 19, 2014 at 04:10:56PM +0900, Alexandre Courbot wrote:
> >> From: Lucas Stach <dev@lynxeye.de>
> >>
> >> On arches with non-coherent PCI,
> >
> > I guess since this applies to gk20a
> >
> >> we need to flush caches ourselfes at
> >
> > "ourselves". Or perhaps even reword to something like: "..., caches need
> > to be flushed and invalidated explicitly", since dma_sync_for_cpu() does
> > invalidate rather than flush.
>=20
> Rephrased as "On arches for which access to GPU memory is non-coherent, c=
aches
> need to be flushed and invalidated explicitly at the appropriate places."

Nit: s/arches/architectures/

Thierry

--hwvH6HDNit2nSK4j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTfvlvAAoJEN0jrNd/PrOhQiIP/AiDx9oH1hs0VSq3AYwSSkYz
g+yR5eXTlIoC0hIdR5/N39iTcZHbXkf8Y5J8hijMZA8DiqdUMzSEnORZEkvOdefP
lv2KJqEcYG/KiH4+nrtUirbPNv5S6QqBbOcSi8dmbtLGN/WcxWrqBLDpfK4yZ5LH
glVn476lkN+srnNN8Ml+BQJOc26Yjzke34+2s7zMmMVcXX+5s3YtygKZ+ATxaiKJ
O2xrgCCqlSbRyvy3LWuQtfs41yLuusOHa3dDgCM2ii5c5ki+qCrgVlD3dNhn/sFL
ala1EzQXKpyeuaMdBz1Iy4kJ0oWFRBMqDFjRS84RYvWKg+bmIeDVgidpipXUOkjQ
5ViqLfAP6QyPzbzkk6pPSRHQsdO6U8gRzEwPz+ndoTSLDfn1iYm4SnHNTe3sU8B3
jRf4MrLh4HTXbkJmuLbaaw9xoLxChipxjIDs7X9HD3UxDuArtfFwi1nOeVokoMkO
AGftjvho/qB12Ejmjj0M93B7tYwsfuEa4rP+TCw033bKetaay7Ki8Sj9oPWGSYiG
JBh6KuKHRb8QH7SO9aeUnAgEa9zAnzLKKATXBitaawoZHuSmQm2pdkBf6WZWTf0e
wGL4wGLfHK8HcS4qOASChx5Nfst4kTL3xs/tpJ4osL9gP70spTwvTvPAi5jExR46
+EZwQZgjAjnZv3VLSmXm
=frga
-----END PGP SIGNATURE-----

--hwvH6HDNit2nSK4j--
