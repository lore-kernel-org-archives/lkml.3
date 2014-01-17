Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751538AbaAQDYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 22:24:13 -0500
Received: from mail-pd0-f175.google.com ([209.85.192.175]:54136 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbaAQDYD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 22:24:03 -0500
Date: Fri, 17 Jan 2014 11:23:47 +0800
From: Kevin Hao <haokexin@gmail.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: Kernel stack overflows due to  "powerpc: Remove ksp_limit on
 ppc64" with v3.13-rc8 on ppc32 (P2020)
Message-ID: <20140117032347.GB29880@pek-khao-d1.corp.ad.wrs.com>
References: <20140116180532.GA1616@roeck-us.net>
 <20140117022005.GA29880@pek-khao-d1.corp.ad.wrs.com>
 <1389927490.7406.10.camel@pasglop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yEPQxsgoJgBvi8ip"
Content-Disposition: inline
In-Reply-To: <1389927490.7406.10.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yEPQxsgoJgBvi8ip
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 17, 2014 at 01:58:10PM +1100, Benjamin Herrenschmidt wrote:
> On Fri, 2014-01-17 at 10:20 +0800, Kevin Hao wrote:
> > On Thu, Jan 16, 2014 at 10:05:32AM -0800, Guenter Roeck wrote:
> > > Hi all,
> > >=20
> > > I am getting kernel stack overflows with v3.13-rc8 on a system with P=
2020 CPU.
> > > The kernel is patched for the target, but I don't think that is relat=
ed.
> > > Stack overflows are in different areas, but always in calls from __do=
_softirq.
> > >=20
> > > Crashes happen reliably either during boot or if I put any kind of lo=
ad
> > > onto the system.
> >=20
> > How about the following fix:
>=20
> Wow. I've been staring at that code for 15mn this morning and didn't
> spot it ! Nice catch :-)
>=20
> Any chance you can send a version of that patch that adds the C
> prototype of the function in a comment right before the assembly ?

Will do. The patch is coming soon.

Thanks,
Kevin

--yEPQxsgoJgBvi8ip
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQEcBAEBAgAGBQJS2KJDAAoJEJNY7TDerrFxF3YIAKYibLWpNYAB+RQlqX1wkvjr
3/f/CDELFFZnuwmvbA75HiskEgHkKTr59gv8kNM6dVY63ORCKrFpa7j03rW2hpwX
Q4niqWrQZSZTjeZKndzhZ0mxQka52bL3Eo3xubOH4qFf0udMnGH5L2vIP4cjzcX6
pgDuNc2XdPL03l8g7cPp72F3mwg3+Se6/SAByJRYzUQdtHYbjfvMuL93zpbg4gt3
9aBYuAVVgVrr5e4MIEUWFtt2gAZDUqudAUY5GBLrTBk8MV/W4zTJluQ5FgM/L/cZ
a9wZiNM9PFT/i8QEWYi01iPfEx/0fT0dIxL6i1KaNMZJ6pFvhWPL7QOaHnSsitk=
=VvUL
-----END PGP SIGNATURE-----

--yEPQxsgoJgBvi8ip--
