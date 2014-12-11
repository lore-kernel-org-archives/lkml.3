Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146AbaLKRKJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 12:10:09 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:55823 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751235AbaLKRKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 12:10:07 -0500
Date: Thu, 11 Dec 2014 17:09:34 +0000
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Alexandru Stan <amstan@chromium.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Jaehoon Chung <jh80.chung@samsung.com>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        Andrew Bresticker <abrestic@chromium.org>,
        "open list:ARM/Rockchip SoC..." <linux-rockchip@lists.infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20141211170934.GZ11764@sirena.org.uk>
References: <1418245085-9754-1-git-send-email-dianders@chromium.org>
 <20141210235347.GT11764@sirena.org.uk>
 <CAHNYxRy2t0OVj-+CqQFOfj0zWAGG0j8rmd8SxdNWgBMA2iAfXQ@mail.gmail.com>
 <20141211123106.GU11764@sirena.org.uk>
 <CAD=FV=U4RFYx9NXOACrXJZK2bKkosyYnmTZRHkXuaSz-FS9kNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+cTHE2B7cPyeMCYH"
Content-Disposition: inline
In-Reply-To: <CAD=FV=U4RFYx9NXOACrXJZK2bKkosyYnmTZRHkXuaSz-FS9kNQ@mail.gmail.com>
X-Cookie: I don't get no respect.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 1/4] regulator: core: Support trying to get close to a
 certain voltage
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+cTHE2B7cPyeMCYH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Dec 11, 2014 at 08:09:13AM -0800, Doug Anderson wrote:
> On Thu, Dec 11, 2014 at 4:31 AM, Mark Brown <broonie@kernel.org> wrote:

> > This is just an implementation detail, everything you're saying here
> > applies equally to any user specifying by tolerance rather than range.
> > If the reason for doing this is to fix that problem then a new API isn't
> > the way to go about it.

> OK, I'll give a shot at taking my code and using it as a new
> implementation for regulator_set_voltage_tol().  In the SD card code
> I'll pick some reasonable tolerances--they won't be exactly what the
> spec says, but they ought to be good enough.  If Ulf comes back and
> yells at me then we can revisit adding a new API.

OK, thanks.  Even if a new interface does get added the implementation
needs to be shared with that for setting by tolerance, they're doing the
same thing.

Please also bear in mind the need to handle shared supplies in your
implementation.

--+cTHE2B7cPyeMCYH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUic/NAAoJECTWi3JdVIfQ/4YH/RoB/UBFDwC7OkriO3T6EgNY
6pfP8dZh9taaUaz+DChUqrvtfrCoi40hpVDv0lyqGYj/SLDEIbn8m5gGAC92bqFC
K9QTDAreZT/DuazylMJVnXiRXsPfP9mwPC1lC+F7SEWhpGHP39EwQUDgFf+fc8iS
AcwuJLWEeC548v6VFUAg+nqleVoR2OumcZxgVvA84vBDfQBuahuaszzdQfmAFY7F
2fMAOFBsEc1m/Csvt3Gg17fZ3gJ55tkaCthK3YiishRl7RhfIlUfT/Ri2dLARjxP
1KszxIkqvq4xt+ydsNTEUiCj0B9G9DTcoyVf/LKagr1I4ObfhwchkGVBzmdWyKE=
=6dLC
-----END PGP SIGNATURE-----

--+cTHE2B7cPyeMCYH--
