Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751540AbaK1Sfe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 13:35:34 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:42397 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaK1Sfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 13:35:32 -0500
Date: Fri, 28 Nov 2014 18:35:07 +0000
From: Mark Brown <broonie@kernel.org>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Johan Havold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Message-ID: <20141128183507.GZ7712@sirena.org.uk>
References: <1416312599-5176-2-git-send-email-laurentiu.palcu@intel.com>
 <1417180198-9393-1-git-send-email-laurentiu.palcu@intel.com>
 <20141128141053.GL7712@sirena.org.uk>
 <20141128145703.GA16201@lpalcu-linux>
 <20141128151435.GQ7712@sirena.org.uk>
 <20141128153125.GB16201@lpalcu-linux>
 <20141128160156.GX7712@sirena.org.uk>
 <20141128181326.GA23784@lpalcu-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LrkNhSf9vGvdvMkt"
Content-Disposition: inline
In-Reply-To: <20141128181326.GA23784@lpalcu-laptop>
X-Cookie: Celebrity voices impersonated.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH v7 1/2] spi: add support for DLN-2 USB-SPI adapter
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LrkNhSf9vGvdvMkt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 28, 2014 at 08:13:26PM +0200, Laurentiu Palcu wrote:
> On Fri, Nov 28, 2014 at 04:01:56PM +0000, Mark Brown wrote:

> > No, please don't - you're missing the point.  The point is that now Lee
> > has applied the other patch you're not sending two patches any more,
> > you're sending a single patch.  This isn't patch 1/2, it's just a single
> > patch by itself now.

> All I did was send new revisions of the 1/2 patch using the
> --in-reply-to option of git-send-email, with the message-id of the
> original version. I used to do this for other projects I contributed to,
> so I didn't have to re-send the entire series for just one patch that

The whole point is that you're not sending a series, you're just sending
one patch.

> needs to be changed. Mail clients, at least the ones I use (mutt,
> evolution), order the mails nicely and you have all the history in one
> thread. So, one can see the cover letter of the series and the other
> original patches in the series, together with the new revisions of the
> changed patch. Of course, if more patches needed change, I would re-send a new
> series.

Definitely do *not* do this, it makes the thread very hard to follow if
there are multiple versions - you end up with multiple versions of
various patches scattered through the thread and it can be very unclear
which versions are current.  If there's a lot of traffic things get
hidden way back when the original submission happened.

Fortunately I've deleted old parts of the thread so I didn't notice you
were doing this.

> So, Mark, can you please instruct me (a link to a page explaining the
> workflow would be fine too) what is the exact workflow you are/were
> expecting?

The patch submission workflow is covered in SubmittingPatches.

--LrkNhSf9vGvdvMkt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUeMBaAAoJECTWi3JdVIfQCi4H/RFkaB+XX76p9HjJFf1I3lDW
SJHawoFqCxGIxTxJgVTPXGtdH7idGxdSYEEePB0xzvph6uQ4ZeSn1YpT/6ZO/UxI
CtxUaXEtbSbdBDGp+GQjdVbm0F8Csn0PyhCp+MHqEca/ADfKR0Y1EHk9/vcqPRbZ
1aknwVq/WSXjYEcX60DcYkKYhgPACi7g4C+9n3TAChF4OfBOIk7yLlfY/X4RpTNt
+JuGUk3Qtn9n4eCSIRHrCAveuCjbW0HIyCZTfQ9uO0tr2JexpCdlD4boGs0H3gUN
5uTSLs1TNzRX0f6x3UH2J2VQAOhyTjqNVKgnk91hgBoAav6FpSGsiS1uB0J8rlA=
=rWuY
-----END PGP SIGNATURE-----

--LrkNhSf9vGvdvMkt--
