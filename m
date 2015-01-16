Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbbAPPJw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 10:09:52 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:36690 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655AbbAPPJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 10:09:50 -0500
Date: Fri, 16 Jan 2015 16:09:45 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris Brezillon <boris.brezillon@free-electrons.com>
Cc: David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Clark <robdclark@gmail.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: Re: [GIT PULL] drm: Add Atmel HLCDC driver
Message-ID: <20150116150940.GC7775@ulmo.nvidia.com>
References: <20150109160342.715d3592@bbrezillon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="raC6veAxrt5nqIoY"
Content-Disposition: inline
In-Reply-To: <20150109160342.715d3592@bbrezillon>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--raC6veAxrt5nqIoY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 09, 2015 at 04:03:42PM +0100, Boris Brezillon wrote:
> Dave, Thierry,
>=20
> Here is the pull request for the Atmel HLCDC driver and its
> dependencies (some modifications to drm/core and drm/panel to define
> output bus format).
>=20
> I'm sending a pull request for this driver for several reasons:
>=20
>  * The patch series has been around for 6 months (initial version here
>    [3]), and has seen 9 iterations, taking into account comments made
>    by reviewers.
>=20
>  * It has received several Tested-by by various users/developers.
>=20
>  * It has been Reviewed-by Rob Clark.
>=20
>  * There has been no comment whatsoever since more than a month (see
>    [1] and [2] for the last modified version of these series).
>=20
> I'll be happy to take comments into account if any. But if there are no
> more comments, please merge for 3.20.
>=20
> Best Regards,
>=20
> Boris
>=20
> [1]https://lkml.org/lkml/2014/12/1/717
> [2]http://thread.gmane.org/gmane.comp.video.dri.devel/118700
> [3]https://lkml.org/lkml/2014/6/9/487
>=20
> The following changes since commit c93546a5e32bd788c22aefa072385f3784551c=
13:
>=20
>   Merge tag 'topic/atomic-core-2015-01-05' of git://anongit.freedesktop.o=
rg/drm-intel into drm-next (2015-01-09 09:22:40 +1000)
>=20
> are available in the git repository at:
>=20
>=20
>   https://github.com/bbrezillon/linux-at91.git tags/atmel-hlcdc-drm-3.20
>=20
> for you to fetch changes up to e7f6614add3dc7776abd803be7cbe96b6254b3f5:
>=20
>   drm: add DT bindings documentation for atmel-hlcdc-dc driver (2015-01-0=
9 14:55:08 +0100)
>=20
> ----------------------------------------------------------------
> Boris Brezillon (5):
>       drm: add bus_formats and num_bus_formats fields to drm_display_info
>       drm: panel: simple-panel: add support for bus_format retrieval
>       drm: panel: simple-panel: add bus format information for foxlink pa=
nel
>       drm: add Atmel HLCDC Display Controller support
>       drm: add DT bindings documentation for atmel-hlcdc-dc driver

For patches 1 to 3:

	Acked-by: Thierry Reding <treding@nvidia.com>

For patches 4 and 5, I don't have the time to properly review them, but
=66rom a very quick glance I couldn't spot anything completely out of the
ordinary, so I think it'd be okay to merge these for v3.20.

Thierry

--raC6veAxrt5nqIoY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUuSm0AAoJEN0jrNd/PrOhE14QAJKYxgc5Ifz7pwGt/UezEOJn
m9cqGpNoVBuJdsK2T/bduZngr8WJ8cRIt3Q5RqUjojeHI+lCCa1sGKc9pP6IZrwP
Jf6J7cokslHwdEhU3rHP80rSmEceKo4JdsnrDJz3g05+F0wE3fH+8DjytyeR372B
RTktM/iFGzaCpXP5sFZelvJ2jut1uCs3mrYrpR7y3eJT5SzpNA/2YWjcIlAAKxoH
QN82RmCshX6zLgIZH4gOJlQdNYa/C+SMIF9+Mto0pAUOI1mI93bkXm1Vtn7ExztN
yqMIoQT1ZsEbOZaN62CrpZEzPAdbMr64jHjHHb0pVwzvzqIykFgPvXpnF4jMAop7
+J2W7iL+U28wwPkR1MoByXTdQE1Y+6w07tOUhSK4Fm2qtCBFEgM06eruZUGH/kiR
Y7VF3CRe8lcIvYHXy6YY/2/HdFpb5Xqr1ba+M0Y/leDbOe3eeh5ZrPxCrq1QgSR2
FkmxVqWTkc8t/Rv1HFJ72gkR1Ik2FScZ3pCSQjGob1oOcTTnq7rIj8aVl2in2ukh
rcpLWhNB4jJ7THGRbYXCcO68Rpec+TxO84cVlPNeW1SaOrNh3Pwhu3kd4p5dTYWa
bAWWJDpnuEQH7Hy/XdK0Oupcy9mIR9sLbvONwlSf0ZkcycNH02EUFARKoD4aez/3
vrZPpkbgu0WHZAiqVc9a
=wGB6
-----END PGP SIGNATURE-----

--raC6veAxrt5nqIoY--
