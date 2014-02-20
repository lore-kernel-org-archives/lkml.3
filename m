Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972AbaBTK47 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:56:59 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:63040 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946AbaBTK4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:56:55 -0500
Date: Thu, 20 Feb 2014 18:55:40 +0800
From: Kevin Hao <haokexin@gmail.com>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>
Subject: Re: [PATCH v4 0/4] Bugfix for of_match_node ordering
Message-ID: <20140220105540.GB3745@pek-khao-d1.corp.ad.wrs.com>
References: <1392819290-1044-1-git-send-email-grant.likely@linaro.org>
 <CAK9yfHwwmZkFMRvxsxjBAfUbVXU3V+iPFDZO=DwQsFvJ3NQyKA@mail.gmail.com>
 <20140220101240.GA3745@pek-khao-d1.corp.ad.wrs.com>
 <CAK9yfHzM_kyXMrnLC=M0qiLHKWxE41E-MdyGtipKA7AwoLnOqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="24zk1gE8NUlDmwG9"
Content-Disposition: inline
In-Reply-To: <CAK9yfHzM_kyXMrnLC=M0qiLHKWxE41E-MdyGtipKA7AwoLnOqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--24zk1gE8NUlDmwG9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 20, 2014 at 03:57:07PM +0530, Sachin Kamat wrote:
> Hi Kevin,
>=20
> On 20 February 2014 15:42, Kevin Hao <haokexin@gmail.com> wrote:
> > On Thu, Feb 20, 2014 at 02:09:08PM +0530, Sachin Kamat wrote:
> >> Hi Grant,
> >>
> >> I observe the following boot failure with today's (next-20140220) linu=
x-next
> >> tree on Exynos based boards with the default exynos_defconfig.
> >
> > Does this help?
>=20
> The below patch works for me. Thanks for the fix.

Thanks Sachin.

Hi Grant,

I assume you would fold this change into the original patch. But if you want
a separate patch, please let me know.

Thanks,
Kevin

--24zk1gE8NUlDmwG9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJTBd8sAAoJEJNY7TDerrFxtMYIALc7gLsCqgtdAzjMuIHk0T0W
ILfOk3ZoPiRb6TtopmvbFxaYR+EGJUs4VI5cEhTa9ZidIR/+DlVPN4211PvwwJLm
73/JUYBnPrGvt3QE5qkge2TynWogH9Isb8p3YFe9/CmDlrxqpvXH4gQq8548Dvt7
lQL5s3GOk1YLdz6d07SorpQpDWx6+bBCTIG6PMUq2Ysw/i/LSR/dp1+XoQemJ91E
isqUykgbBKMuPD0rgDk1BxMR8RyJfzG2HweQzE/PGKnxLuxcM5OBpJFpv6Z1naF/
AprsacDjacyR2HeoZ/BA/3RabQntQLwSQohQhRo7wUYUUbgtjj4P1PxEkn+NBFw=
=qp1m
-----END PGP SIGNATURE-----

--24zk1gE8NUlDmwG9--
