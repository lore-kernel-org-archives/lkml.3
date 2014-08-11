Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141AbaHKQCo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 12:02:44 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:58407 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753706AbaHKQCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 12:02:42 -0400
Date: Mon, 11 Aug 2014 17:02:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kukjin Kim <kgene.kim@samsung.com>, Olof Johansson <olof@lixom.net>,
        Yuvaraj Kumar C D <yuvaraj.cd@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140811160222.GF17528@sirena.org.uk>
References: <1407757091-18730-1-git-send-email-javier.martinez@collabora.co.uk>
 <1407757091-18730-2-git-send-email-javier.martinez@collabora.co.uk>
 <CAD=FV=XRmNkxXoxWaEfxFADrTgBrOPVX746woxiZoKck1ajwgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OcnKVgjPbDryjMrG"
Content-Disposition: inline
In-Reply-To: <CAD=FV=XRmNkxXoxWaEfxFADrTgBrOPVX746woxiZoKck1ajwgA@mail.gmail.com>
X-Cookie: 98% lean.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [RESEND PATCH 2/2] ARM: dts: Add tps65090 FET constraints on
 Peach Pit and Pi
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OcnKVgjPbDryjMrG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Aug 11, 2014 at 08:57:24AM -0700, Doug Anderson wrote:
> On Mon, Aug 11, 2014 at 4:38 AM, Javier Martinez Canillas

> > After the switch is turned on, a safety timer is started
> > and before this timer times out the output voltage must
> > have reached the input voltage. Otherwise the switch is
> > turned off expecting an overload condition.

> > So using the maximum output voltage slew rate and the timer
> > minimum and maximum timeouts, a voltage constraints can be
> > expressed as bounded limits for the timeout. That is what
> > is used in the board schematics and should be in the DT too.

> I don't understand this, but if you and Mark are happy with it...

I have not looked at this change to my knowledge.

> ...I'm also not 100% certain what the above description has to do with
> this change, but I'll admit to having only skimmed some of the earlier
> conversations.

It's not at all clear to me either looking at the quoted section.

--OcnKVgjPbDryjMrG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT6OkLAAoJELSic+t+oim97YUQAICQvlFzyYVNH3zJTAQH2r0N
uPbM0fCwk+q9wp0ZaLHcN0GJra0CjVI90y/amrJ1fW4fNPkQYjs3V4gaqzqqUX3e
ZGM6+dH9MZQktzt2IJAYi57q+Xdao64V6KE/lK+YwsJpgHsyCH6s/IJ2gkKQt0J3
8VCqusD1Mzpi7bfJst9Z4vVco9RnhsHk5eRDI4NBon+zIVRUBVLeHg4PszVe0lls
W0SzAncDSNXNw5ztxGu8s0ueYrQ//Vj/YL0exLzonmMasjxFQjtpgvGPBydvsAly
5SPIq4NwXDwp2qWST8jPq4DmCbhPPYjduqFctqye80YCoPtfLCNIV3jOv4MgaQbQ
/wuAiV+H6RnQYwSMk2wzmBrVpYP9VEeXaX80Bh9nOYxt7EwY4zfm4JspBQWGk0dn
sfkdYVmUcB5z+IVDcHkDq7a9qzomf8SN3B/PD+hfDT6N7dsgLg094h07T10QABx1
Wli/9UAd7IfahDyWaolEZSgo18IMolPDzhT4EgpzeynskI/TmhXUIvlmGT/DpEwI
hOCORgV5c5+CmIAhYDvbPaauSM4ZxWx8QlUblh9uItlznqMzlqjYNMwFhIcw7M87
NFbeIFCBAC6x5uf21wZzY+jdOpVafYJmodn9WPIzGLGtwUU4C6UVzQHo+iYysWlu
XDHs2egIHupQL93lLKZr
=x5oc
-----END PGP SIGNATURE-----

--OcnKVgjPbDryjMrG--
