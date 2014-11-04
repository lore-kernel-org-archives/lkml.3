Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbaKDLmk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 06:42:40 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:37123 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752878AbaKDLmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 06:42:36 -0500
Date: Tue, 4 Nov 2014 11:41:20 +0000
From: Mark Brown <broonie@kernel.org>
To: Gyungoh Yoo <gyungoh@gmail.com>
Cc: sameo@linux.intel.com, lee.jones@linaro.org, jg1.han@samsung.com,
        cooloney@gmail.com, lgirdwood@gmail.com, jack.yoo@skyworksinc.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        grant.likely@linaro.org, robh+dt@kernel.org, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        pawel.moll@arm.com, heiko@sntech.de, jason@lakedaemon.net,
        shawn.guo@freescale.com, treding@nvidia.com, florian.vaussard@epfl.ch,
        trivial@kernel.org, linux@roeck-us.net, andrew@lunn.ch,
        jic23@kernel.org
Message-ID: <20141104114120.GJ3815@sirena.org.uk>
References: <1414393369-31583-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-1-git-send-email-jack.yoo@skyworksinc.com>
 <1414739322-12487-8-git-send-email-jack.yoo@skyworksinc.com>
 <20141031164418.GC18557@sirena.org.uk>
 <20141104004333.GA2965@jack-ThinkPad-T520>
 <20141104005329.GA3815@sirena.org.uk>
 <20141104054534.GA4108@jack-ThinkPad-T520>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="wv56KCa6/aA7yLgk"
Content-Disposition: inline
In-Reply-To: <20141104054534.GA4108@jack-ThinkPad-T520>
X-Cookie: Some optional equipment shown.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESUBMIT PATCH v6 7/8] regulator: sky81452: Add compatible
 string for device binding
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--wv56KCa6/aA7yLgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 04, 2014 at 02:45:34PM +0900, Gyungoh Yoo wrote:
> On Tue, Nov 04, 2014 at 12:53:29AM +0000, Mark Brown wrote:

> > I'm having a hard time understanding why it is difficult to split the
> > two changes - they are in completely separate files.

> I am sorry for the hard time.

> That was because the symbol changes had a dependency with 1/8.
> In this case, Should Kconfig symbol change back from MFD_SKY81452
> to SKY81452 in this patch series? And then should I submit to change to MFD_SKY81452
> with seperate patch?

No, what I'm saying is that if you want to rename the Kconfig symbol you
should do that as part of a separate patch to changing the DT stuff.

--wv56KCa6/aA7yLgk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUWLtfAAoJECTWi3JdVIfQSHUH/12eFd925csd7DlYQxfYh+Tf
7OdzGpaZ2MGdiDrRiGmzdPcaN6T3hD7WIzdDOKCMCQq8eqd+SHh7Vpvfj/WkXsNQ
czRZx4CrTuvzvuvxtRI0hK6HiJARLlvQSUmtMiPjOvKokRcZ2c70PiwkdCmRiOu+
9K6hDJu7M9sVh46kY5sTo2tS4EkpcI7aqrTTTuWlwtdeLj3GPb2v8SDPTnh00Lom
HrYDr/CIVaq79nIytTIVbimdVk9IeDvjh6roF0rfQuPBSrVyB638+wKV3zD7dHgq
6ZLIovTVl4fwmen/wAw8475AujuHmd2ZZCrfRj1KEVr1gu8287Vwt0GKKgfjhpY=
=ymkh
-----END PGP SIGNATURE-----

--wv56KCa6/aA7yLgk--
