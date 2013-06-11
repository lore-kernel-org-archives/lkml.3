Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754417Ab3FKKdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 06:33:22 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:65499 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406Ab3FKKdV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 06:33:21 -0400
Date: Tue, 11 Jun 2013 12:33:17 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Tuomas Tynkkynen <ttynkkynen@nvidia.com>
Cc: gregkh@linuxfoundation.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/2 v2] Bugfixes for Tegra memory controllers.
Message-ID: <20130611103316.GC932@manwe>
References: <1370945479-2917-1-git-send-email-ttynkkynen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p2kqVDKq5asng8Dg"
Content-Disposition: inline
In-Reply-To: <1370945479-2917-1-git-send-email-ttynkkynen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p2kqVDKq5asng8Dg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2013 at 01:11:17PM +0300, Tuomas Tynkkynen wrote:
> Hi,
>=20
> Here's two simple bugfixes for the Tegra memory controllers.
>=20
> v2: Fix a dumb bug in the bit masking.
>=20
> Tuomas Tynkkynen (2):
>   memory: tegra20-mc: Fix hang in IRQ handler.
>   memory: tegra30-mc: Fix IRQ handler.
>=20
>  drivers/memory/tegra20-mc.c | 5 ++++-
>  drivers/memory/tegra30-mc.c | 9 ++++++---
>  2 files changed, 10 insertions(+), 4 deletions(-)

Both patches:

Reviewed-by: Thierry Reding <thierry.reding@gmail.com>

On a side-note, the subject format looks a bit strange and my guess is
you had to manually edit it to insert "v2". git can do it for you when
you generate the patch series using:

	git format-patch --subject-prefix=3D'PATCH v2'

That'll also automatically add the v2 to all individual patches instead
of just the cover-letter.

Thierry

--p2kqVDKq5asng8Dg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRtvzsAAoJEN0jrNd/PrOhDSoP/ioru5baiKmqnFogqzPuwkp2
Ohvm8jhu/kKyj7eZlJRzGlm7B6DkvKoVTtGhLovholsMfFYuxNBC3Hc89+Z4qzdC
d0n1FQ/HYsOa6YrrJHQqWohN24U1b+GYWHfsgZgtQmp7QgsFFM1Oy5aYMiuUnO2B
OfCT9RpqWOOpFVvC3I68yqp/k3CMMAwnPAdU6mH9yLQOOAYKzCX1dVIVPiQLo0pL
wrvy73qucZpV+sVf9dbjNxsIhWgpNkf/aXX0oJLAcbb7P4sO5PnqHcCqrAL9WmDd
DR71zAnw4TAff/k+7jjsoOj3jWQd5o6SJgxvkplB7ypcc8vVLlXyA1W2g7ilcLcQ
EVPL8/7TB+3qC3QOZm6pWq+5tVqwA4i2KyfHbOi4/87MUNIxdu69rX1hUZZSdllh
0PkeY17XSiFj0wCx05YIn3bQX6mB0IP3cOSDYKq110J2FLNblRIgMD5h1Z7dblJJ
agWheMTFLng5XBL5ZXzTcw2FoEY9T8wb3hdmqok4Z/ndrjmM0OHhcW3keKJ88gBR
rYavKDlLU17pH59cGu7Hrs3wB0jG/AeTQjlrxikYfbT3zqxaA/iWWeF2a78Fs4+E
2p+GGig2iwbjr8cwgZ2xvL3sw2MvNl563aSwIzY3uTr2btsPkJL8N3gL3w/4wLUD
P4NrB6whhf0WpKcqhIks
=FOUi
-----END PGP SIGNATURE-----

--p2kqVDKq5asng8Dg--
