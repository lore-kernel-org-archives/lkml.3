Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaKQNJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:09:06 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:34462 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623AbaKQNJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:09:01 -0500
Date: Mon, 17 Nov 2014 14:08:58 +0100
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
Message-ID: <20141117130856.GB18767@ulmo>
References: <1411547232-21493-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-1-git-send-email-l.majewski@samsung.com>
 <1415898165-27406-6-git-send-email-l.majewski@samsung.com>
 <5465DDC5.6090301@kapsi.fi>
 <20141117114341.GF25699@ulmo>
 <5469EF4C.1050007@kapsi.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pvezYHf7grwyp3Bc"
Content-Disposition: inline
In-Reply-To: <5469EF4C.1050007@kapsi.fi>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pvezYHf7grwyp3Bc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 17, 2014 at 02:51:24PM +0200, Mikko Perttunen wrote:
> On 11/17/2014 01:43 PM, Thierry Reding wrote:
> >On Fri, Nov 14, 2014 at 12:47:33PM +0200, Mikko Perttunen wrote:
> >>Tested-by: Mikko Perttunen <mikko.perttunen@kapsi.fi>
> >>
> >>One potential issue I can see is that if the cpufreq driver fails to pr=
obe
> >>then you'll never get the thermal driver either. For example, Tegra124
> >>currently has no cpufreq driver, so if CONFIG_CPU_THERMAL was enabled, =
then
> >>the soctherm driver would never be able to probe. But I don't really ha=
ve a
> >>solution for this either.
> >
> >It doesn't seem like there's any code whatsoever to deal with cpufreq
> >within the soctherm driver, so deferring probe based on something we're
> >not using anyway seems rather useless.
> >
> >Thierry
> >
>=20
> My understanding is that there needs to be no code inside soctherm to han=
dle
> it, as the cpufreq driver (cpufreq-dt) will register a cooling device that
> will then be bound to the soctherm sensors using the of-thermal device tr=
ee
> properties. At this moment, however, we don't have that cpufreq driver so
> this patch is still useless for Tegra.

But if the cpufreq driver will automatically do this already, why do we
even need to check for it in the soctherm driver?

Thierry

--pvezYHf7grwyp3Bc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUafNoAAoJEN0jrNd/PrOhS5QQAJp82TtAus+a48UB9FClXq+j
Ybl9po7+2cVZyhZuSbTwIyYy5hXWsnXf/dBDzqP2YG4E7Iw9xjwOVB1dcHZwi5dO
282D+mTKVYE9jCZaw1U7nNIGDBGu/mWFTUZyR9xJulszNE74Am5F0AZEKX4kc2fH
XXCTEuAFUYFzeia9HbhO5S6oVBic6DM50spyd9WskUCvND//SyZsIHS0ie390Fdr
Q+CtKCQVprqzNWhIifrzDeVXR9hPP6SE9kSyAhyGYcQvIcrTHKzwTLZ6Mn0/f/UL
oUzAzhSl2ehPSc4qLg/3MuuDTsgSkcn9uk7nSP7C2fDO74biKDb5Dl7nnNhfXXef
A9DOaEON5Bms2LSyvMcuWXhLmt3LOeXyybIB6wU8BuUJ+YIG/xoDtUFekPfRGA9W
QsHeHTfAgA3iAiYzTWA3G2tCxnpeo6OezuXR2C8eQJz2wtVahrbzSkqoFfAa6gpt
3z98Db3SDCN5I+8V+X2yAQ6mxu616z4iOVT8ceXqfmK06Kl5G2yxsapoRHOUV+pV
TJbIAsDphrP5CeQ3ZR5qPn2y/sxofGvo+pI4xabPCmPgPRNa2nDg/FBlq4qhzs5g
jd7Fb34X93nN5N9P9xUyzwtKs0200qkbP49RK0tJ1IXz+TaURGPDtZKZj0kQrr9A
dP1i3E4bkofY/czQQRqG
=V5SQ
-----END PGP SIGNATURE-----

--pvezYHf7grwyp3Bc--
