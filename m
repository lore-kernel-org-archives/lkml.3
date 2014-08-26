Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934674AbaHZKZL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 06:25:11 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:48595 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934405AbaHZKZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 06:25:08 -0400
Date: Tue, 26 Aug 2014 12:25:04 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexander Holler <holler@ahsoftware.de>
Cc: Grant Likely <grant.likely@linaro.org>, Jon Loeliger <jdl@jdl.com>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC PATCH 0/9] dt: dependencies (for deterministic driver
 initialization order based on the DT)
Message-ID: <20140826102503.GC31124@ulmo>
References: <20140514141914.446F7C4153D@trevor.secretlab.ca>
 <20140821140211.GD19293@ulmo.nvidia.com>
 <53F64624.5000403@ahsoftware.de>
 <20140822131919.GX21734@leverpostej>
 <20140825093931.GB2399@ulmo>
 <E1XLu15-0002DP-6o@jdl.com>
 <20140825133714.GH4163@ulmo.nvidia.com>
 <20140826084208.AE5F0C40989@trevor.secretlab.ca>
 <20140826084922.GG17263@ulmo>
 <53FC566C.30904@ahsoftware.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/Uq4LBwYP4y1W6pO"
Content-Disposition: inline
In-Reply-To: <53FC566C.30904@ahsoftware.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/Uq4LBwYP4y1W6pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 26, 2014 at 11:42:04AM +0200, Alexander Holler wrote:
> Am 26.08.2014 10:49, schrieb Thierry Reding:
> >On Tue, Aug 26, 2014 at 09:42:08AM +0100, Grant Likely wrote:
> >>On Mon, 25 Aug 2014 15:37:16 +0200, Thierry Reding <thierry.reding@gmai=
l.com> wrote:
> >[...]
> >>>There are somewhat standardized bindings for the above and especially
> >>>for bindings of the type that clocks implement this is trivial. We can
> >>>simply iterate over each (phandle, specifier) tuple and check that the
> >>>corresponding clock provider can be resolved (which typically means th=
at
> >>>it's been registered with the common clock framework).
> >>>
> >>>For regulators (and regulator-like bindings) the problem is somewhat
> >>>more difficult because they property names are not standardized. One w=
ay
> >>>to solve this would be to look for property names with a -supply suffi=
x,
> >>>but that could obviously lead to false positives. One alternative that=
 I
> >>>think could eliminate this would be to explicitly list dependencies in
> >>>drivers. This would allow core code to step through such a list and
> >>>resolve the (phandle, specifier) tuples.
> >>
> >>False positives and negatives may not actually be a problem. It is
> >>suboptimal, certainly, but it shouldn't outright break the kernel.
> >
> >There could be cases where some random integer in a cell could be
> >interpreted as a phandle and resolve to a struct device_node. I suppose
> >it might be unlikely, but not impossible, that the device_node could
> >even match a device in the correct subsystem and you'd get a wrong
> >dependency. Granted, a wrong dependency may not be catastrophic in that
> >it won't lead to a crash, but it could lead to various kinds of
> >weirdness and hard to diagnose problems.
>=20
> You need either the type information in the DTB (that's why I've add those
> "dependencies" to identify phandles), or you need to know every binding (=
at
> "dependency-resolve-time" to identify phandles. The latter is impracticab=
le
> to implement in a generic way (for use with every possible binding).

Like I already mentioned, this could be done in drivers who contain that
information already anyway. Or parts of it could be done in subsystem-
specific callbacks where a generic binding is available.

Thierry

--/Uq4LBwYP4y1W6pO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJT/GB/AAoJEN0jrNd/PrOh2dsQALwMq3kZmioClgdynhWx+jKL
IE2uMQAHBuEwaNMjD/j8LXMVwFqf/mmjw22c7xxmh5GoE19uCb0X6HdUrS6VU+H5
kyulYh4DdoxNqnRiUU9LHH3fxzyht1PrDxtjlwwKaYMoDLtfryhRRuPfSC+KG9U8
GwPTeOLdqjEehrfIC81eBaEnyrPFAceO/y3NfEGWOy3cLnrlIlwiV8koiN6IfcHb
sFgQDTry6QA1bh/HplNheoZte9Ir7Ct6CXojs+NDh/+RtTwYK6WV8GHj4pp6tkCE
GQJgbtUTL/Ns43ySSl17Lh+xw7uDoH4Z9uL9vfZbOMDNBLaejSdLRhJiNKEs94ak
HDcYJ0NI3rB0FHrmAsgL5jRckecltJei6OKqU13XtUaa4NkEWYOGrgLs9DNBWxlo
FDzL6ekK27HAYU0W036Z6inThYMsPp1C2na1+I7BnZB5Whjnrg7jI9iV0A7krR4Y
CzxGfczPfxeAvMpSLm+7pb0rnfWRzflpsewzxlUJ2cHKBl0BPe5mGRe6AM8tW16I
P4Ou0TZqCFzW/vtFsbdkefVbBczqpT0SBDRQnnmGDJXLqziMOkWYOYFTtEp933tk
gRxRuj2lu5M0qP0/YhdR/0ZSVoIxLD3QZR99mrgJEDWyQdSBlM5LfTNsNrG1bxHB
iAe7vw3ePqDMpLKwwpJV
=DCf3
-----END PGP SIGNATURE-----

--/Uq4LBwYP4y1W6pO--
