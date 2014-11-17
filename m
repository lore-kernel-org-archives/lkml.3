Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbaKQMBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 07:01:21 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:53094 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbaKQMBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 07:01:19 -0500
Date: Mon, 17 Nov 2014 13:01:07 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Lukasz Majewski <l.majewski@samsung.com>
Cc: Mikko Perttunen <mikko.perttunen@kapsi.fi>,
        Eduardo Valentin <edubezval@gmail.com>,
        Zhang Rui <rui.zhang@intel.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@st.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Lukasz Majewski <l.majewski@majess.pl>,
        Nobuhiro Iwamatsu <iwamatsu@nigauri.org>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Alexandre Courbot <gnurou@gmail.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] thermal:cpu cooling:tegra: Provide deferred probing
 for tegra driver
Message-ID: <20141117120105.GH25699@ulmo>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-6-git-send-email-l.majewski@samsung.com>
 <5465DDC5.6090301@kapsi.fi>
 <20141117114341.GF25699@ulmo>
 <20141117125013.3493a3a1@amdc2363>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="X1xGqyAVbSpAWs5A"
Content-Disposition: inline
In-Reply-To: <20141117125013.3493a3a1@amdc2363>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--X1xGqyAVbSpAWs5A
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2014 at 12:50:13PM +0100, Lukasz Majewski wrote:
> Hi Thierry,
>=20
> > On Fri, Nov 14, 2014 at 12:47:33PM +0200, Mikko Perttunen wrote:
> > > Tested-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
> > >=20
> > > One potential issue I can see is that if the cpufreq driver fails
> > > to probe then you'll never get the thermal driver either. For
> > > example, Tegra124 currently has no cpufreq driver, so if
> > > CONFIG_CPU_THERMAL was enabled, then the soctherm driver would
> > > never be able to probe. But I don't really have a solution for this
> > > either.
> >=20
> > It doesn't seem like there's any code whatsoever to deal with cpufreq
> > within the soctherm driver, so deferring probe based on something
> > we're not using anyway seems rather useless.
>=20
> So, If I understood you correctly - this patch is not needed in the=20
> /tegra_soctherm.c:[tegra_defconfig] driver and can be safely omitted in
> v2 of this driver.

What I'm saying is that I don't think doing this mass conversion
wholesale is useful since none of the drivers register a cooling device
based on cpufreq. In other words: if you're not going to use a feature
there's no use testing for it.

Thierry

--X1xGqyAVbSpAWs5A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUaeOBAAoJEN0jrNd/PrOhMScQALxuo3xQqZHolHCaayZspSGX
VWHuHVZsB3W/Sd7hT4xQvR+55t2kIviEH8eKRSdcouKlfclFkmrpOvcPA5Pzko+7
0vBwFgD83qlSp+e8oMfOPkT8OKHzY+yciY5Qi5xsDfCSI2dPtgJcEPoujpTdhGRL
+qdPwBSQ5FTwz75FZRCtP1XWhcVdZWKjIQ72FX/6SlOfHVlikgqzr9JdMPe4cnGN
G6Qfl6ssbebW/DJ2xx6Afrk7rHk52wDfWk1SzXjreEU4fgHDQ/CQt8yvfci3C/1f
c0SeU+GWoziA/hbSzMTzvtAFBkH4SnLFsIn6Il9Xaw3HWTOHUGR3D2R+PKMqyYhD
rIh9Aeg+5PaxepHbYOKS3QFeJP5NSSSwCmXfZTI3La1cDK9GxeQRnNshdnFwgxjV
QG1TdlVPw7yoSA4+rG3mOA8oZDLfTg24+bmfgPQOa6l/g5s+6BVZr31wQKK/t6W2
qF1pi00yHt/2uyqVlQ36+V+mLZvrH0EeMWG4os8/qxErN7e/WLgAsdnnCEc6OWCR
TYZBHCQzVx0EAkTrpOh4+ql11/Sw85XQ0lANxwffG3M7lqLQp+VrS7vVMTLKl9/P
kPDC42OqLKgsym+9xs1uyO42y9W1HlOZ/BRhtvIcnKX5vPK4p4WWvwpkgkIpEKXA
VVTRSzBEbNy/nDufAmOc
=osN7
-----END PGP SIGNATURE-----

--X1xGqyAVbSpAWs5A--
