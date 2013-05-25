Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755232Ab3EZUiO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 16:38:14 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:54943 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111Ab3EZUiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 16:38:12 -0400
Date: Sat, 25 May 2013 15:56:01 -0400
From: Mark Brown <broonie@kernel.org>
To: yi zhang <yizhang.mrvl@gmail.com>
Cc: lgirdwood@gmail.com, cxie4@marvell.com, jett.zhou@marvell.com,
        linux-kernel@vger.kernel.org, Yi Zhang <yizhang@marvell.com>
Message-ID: <20130525195601.GJ7660@sirena.org.uk>
References: <1369224653-27150-1-git-send-email-yizhang.mrvl@gmail.com>
 <20130522161422.GP1627@sirena.org.uk>
 <CAK=oMXepj7tmZJ3=b9ja+E1N9eAPmsPhBefAzoswVyGWBXwNOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5cSRzy0VGBWAML+b"
Content-Disposition: inline
In-Reply-To: <CAK=oMXepj7tmZJ3=b9ja+E1N9eAPmsPhBefAzoswVyGWBXwNOA@mail.gmail.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] regulator: 88pm800: add regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5cSRzy0VGBWAML+b
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, May 24, 2013 at 11:01:45AM +0800, yi zhang wrote:
> 2013/5/23 Mark Brown <broonie@kernel.org>:
> > On Wed, May 22, 2013 at 08:10:53PM +0800, yizhang.mrvl@gmail.com wrote:

> >> +static const unsigned int BUCK1_table[] = {
> >> +     /* 0x00-0x4F: from 0.6 to 1.5875V with step 0.0125V */
> >> +     /* 0x50-0x7F: from 1.6 to 1.8V with step 0.05V */

> > Write this out as code, don't use a big table for large sets of
> > voltages.

>      The voltage table is "const", if we write it out as code, seems
> it's hard for us
>      to keep this attribute;
>      And the voltage of this BUCK is not linear(it's separated as two parts),
>      seems I shouldn't use the framework helpers to implement it; Right?
>       what do you think?

You should open code the mapping functions but you should still do this
as calcuations, it's faster and produces smaller code.  You'll need a
small function with an if statement.

--5cSRzy0VGBWAML+b
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRoRdJAAoJELSic+t+oim9jb8P/2w+P8e3lxyHC7KEHc5M6xxW
Arw4qRx5VCEms1+kHwfMf+7H/cMUUUzvtU8WWZPFV7YO4bx9mLKdYQ3/wXhiqWyY
6PhZCHUD0O9fzxWAW5jbSrfwmga7XbBdKEc78dGhsvaWV/eOig7KF7AnT6ucoblj
5z85PFEmYSCvBaYtquEkgarWqQKZCIaRJ2r1yVuDOOhepgHiyXHrSY2jHi7Ve24Y
5gu9EYLFFLv6arAfTWJ00pKafK/L+nB390yIJF/mkaGv83euT25WdwruGMh0Oltb
Jni6SYdog/mIEMTXlx5wTxWKRwXYQQ3CuKeRDpTBoQQZyeo/il04s4cCC3rNSTqb
s8z23Rhp5YIySWzVIhz7qMj8IqJxWazye7GeOluTbRPgbwi0bNUKYX2/SdnS5BXL
ymWHA6lj1Uf1dNSojcHtc8FXyCQRDPTKZJUdx3NCVIjSR77XcYijO+dEK+cCozcF
TRfeJSV6Eo9gBlLK/uuDkYjV7hShajtuZF5ZyvjiaTeOXMo9M+/co+emRikBI+QK
QjbnczkVPy+ZWaMGhaJSXFrQtB6TkQ11A8TMHQvooK/R47ss4u03/hAnsOWn4Tj8
21TJ/+EK4aSXnwc6/aP/ojCWcINLoCF8BJgr5jVl0mL9ZFoCPRGaSG7Y50CZch7n
6pB7aaqvMxrqoyBu0tPS
=Dfiu
-----END PGP SIGNATURE-----

--5cSRzy0VGBWAML+b--
