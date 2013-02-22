Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3BVKiu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 05:38:50 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53743 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750834Ab3BVKis (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 05:38:48 -0500
Date: Fri, 22 Feb 2013 10:38:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, sameo@linux.intel.com, arnd@arndb.de,
        linus.walleij@stericsson.com,
        Daniel WILLERUD <daniel.willerud@stericsson.com>
Subject: Re: [PATCH 01/35] mfd: ab8500-gpadc: Implemented suspend/resume
Message-ID: <20130222103306.GA19796@opensource.wolfsonmicro.com>
References: <1360933026-30325-1-git-send-email-lee.jones@linaro.org>
 <1360933026-30325-2-git-send-email-lee.jones@linaro.org>
 <20130220131912.GB13049@sirena.org.uk>
 <CAPDyKFo0MpP-d7v8v1zwB42sboR3MWT6nUmG=-L0_nayYRY7FQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Content-Disposition: inline
In-Reply-To: <CAPDyKFo0MpP-d7v8v1zwB42sboR3MWT6nUmG=-L0_nayYRY7FQ@mail.gmail.com>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 21, 2013 at 11:45:08PM +0100, Ulf Hansson wrote:
> On 20 February 2013 14:19, Mark Brown

> > This doesn't look especially sane...  You're doing a runtime get, taking
> > the lock without releasing it and disabling the regulator.  This is
> > *very* odd, both the changelog and the code need to explain what's going
> > on and why it's safe in a lot more detail here.

> You need to do pm_runtime_get_sync to be able to make sure resources
> (which seems to be only the regulator) are safe to switch off. To my
> understanding this is a generic way to use for being able to switch
> off resources at a device suspend when runtime pm is used in
> conjunction.

Are you sure this actually does what you think it does, especially when
run on modern kernels?

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRJ0lbAAoJELSic+t+oim9cWsP/1fu+3OgTpGzxdh2rKorgx81
a3Fi+Z/N8t+8oToF5HKOiYokErxO51QAZwqSvss0Oc4QLnhidPRfgqz/PwUw5oCI
f+LuouoLSSNBuztjfdKAWGmvqtevHzPUaFYEp0szcZmZZZWOT62Vu4KUFgaBcgU/
dYx0YW7jgrLxuOEZ8+/jfsZiC8esq7XkvR6e2E0JIbTXqoN7eID69IySmeX2XkjY
FhjlsO1UXyp1Ry2MMGPQSIP1eJpXTdBu4lCpIMweN+9jTzUVahwCv7azTVrAuxBx
CgcB4ZPvfwSRScYq+9PusnfTPD7IDJ6tb48H11yTg3NRRnhZJ7StMOLZNF35bZgw
ckXmu9Kee826dK74uwRzW9klhU7DDRdCLANxaiQECP6BG2mZ8bFewrlGI36+BXPv
pG+vSl5mKwlVHhjLLWMjaSWE5G63meFHbvZr1/WlL56p4TCJvvfolCS4MYP+fYZ4
H1h45rJihJXwJnt5Oikl8KOch8W34oDm/n7a20lS1DWeAD/jja87A+vxmow7cZd0
rwvkZG3P9qYTwB8dhJnd+YQHhdxSEXspjdbDzwB+G5MJtmx4XzWrX73L3Wg8Ngxt
tBPJPaePhqtedzqbeYaeqCbPf2U3uo1I4mzVk1cXCSzsqBphppHlyH9dKEyYJ3P7
spajOZKBttCyx1VWgztO
=OQOy
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
