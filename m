Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220AbaLCM4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:56:12 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47066 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaLCM4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:56:09 -0500
Date: Wed, 3 Dec 2014 12:55:45 +0000
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Jianqun <xjq@rock-chips.com>, Jianqun Xu <jay.xu@rock-chips.com>,
        Liam Girdwood <lgirdwood@gmail.com>, perex@perex.cz, tiwai@suse.de,
        Sonny Rao <sonnyrao@chromium.org>,
        Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>
Message-ID: <20141203125545.GX7712@sirena.org.uk>
References: <1417531766-29669-1-git-send-email-jay.xu@rock-chips.com>
 <1417531977-30094-1-git-send-email-jay.xu@rock-chips.com>
 <CAD=FV=Uwb1NxxCoXHzHu6DJCpnG_HV2RhCr3JaJaXbJja8kd7A@mail.gmail.com>
 <547E616C.1020503@rock-chips.com>
 <CAD=FV=VtYU5Pdz-xvjSdsReyCqMQaMtw=ZXmH4PO5wFnGVPY1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mf98Qhtkz7GkgeUI"
Content-Disposition: inline
In-Reply-To: <CAD=FV=VtYU5Pdz-xvjSdsReyCqMQaMtw=ZXmH4PO5wFnGVPY1g@mail.gmail.com>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] ASoC: rockchip: i2s: add support for grabbing output
 clock to codec
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mf98Qhtkz7GkgeUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Dec 02, 2014 at 09:18:35PM -0800, Doug Anderson wrote:

> You still seem to be missing versions in your subject line and missing
> info on what changed version to version.  The latest version you just
> sent (v4?) is still missing it.

> Unless Mark says so then I don't think you need to spin this series,
> but please try to add that in the future.

Don't resubmit.  I actually don't care much about any of that stuff and
mostly ignore it unless the change set is saying something other than
"addressed review comments".

One thing you should avoid doing is posting new versions in reply to old
versions as has been done here, that just makes for a confusing and hard
to follow mail archive with new serieses buried in the middle of threads.

--mf98Qhtkz7GkgeUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUfwhQAAoJECTWi3JdVIfQHX4H/Ri3i8YpmGXBLMTj3CW+IZT0
s79nEozAHKSqFxaG1I9E9Lbopp6rfg6FF4WRllxm5TdEEgHyf2JvKCvsZgziKqy9
QxoGvNrREh+3rqnZX2ghTIg3SCA2NwvNR3UtfRl+DjNilM/NgdpOKrThxm5v4h/q
i90AUNzGSAai3oo4v+ydw6qw5ipDQB61UkIGafIhKQun+kGwJfpkYD93Z0E26FBZ
VM3QSFXcucEQu/ZfBVJHttXCTCDKbBuEC27P5cm/k55v0dAa4uHL05MuvdmMYRxm
yyo5SPL29MrrKCPlZjOUpX6zCCvdy9XKUpNLJKZ4sDwGR88mFapxuxQikZN9Z9Q=
=WM2z
-----END PGP SIGNATURE-----

--mf98Qhtkz7GkgeUI--
