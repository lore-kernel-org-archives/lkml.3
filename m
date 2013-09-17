Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3IQPh2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 11:37:28 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:43151 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752854Ab3IQPhZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 11:37:25 -0400
Date: Tue, 17 Sep 2013 10:36:16 -0500
From: Felipe Balbi <balbi@ti.com>
To: Julius Werner <jwerner@chromium.org>
CC: Tomasz Figa <tomasz.figa@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Subject: Re: [PATCH 1/3 v5] usb: phy-samsung-usb: Simplify PMU register
 handling
Message-ID: <20130917153616.GG15645@radagast>
Reply-To: <balbi@ti.com>
References: <1375812017-6287-1-git-send-email-jwerner@chromium.org>
 <20130808092615.GF14648@e106331-lin.cambridge.arm.com>
 <CAODwPW-j=JjunZU3zewrE1_-WoW-RXLmKVQypzxmo_BOYjc3VA@mail.gmail.com>
 <1729120.r596vOTlMW@flatron>
 <CAODwPW_W9gu+nwNzpq3sfcOCDkyppu6K8C9+S8OZt_A0qHqNEg@mail.gmail.com>
 <CAODwPW8KG2ZxOFf936H233g35KVPjDp+f8e3qgkd4Z7NN9RAtQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+ZmrHH5cGjskQnY1"
Content-Disposition: inline
In-Reply-To: <CAODwPW8KG2ZxOFf936H233g35KVPjDp+f8e3qgkd4Z7NN9RAtQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--+ZmrHH5cGjskQnY1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Aug 27, 2013 at 01:27:48PM -0700, Julius Werner wrote:
> *Ping!*
>=20
> Are there still unanswered concerns left with this patch? I hope my
> prior mails could clear up why I think that the PMU register
> description in the device tree for a specific PHY is represents the
> hardware more accurately after my patch, and my analysis of the
> Exynos4 situation currently not being implemented (and therefore not
> needing to be addressed by this patch) was correct. Please let me know
> if you have further objections... and if not, could we agree to have
> this picked up somewhere?

I need acks for DTS part...

--=20
balbi

--+ZmrHH5cGjskQnY1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJSOHbwAAoJEIaOsuA1yqRERCAP/jeaTKdJ4KGpEjMQLRUgeNuF
tiQ9FPviR1dIq+nL7FITOmjt9uiS5uojgZOt6c1BX4RyxJySm2cAfKYKVK1LSCN4
AC44lEAzHaCtLazV0WmGnMIjXfvxMe6bb6uxXxVBCOGwwrKGG8WZXPeTxW+VNIeJ
FQN1UpPckdDGhFbGNjmf4LBi7N0dof9Nkk0d4e/bRZGcPrJgHNlDCuY9d8AlenL0
j9HUn/xd60y8+QCGKCpYqwcboD4AevlGopNG612BhWmBcquS4ejnDiwk37iX7pUf
5RET7HqNRYCYWdi0aPVteC4Db1fPYpBfTUpaevgorEbyr06/JejyuIrNiGkEPv+Q
FWfGcJPNcFc2d09yrXUnCn2vzEFZ6o5uLlLuCYnn6E4ZbsqRK4yMzV2pXTc5At8+
Iu3fLoSmJhGverc7W/uyX8Y2NXQTR8aNgn4kG2FYQfnlthR6a7glQzkRq8Q5ciyC
+Cp89Qa7PhqLwz8ZBKxxULxGIvMXdjrUAfHP9c40FAT9qhJJZR4Jeb3kWkybGuFS
BmwdqqMMH9BdZUjEVcEvrTAyaBBKE/n8EfsDFokgNotrXdpM6nKMuezji2+NaqQm
aUxjXBOqYbJvXDzKGkHLSxgtrS+GQ6hdIg8xYujLzPaeAtA/eaNlqxP7kKSHfLE3
R/8TMRjDlzay4OgsyzPt
=2p3m
-----END PGP SIGNATURE-----

--+ZmrHH5cGjskQnY1--
