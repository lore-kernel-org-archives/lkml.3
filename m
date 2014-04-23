Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755686AbaDWQJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 12:09:47 -0400
Received: from ring0.de ([5.45.105.125]:49725 "EHLO ring0.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754343AbaDWQJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 12:09:45 -0400
X-Spam-Report: * -0.0 NO_RELAYS Informational: message was not relayed via SMTP
	* -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 NO_RECEIVED Informational: message has no Received headers
Date: Wed, 23 Apr 2014 18:09:37 +0200
From: Sebastian Reichel <sre@debian.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Jonathan Cameron <jic23@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Marek Belisko <marek@goldelico.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, linux-iio@vger.kernel.org,
        Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Subject: Re: [PATCHv2 1/2] rx51_battery: convert to iio consumer
Message-ID: <20140423160936.GB32049@earth.universe>
References: <1393375569-21751-1-git-send-email-sre@debian.org>
 <1393705366-32420-1-git-send-email-sre@debian.org>
 <1393705366-32420-2-git-send-email-sre@debian.org>
 <5336A9F9.4080504@kernel.org>
 <20140420120823.GB12135@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="PmA2V3Z32TCmWXqI"
Content-Disposition: inline
In-Reply-To: <20140420120823.GB12135@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PmA2V3Z32TCmWXqI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 20, 2014 at 02:08:23PM +0200, Pavel Machek wrote:
> On Sat 2014-03-29 11:09:45, Jonathan Cameron wrote:
> > On 01/03/14 20:22, Sebastian Reichel wrote:
> > >Update rx51-battery driver to use the new IIO API of
> > >twl4030-madc and add DT support.
> > >
> > >Signed-off-by: Sebastian Reichel <sre@debian.org>
> > This looks fine to me.  I'd love to see a more generic solution, but
> > we can work on that another time.
> >=20
> > Acked-by: Jonathan Cameron <jic23@kernel.org>
>=20
> Reviewed-by: Pavel Machek <pavel@ucw.cz>
>=20
> I don't see this patch in 3.15-rc nor -next. What is needed to push
> this patch?

The problem is, that the power subsystem maintainers seem to be too
busy with real life. The last change in their git [0] was 2014-02-01
and I haven't seen any mail from them on the mailinglist since about
the same time. I have just queried his status @ Google+ (there were
some life-signs there).

[0] http://git.infradead.org/battery-2.6.git/

-- Sebastian

--PmA2V3Z32TCmWXqI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBCgAGBQJTV+XAAAoJENju1/PIO/qaNJYP/1BQtRMaBOpjJRSi4wbXkTg6
/KjOdujCzAJEPxBfMZ2jvGDLOXxY/xd44VIfyjKNvq9Om2YfO01xMgwtujMKn16w
vAqsU9lAY1kjv8dEWjFxS7vCQ9tqttqfxaJ4/fbxJZiUiMjJZ0aUpIjUGqn0/Jeq
L1c9tjmFVFCUT9S0dac9eNIrxq01yqAYAD9fhFeCkoL0qH0gkTZIMgDn7u3VbfWj
45LvsuK451PeTreywl+IWBX412dgzCFLaTSIH672rKk3w/TJ4kRfue64fY3NXebi
22/v7Pjx09lk/LCCrQGieTfktYiQtf+4nynagVc7ArscfXKuJrQ5xqxYyRStbZxl
x0DXvvJJ8+ImhJ2XXtbmJ+HP60lMQxc1s6Km4w/4AILfJXeDGE0iWZwN/CUTTdM3
22mx3lJrxRITaU3tWeM1FKb+wyzygFb5lMHpwrF0rStHA/DuzKP80zKSngDJE4cL
BWrChW42vbedDPGE9gKcOvT/XeSVbJt/gEGxSwVqxbGuoEZTRQ4AbQYxutSRv5xy
PXVWdXLoNc1tIzpELXQ8n0bPy4xI9d8tCG7xHwruDSeYWkf3r+FU1/laG1HndFvl
uJKOUhSqQEi+lh6LHVaKB79dDlioYN0xhyZhnOGh9+M1NDap4U0QmygIhgVBS+LC
p0LD9AKLTdmKzhfMQ246
=5r4P
-----END PGP SIGNATURE-----

--PmA2V3Z32TCmWXqI--
