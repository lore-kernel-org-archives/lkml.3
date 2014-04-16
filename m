Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756836AbaDPVzR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 17:55:17 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:35469 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756780AbaDPVzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 17:55:12 -0400
Date: Wed, 16 Apr 2014 22:54:50 +0100
From: Mark Brown <broonie@kernel.org>
To: Doug Anderson <dianders@chromium.org>
Cc: Anton Vorontsov <anton@enomsg.org>, Olof Johansson <olof@lixom.net>,
        Sachin Kamat <sachin.kamat@linaro.org>,
        AJAY KUMAR RAMAKRISHNA SHYMALAMMA <ajaykumar.rs@samsung.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Simon Glass <sjg@chromium.org>, Michael Spang <spang@chromium.org>,
        Sean Paul <seanpaul@chromium.org>, Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20140416215450.GF12304@sirena.org.uk>
References: <1397592876-5741-1-git-send-email-dianders@chromium.org>
 <1397672724-9063-1-git-send-email-dianders@chromium.org>
 <1397672724-9063-6-git-send-email-dianders@chromium.org>
 <20140416205136.GZ12304@sirena.org.uk>
 <CAD=FV=Wf=hdggX-Z1gtiVJdwr7jwjY1owCVZDq_BrWOyj-3m3A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="MAI/ZU7774XuDDY6"
Content-Disposition: inline
In-Reply-To: <CAD=FV=Wf=hdggX-Z1gtiVJdwr7jwjY1owCVZDq_BrWOyj-3m3A@mail.gmail.com>
X-Cookie: You will be successful in your work.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v2 5/5] regulator: tps65090: Make FETs more reliable by
 adding retries
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--MAI/ZU7774XuDDY6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 16, 2014 at 02:34:47PM -0700, Doug Anderson wrote:
> On Wed, Apr 16, 2014 at 1:51 PM, Mark Brown <broonie@kernel.org> wrote:

> > Please don't send new patches as replies in the middle of threads, it
> > makes it confusing trying to work out which versions of things should be
> > applied.

> I'm a little confused about what I did wrong.  Can you give more details?

I'm seeing a reply which looks like it was sent as a followup to Randy's
comment, although now I look at everything together I think that's due
to you sending your new thread in reply to the old thread (that can also
be a problem due to threading either burying the new mail or putting
things in odd places) and my mailer trying to tie the one mail from your
first series that I'd not deleted into the thread.

--MAI/ZU7774XuDDY6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTTvwmAAoJELSic+t+oim9+agP/Rf4h6nG3RtYbK/F6MIcGy2m
GlEWAYfInW33fe/ugtOgO+jF2ZgafnR3Fj8IvDOg1SSGB1XwFhQdpwzT69x5SNCk
LdDnj7VbNgqiWcQ+CycC6nqnJgsAeqOjOvULB7yuzDxpFNFZOAhJ0aagrUzBm7Fr
VmJtNIpfkdu3q9iLO4N/m4CkjNdvecOOWyCq2Z0XuQCL4CPBiKe1BTLkZ4Bdy3PR
/HUVoUSmBUNUQNxcpGNaDjPFEeL23EP9txlF7O5q5PLF/cZ8GQl5/oxkfSvetynC
bRPsIs7gKQqQvxYNs8HCrb2T6ldOF0nfwO8fbQF3bUHoI1XNNKFrsKfL1+OaaBLU
0jb2cbiF/sVF6a4rDEF74fn4o1ShpYAKGgaFpnIs+ceeeSymtGuw3tjn+2RWltpE
09UHRPmMVHl4YgT+gtV+vVTbb1ACor+9qOetypFVTAK6sJXNYMzW/O2OltiaNq7C
viIyJLkYirc94XB0S2oXRkIRMiC3HfFv2z8ebRDZOHPxBfXuUCfgOGLxGhCWMidH
nojdPDdcGNr4A4XNw7E3ctCt8BFiIBY4GgF+BHRaqVDLFE8ZqXBZ/WwzWld+P49L
JTSNYmGnOJsPMZgtRUC80ct4I0bBo3T7gX9+WE8Vi0qqEnjUBUW7sns9kriOJrLh
O2Icj/1Xic+b5JqViZYz
=cXj3
-----END PGP SIGNATURE-----

--MAI/ZU7774XuDDY6--
