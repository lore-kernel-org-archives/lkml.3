Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab3FKSf2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 14:35:28 -0400
Received: from mail-bk0-f45.google.com ([209.85.214.45]:35762 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab3FKSf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 14:35:26 -0400
Date: Tue, 11 Jun 2013 20:35:22 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Ryan Mallon <rmallon@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-pwm@vger.kernel.org" <linux-pwm@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "poeschel@lemonage.de" <poeschel@lemonage.de>,
        "rob@landley.net" <rob@landley.net>
Subject: Re: [PATCH v4] pwm: add sysfs interface
Message-ID: <20130611183521.GC29842@mithrandir>
References: <201306101612.07708.hartleys@visionengravers.com>
 <20130611101432.GA932@manwe>
 <51B709F5.8070909@gmail.com>
 <ADE657CA350FB648AAC2C43247A983F0021DA690F61B@AUSP01VMBX24.collaborationhost.net>
 <ADE657CA350FB648AAC2C43247A983F0021DA690F63A@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="adJ1OR3c6QgCpb/j"
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F0021DA690F63A@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--adJ1OR3c6QgCpb/j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2013 at 11:47:23AM -0500, H Hartley Sweeten wrote:
> On Tuesday, June 11, 2013 9:09 AM, H Hartley Sweeten wrote:
> > On Tuesday, June 11, 2013 4:29 AM, Ryan Mallon wrote:
> >> On 11/06/13 20:14, Thierry Reding wrote:
> >>> On Mon, Jun 10, 2013 at 04:12:07PM -0700, H Hartley Sweeten wrote:
> >>>> +config PWM_SYSFS
> >>>> +	bool "/sys/class/pwm/... (sysfs interface)"
> >>>> +	depends on SYSFS
> >>>> +	help
> >>>> +	  Say Y here to provide a sysfs interface to control PWMs.
> >>>> +
> >>>> +	  For every instance of a PWM device there is a pwmchipN directory
> >>>> +	  created in /sys/class/pwm. Use the export attribute to request
> >>>> +	  a PWM to be accessible from userspace and the unexport attribute
> >>>> +	  to return the PWM to the kernel. Each exported PWM will have a
> >>>> +	  pwmX directory in the pwmchipN it is associated with.
> >>>=20
> >>> I have a small quibble with this. Introducing options like this make =
it
> >>> increasingly difficult to compile-test all the various combinations, =
so
> >>> I'd like to see this converted to a form that will play well with the
> >>> IS_ENABLED() macro. We already have the same issue with DEBUG_FS, only
> >>> to a lesser degree because it doesn't have an additional PWM-specific
> >>> Kconfig option.
> >
> > How about removing the Kconfig option and just doing:
> >
> > obj-$(CONFIG_SYSFS)			+=3D sysfs.o
> >
> > This way the PWM sysfs interface is always compiled and included in the=
 build
> > as long as CONFIG_SYSFS is enabled. The check in the header would chang=
e to
>=20
> That didn't work. As Ryan pointed out we get undefined references due to
> sysfs.c being compiled but not core.c when CONFIG_PWM is not enabled.

Why not add dummies for the missing functions? It was my impression that
we had dummies for all of them already, but if not they should certainly
be added to match what other subsystems do.

Thierry

--adJ1OR3c6QgCpb/j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRt23pAAoJEN0jrNd/PrOhIxIP/RPyE1M8jFMvtlMsAjJnP1Mo
WoPRAq9jPFGA8i7Tym0bc7X1tCdJnVMHoBbzHG4uNg07mexiDnzVRzhJkzVa7/or
1GoY12JTrO6NQJDmgZrCOolqG85kxFrWP2BJy5gn7Nj3kixTzIWE2pn1IZIzLDI9
DMckTFB5DB+3GkG7R89RGZGUurVfxz++NuQcUIY7TYJtj8FFQNPk258R6zlPgYbi
VypO105Xrr6i3rgJ24Q+S0UVXGwNslGU9e2a0KK++NytVTkzyQk+T+4XUnqmMR+T
MbL2df8bbY0g9+fX1iKzNYF1BayHgNplV2FdthvyZsMyTgdVpQ8MQ7vmYPYaN7GB
7WVevPvoSqGxiQ8UZT8er5UnxJdR2vIpeHLEibEypOZpwpk8pw/pA0lio/acj+Yn
HbNL8rZPBRXuJ1UeuktkNyTHZNa/cyE4QufZ55G8JMxB4mb2X+4yZctvkL7tMhLI
/iwsx43g+/UZJYHuG0NzGECh1aKm0F7u4FjvA1d21iqz0XwU7bIQGQT2LRsMFjde
hvU/WQ8n9KI3fOtNx5ADfJi6CYJSvvtf+96NsSKXswLYF0bkybBMhRDbBdf/cbzN
T/09h6ulWVXHfYQ/rwXH3whxmoX++q5QVGvBMaYdJBhvsBZmQbUl0dSROKEc5daJ
jr6KeBSYOwS4LuitBfpL
=3dyc
-----END PGP SIGNATURE-----

--adJ1OR3c6QgCpb/j--
