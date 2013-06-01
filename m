Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab3FAVLV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 17:11:21 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59804 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752099Ab3FAVLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 17:11:19 -0400
Date: Sat, 1 Jun 2013 22:10:45 +0100
From: Mark Brown <broonie@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Lars-Peter Clausen <lars@metafoo.de>, Mike Frysinger <vapier@gentoo.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <20130601211045.GV16790@sirena.org.uk>
References: <1369993250-6461-1-git-send-email-geert@linux-m68k.org>
 <51A88C3F.5080109@metafoo.de>
 <20130601190328.GL16790@sirena.org.uk>
 <CAMuHMdX09zeshD4_TbU4MN1LjooeJKDUaAxsZ4CjNF1+Yp+STQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YwTTlJgQ7QoYB9ta"
Content-Disposition: inline
In-Reply-To: <CAMuHMdX09zeshD4_TbU4MN1LjooeJKDUaAxsZ4CjNF1+Yp+STQ@mail.gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 82.42.102.178
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH -next] blackfin: bf533-stamp: Remove bogus "||"
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YwTTlJgQ7QoYB9ta
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jun 01, 2013 at 10:48:05PM +0200, Geert Uytterhoeven wrote:
> On Sat, Jun 1, 2013 at 9:03 PM, Mark Brown <broonie@kernel.org> wrote:

> > Only if someone were to send me the patch.  Geert, you should *ALWAYS*
> > CC maintainers.

> Sorry, I sent it to your Wolfson address, as suggested by get_maintainter.pl:

> Mark Brown <broonie@opensource.wolfsonmicro.com> (commit_signer:3/4=75%)

You're not using a current version of the tree you're submitting
against (which you should always do)...

> You don't receive email there anymore? BTW, the Wolfson address is still listed
> in 2 sections of MAINTAINERS.

No, I don't.  -next hasn't been rebuilt since the update to remove those
occurrences but note that they're for Wolfson drivers and the subsystems
have all been using my current address since mid-April and those updates
have propagated into Linus' tree already.

> I've forwarded the original email to your kernel.org address.

Please submit the patch normally so that it can be applied by tools
without hand editing.

--YwTTlJgQ7QoYB9ta
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRqmNRAAoJELSic+t+oim9Lf0QAJLktFAOZPPimE7Fq2Od2JM1
NBtU0h6mUWKcRopPyzGNA06FRXwyJAgK9B6wtStRe9udJ6Jg9U+gUmErBgbuxg3u
bDi2bTYqDeL/S2en1Foxwc5zWPP1/gNd4p9Wv8UPPBIeW2Kq5lkNLz8YLdT65yTX
JXT43Uga88/R9GFLlWSO3hspZkMl3gcCK04fFulM6dbI5OrEMEmlxPzITYs4Vozr
yN5/OKpmcJA4SUhHai/r3C+tjnOVRAp820cdETygL/7q+aX8oQRX1Yy8eNdrcsLq
3ObfeJJtg7qL+gVg72gg39983CXF27KFOZWpK9GDg5jaRZ/Pg7XXMordEEAG1r/V
9FRoo98dKGBTuL9Rd1mcecjV7mTVmvfriD0rthDJXcrD3xeDcvT8C4Jh4eAn8uS2
Z6zolADFmg7XzVF/iA2Ytq0dsncjpBt+z95LFKvN3MvV6stTijPmRTLAjkQI7IO/
dTxnjQeGmSk9ZEBsC7j9wddYqll/8U9nkmBynFEkxUGnUn4UwoMKixws2Gxt8fKR
BjS9qLRclaWwV9xr5OaJsaJgT9Lu4D7FSJl/0e9nJMKgT+q2pxPgTQ/OjL/MNnm3
wHK3FoCxXVz3YGekaowvUZCkb6bgpjUucU3pNTTrcQeTkHtvAuMGGeBNKGZ4nqqR
aBRHv+pWXyYVMGSFC+DY
=qdfe
-----END PGP SIGNATURE-----

--YwTTlJgQ7QoYB9ta--
