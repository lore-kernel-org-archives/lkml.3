Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935637Ab3DPKUn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 06:20:43 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60139 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935596Ab3DPKUl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 06:20:41 -0400
Date: Tue, 16 Apr 2013 11:20:38 +0100
From: Mark Brown <broonie@kernel.org>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V4 0/7] DA9058 PMIC - please comment on this new
 driver
Message-ID: <20130416102038.GB26958@opensource.wolfsonmicro.com>
References: <201304121307.r3CD7tDi011782@latitude>
 <1854273.arIzJJ3lWV@dtor-d630.eng.vmware.com>
 <24DF37198A1E704D9811D8F72B87EB514191E2DC@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1UWUbFP1cBYEclgG"
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB514191E2DC@NB-EX-MBX02.diasemi.com>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1UWUbFP1cBYEclgG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 16, 2013 at 09:18:41AM +0000, Opensource [Anthony Olech] wrote:

> The reason why they are separate is that they are probed with different data
> structures and they use a different wrapper to access the "regmap" API.
> However, that is not a blocking issue, but it would mean re-writing the core
> MFD component of all the affected drivers. Maybe the way forward is:

> Is it possible to provide some "core" ONKEY API or functionality to handle the
> commonality in a similar fashion to the regulator core as done by Mark Brown?

Well, it's clearly possible to at least turn the polling and interrupt
combination into a library...

--1UWUbFP1cBYEclgG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbSXjAAoJELSic+t+oim9KU8P/3d1KhxeZtiD9oTQUs9eYAXQ
giYBt3sOxGfK0dXyuGalqS/fzsaCNDSyyNxlRRaelWAxH0EZAcUZeRXDZg1ikvVq
0906We8ThpcBXp3xq+sZJ0mCBimK93qkcR5rNxbGaHsRayNj7k3e/S55v0DdAsTb
KFqPczZtGYCqK6e8JIOgtr4kVQuxhBcHSjai5df5CsCG3OOk7dn6q3eX35kdjX4u
E1Q81ljRj5a4JV68ReJ1uAJWdVvU1xPpVXEjy2jvRINX9UuC9ZU5tD9LF/UEFpIl
hQknjJIaj1vv0cpePK2hErs+Gj+cJu3ZwKsz7TE+8hfTIxWc1RhRytJme8haFVzN
Kjdy4Pee0F0siQeJMAREdrkNc5KBeH0W3RMoXzqu1gzs6OmwvM5bJkp0XPCPkXsa
2ILCEbboOfWdvVCmc4izzAZ1xyKTZ1N68tKbYlMpC7uxOSgQzJqK6H0duk1T4KDQ
Z5Q9N74/kG+iqlEySS0/pTYXCtlHcng14BCeOsDWf0R9b8CV5ZuGqV6jFWg/aT3M
AsmNUSzxZIwpo0vr+uKmHoZabsii1F+q5uVWowW7fn+eO5zfrLu3l2zCPIMvJT1G
fX17cOjgiKOd1Anv8Y1Qx19uK9MDDG49QBDaCHoVzomk3S5Sup20eGwbeZq6jPNy
tv3jw/12KSOE/4OWRcLr
=Drkb
-----END PGP SIGNATURE-----

--1UWUbFP1cBYEclgG--
