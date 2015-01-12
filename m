Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354AbbALRHD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:07:03 -0500
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:53370 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750782AbbALRG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:06:59 -0500
Date: Mon, 12 Jan 2015 17:06:44 +0000
From: Mark Brown <broonie@kernel.org>
To: Rob Herring <robherring2@gmail.com>
Cc: Jacek Anaszewski <j.anaszewski@samsung.com>, linux-leds@vger.kernel.org,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Pavel Machek <pavel@ucw.cz>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, sakari.ailus@iki.fi,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Liam Girdwood <lgirdwood@gmail.com>
Message-ID: <20150112170644.GO4160@sirena.org.uk>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-4-git-send-email-j.anaszewski@samsung.com>
 <CAL_JsqJKEp6TWaRhJimg3AWBh+MCCr2Bk9+1o7orLLdp5E+n-g@mail.gmail.com>
 <54B38682.5080605@samsung.com>
 <CAL_Jsq+UaA41DvawdOMmOib=Fi0hC-nBdKV-+P4DFo+MoOy-bQ@mail.gmail.com>
 <54B3F1EF.4060506@samsung.com>
 <CAL_JsqKpJtUG0G6g1GOuSVpc31oe-dp3qdrKJUE0upG-xRDFhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="nLMor0SRtNCuLS/8"
Content-Disposition: inline
In-Reply-To: <CAL_JsqKpJtUG0G6g1GOuSVpc31oe-dp3qdrKJUE0upG-xRDFhA@mail.gmail.com>
X-Cookie: Keep out of reach of children.
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH/RFC v10 03/19] DT: leds: Add led-sources property
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nLMor0SRtNCuLS/8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 12, 2015 at 10:55:29AM -0600, Rob Herring wrote:
> On Mon, Jan 12, 2015 at 10:10 AM, Jacek Anaszewski

> > There are however devices that don't fall into this category, i.e. they
> > have many outputs, that can be connected to a single LED or to many LEDs
> > and the driver has to know what is the actual arrangement.

> We may need to extend the regulator binding slightly and allow for
> multiple phandles on a supply property, but wouldn't something like
> this work:

> led-supply = <&led-reg0>, <&led-reg1>, <&led-reg2>, <&led-reg3>;

> The shared source is already supported by the regulator binding.

What is the reasoning for this?  If a single supply is being supplied by
multiple regulators then in general those regulators will all know about
each other at a hardware level and so from a functional and software
point of view will effectively be one regulator.  If they don't/aren't
then they tend to interfere with each other.

--nLMor0SRtNCuLS/8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBCAAGBQJUs/8jAAoJECTWi3JdVIfQsVgH/0EvbSbMMCak7c7Dv9XJ9++9
C6ln4JD+REd0SaP5HBEZ/LURh2gNJ+GuwlT6VqPLfEQYVjLs5jzYQG3JAfj11954
PrNWrUuVrOhCpgkKRut0z4OBnJ+mO1AstTNz8WfcyYeuDgNXnWh79VOfYW87p/D7
m15nqwk0Qs+N05yhqEoHza9oNu8ZptaZm0njfEAyEp4o+3pVa2AQYkReSfvYTmID
4c5WIpBv7WZx1ztg/D7LxukKIuZ0TxesGGLg/zj4XN0Ln0IUc0vmmydnwvjs09mM
+ow6tIvsSKtojAbJNWUvxuvk/E52+mjGKG+UDKzFfBHPNqK4HJM0Q3H4YtR22wI=
=B3bS
-----END PGP SIGNATURE-----

--nLMor0SRtNCuLS/8--
