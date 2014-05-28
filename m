Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754215AbaE1RjN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 13:39:13 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:45778 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaE1RjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 13:39:11 -0400
Date: Wed, 28 May 2014 18:38:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arvind Chauhan <arvind.chauhan@arm.com>,
        Eduardo Valentin <edubezval@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20140528173858.GG5099@sirena.org.uk>
References: <1780c3205893be8567fa29ccd86674e2f32555b4.1401192160.git.viresh.kumar@linaro.org>
 <20140527192923.GC12304@sirena.org.uk>
 <CAKohpo=AnusM2FGs=JLozSyTc0N7SDXQxe+rPiLEHP6ewxY4ow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="B8ONY/mu/bqBak9m"
Content-Disposition: inline
In-Reply-To: <CAKohpo=AnusM2FGs=JLozSyTc0N7SDXQxe+rPiLEHP6ewxY4ow@mail.gmail.com>
X-Cookie: Ditat Deus.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/2] regulators: Add definition of
 regulator_set_voltage_time() for !CONFIG_REGULATOR
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--B8ONY/mu/bqBak9m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 28, 2014 at 09:59:37PM +0530, Viresh Kumar wrote:
> On 28 May 2014 00:59, Mark Brown <broonie@kernel.org> wrote:

> > Hrm, I'd have expected this to return -EINVAL when stubbed.  I'd also
> > have expected regulator_set_voltage() to return -EINVAL mind you.  I

> Or ENOSYS ? I will fix both routines once you confirm..

Whatever - I don't think the particular code makes any practical
difference.  We would need to audit existing users who don't have a
REGULATOR dependency for breakage though.

--B8ONY/mu/bqBak9m
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJThh8vAAoJELSic+t+oim92wkP/iqYmgfJcaXXHAZ22BsDbMSl
bKtbF1CzUAj6HmWrrI2NswInclZrIgZDis+MtBRqvifNH6fzyEZRI+VjmfQS5/e8
Emls6W7NKmcCWCZJ9jAM+ZLR6B5vrjIXOC0sRDSx9/zFULrcgj/aTKtfSVDuzx0Y
nhMPcpykn5E5uo23FfuUzSlzejypPllSePARMS3ZVbQhD70/BwPsefagYpmyQHFO
ITCrOToQFyaHzodweSPP/Do5grfXbrX1srPFQuGS1CXo5Z2ujVnl1dQzqUBF/9eh
14HxEKVO3JpBUsjYCTui4QuD9bf7bBCiDMaXo6lrwxFK8dd1JKlqlPmPUaZRstv5
Fn34rTvnq9A16hQ10KicU2lnJ0F/Fq6WD1Aqxukv+bgUJLOtv0XR4r3JEBBvzKpR
LmG8hFUiXinCBsQWQAqxjjCp5vYj1+0GxDIoHnKCkRZ/RbJpb1QMHVFRs1zXPpFd
o5Fe32AZ7DM+2c2iERlpJWF2W5JV/Th/TA5gwSmmmH0wRY+FIzL8W8coRihI7hHJ
Dns9tS4UrJKzG9RTZPLtP9QZQhvssrHR7inErhEEgCxmmsGtG7AFXC5Q1RJn0hVz
H3yVrY5htzgDdDSPbro6RTUknz7WpVVqTtCyrEzc4BvXzKKvDq4NqDH+FWErIqns
T8nD1zk4qwNpjfObZu9/
=BgLV
-----END PGP SIGNATURE-----

--B8ONY/mu/bqBak9m--
