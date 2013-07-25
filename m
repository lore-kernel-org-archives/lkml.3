Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755586Ab3GYMJo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 08:09:44 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:40996 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755226Ab3GYMJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 08:09:42 -0400
Date: Thu, 25 Jul 2013 13:09:04 +0100
From: Mark Brown <broonie@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Tomasz Figa <t.figa@samsung.com>, Greg KH <gregkh@linuxfoundation.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        Sascha Hauer <s.hauer@pengutronix.de>, kyungmin.park@samsung.com,
        balbi@ti.com, jg1.han@samsung.com, s.nawrocki@samsung.com,
        kgene.kim@samsung.com, grant.likely@linaro.org, tony@atomide.com,
        swarren@nvidia.com, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-media@vger.kernel.org,
        linux-fbdev@vger.kernel.org, akpm@linux-foundation.org,
        balajitk@ti.com, george.cherian@ti.com, nsekhar@ti.com, olof@lixom.net,
        Stephen Warren <swarren@wwwdotorg.org>, b.zolnierkie@samsung.com,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Message-ID: <20130725120904.GB9858@sirena.org.uk>
References: <Pine.LNX.4.44L0.1307231708020.1304-100000@iolanthe.rowland.org>
 <201307242032.03597.arnd@arndb.de>
 <2174304.5JlzJ583hP@avalon>
 <201307251300.49282.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wg2zgDM1gLxA7pbN"
Content-Disposition: inline
In-Reply-To: <201307251300.49282.arnd@arndb.de>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 01/15] drivers: phy: add generic PHY framework
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wg2zgDM1gLxA7pbN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 25, 2013 at 01:00:49PM +0200, Arnd Bergmann wrote:

> I'm not saying that we can't support legacy board files with the common
> PHY framework, but I'd expect things to be much easier if we focus on those
> platforms that are actively being worked on for now, to bring an end to the
> pointless API discussion.

Well, it seemed like Greg's concerns had already been addressed anyway.

--wg2zgDM1gLxA7pbN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJR8RVcAAoJELSic+t+oim9YuEP/1JH37qhhixNi8JrjQfegt/8
CHa1paebHzFPGbKxxpSBJPna5OSGkSgiS+E2U+s4aP9kqkYzD3cX04ptz6v3DTTN
5lvt1LsAVFmneFJfB4jdCjazUPEnm2kRgk6xKoBVpdswJctx9xc5pVR2OmI8BwdW
l+7AQhCq347aGKSP4Ep/7YOUg6tD0/6zvzCmet360ai6lPAT/yhZj0dYD7Qii7Gk
uKM3cQb1PwrJk/xBcR70vEB6XMLzkzhm0yRtVk1DBziNcXdnS+N4ZyCA8Vre82ev
t/02/Bi1CCGwifKCDa/1RWb6zjYPyyixX5gBx+zxDChtiCcxwg5vJFfT+7uwiLFk
jstL8OGkt7lk2jGAOcCrszLisnPqJ2siXnGJaI/4AvVXYcd7Q+9nOggg4C8Re5E/
efnkS850CgWTgyrpun2ZyCuhoQhkbqNNB8CHw6volpjAS0i5Q0wat0FmPdBQZg9r
Fo5iLQ0i0OxKdmVO/Z5EwOeUoWjMh9lzT9q6q1zWoS233igUr5Xf9qS1svmmz1jX
TcRTGERIM12JlHUr8efalQZMOHhKT/NGWPskqV7g35n4/mVPu0DrsyzQl1DrJ470
DUMlwn+AgaU3X6ttEeTbcBJLNvrkLNI/5OvwUljDN39X2wzp888H3HD8/JpqugKI
ldM0KNy4SyQ+fIArDPob
=fqdw
-----END PGP SIGNATURE-----

--wg2zgDM1gLxA7pbN--
