Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752710AbaKQLns (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 06:43:48 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:50763 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaKQLnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 06:43:46 -0500
Date: Mon, 17 Nov 2014 12:43:42 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mikko.perttunen@kapsi.fi>
Cc: Lukasz Majewski <l.majewski@samsung.com>,
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
Message-ID: <20141117114341.GF25699@ulmo>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-6-git-send-email-l.majewski@samsung.com>
 <5465DDC5.6090301@kapsi.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VuQYccsttdhdIfIP"
Content-Disposition: inline
In-Reply-To: <5465DDC5.6090301@kapsi.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VuQYccsttdhdIfIP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 14, 2014 at 12:47:33PM +0200, Mikko Perttunen wrote:
> Tested-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
>=20
> One potential issue I can see is that if the cpufreq driver fails to probe
> then you'll never get the thermal driver either. For example, Tegra124
> currently has no cpufreq driver, so if CONFIG_CPU_THERMAL was enabled, th=
en
> the soctherm driver would never be able to probe. But I don't really have=
 a
> solution for this either.

It doesn't seem like there's any code whatsoever to deal with cpufreq
within the soctherm driver, so deferring probe based on something we're
not using anyway seems rather useless.

Thierry

--VuQYccsttdhdIfIP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUad9tAAoJEN0jrNd/PrOhLIsP/1G321EqqSncBH2hzi6gCgxG
3soPbr2DILZiCD2PlNuzWohtQe8Z8vuYKc/MmtHxJbx2X1gHMuwq/TFk1LeszZR7
NWYwjkfKzzDEOVoVVLdbi+8Mu36pJws0Q8YU8WGatoJWfnUWblsWB1UyGThLWm3p
Pw8dxgFuTzQELXbdn5aaHLz0YjZvu7NdoxNAwK2wiq5O1/94oDclqIYkcXWf5ddv
hU7FUx5/yvJA3xwtnT5PgchX10ZL6ey6sB3ScTnUz9scZM+4e0BzEN2E8C5L983Y
OjmpMFtQpyGdEhoo/9vc3QpGPOx5oc91IjseaDQZLL9ZCZF18p4WcdrldxxAVEbI
QCFKXlG3tOOIf53wlM6HvlhBBHLMF8AK54oDqVBhDOketFBnSdt6Wlv5GDQDHozg
PgJnjjqx4wjmtJ9fjImlNr2kM/eJxec43T6jgjPXVcYXx0M3yzZmwPtMxvfe/B1f
tWUy9WbPtBHX0nXCfOeZvlPx9IL3NdDhGhZe6+9h1gln0EU7lnmSiZKTe+zKJoEv
57ip63aEwUqxZFxnKsXIn70RyhJX1y8h5yK1XAmYzBMWls66PWQwE4TlQQRMafgy
f9sc5MNXV55NXRd/9gB9PU+Ql1w2eHdt1PoKYwBcw6s6BuLf1q+2rEWQLFaUhTHm
Elt+qT+JqM+KJElClzwQ
=u8ec
-----END PGP SIGNATURE-----

--VuQYccsttdhdIfIP--
