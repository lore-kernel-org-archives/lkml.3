Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755846AbaHAS1o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 14:27:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:40448 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755688AbaHAS1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 14:27:41 -0400
Date: Fri, 1 Aug 2014 19:27:24 +0100
From: Mark Brown <broonie@kernel.org>
To: Jassi Brar <jaswinder.singh@linaro.org>
Cc: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        ks.giri@samsung.com, arnd@arndb.de, ijc+devicetree@hellion.org.uk,
        mark.rutland@arm.com, robh+dt@kernel.org, pawel.moll@arm.com,
        courtney.cavin@sonymobile.com, mporter@linaro.org,
        slapdau@yahoo.com.au, lftan.linux@gmail.com, loic.pallardy@st.com,
        s-anna@ti.com, ashwin.chaugule@linaro.org, bjorn@kryo.se,
        patches@linaro.org, mollie.wu@linaro.org, t.takinishi@jp.fujitsu.com,
        khilman@linaro.org, lee.jones@linaro.org, andy.green@linaro.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Message-ID: <20140801182724.GK30458@sirena.org.uk>
References: <1406896194-4667-1-git-send-email-jaswinder.singh@linaro.org>
 <1406896257-4814-1-git-send-email-jaswinder.singh@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1BXV+/FYeXhtv2WT"
Content-Disposition: inline
In-Reply-To: <1406896257-4814-1-git-send-email-jaswinder.singh@linaro.org>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.197.121.167
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv10 1/4] mailbox: rename pl320-ipc specific mailbox.h
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1BXV+/FYeXhtv2WT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 01, 2014 at 06:00:57PM +0530, Jassi Brar wrote:
> From: Suman Anna <s-anna@ti.com>
>=20
> The patch 30058677 "ARM / highbank: add support for pl320 IPC"
> added a pl320 IPC specific header file as a generic mailbox.h.
> This file has been renamed appropriately to allow the
> introduction of the generic mailbox API framework.

Reviewed-by: Mark Brown <broonie@linaro.org>

--1BXV+/FYeXhtv2WT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT29wJAAoJELSic+t+oim99XkP/2f3RgSRF/geI7M6GLa0XSOd
riSxK/d8lg5qoBBq8yaN2gY0jB6l7+L3FviOknj+8JBwDESnI86NHyaks4D8xDgK
1hg30DYswtcx8P3wMoKo5hGecOXWcEkIjIOrtnFDlTSuD6kKxy4rc6A2ISOlmDQh
flfFIHdcRRWE6pXZnwDthTIUVffW4nML12LL7demsSGr0ARwTwsQo9zz+5NC/usQ
znzVU5z+wcsVOjfbDPGu/Tc/FdPum8bAeW7Y1jcRb/JyKVtz2PyJ/08nTjUi5Y1q
Ib4rlb3L0u8UBpOP/wrfNQyAWXoNAeuEqGMzUQ943zNVu+pMk+UIlfoGl+Geb0Hr
cd5UtjrYGZyu1zNodEikBJKd2o2MPWofhdtdwL54DK9/iek5K0X9MpAEBCDagE4V
sqe/hMs4cI8y9kA5ILfFe/7s3eTzeRPGus1Sp3b+Gs11/hVDjUEk1sX2N4sUwksf
u8LW9CY0Mac8yJv0+r5swdf8y/gP+IIkd0FFwpkq+4QH4h/nWz9Jhq9QGOt2lT2I
8c59/yseyJozk7jKHtKVROqNX9JHjebdc7DuxpP2FNZFMQcpECFOrgRKd3SbfiVz
KlDrbOv+W1OwBT85X41oappYm1fqHJpUYOq0z5wjm0O5f1M130QJl8zXm4h7nnU1
5zBwysGzjyvd+6MZEVY7
=JYvt
-----END PGP SIGNATURE-----

--1BXV+/FYeXhtv2WT--
