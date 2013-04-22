Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab3DVBDo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 21:03:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46884 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752882Ab3DVBDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 21:03:42 -0400
Message-ID: <1366592611.3408.131.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 3.8.y] drm/i915: add quirk to invert brightness on
 eMachines e725
From: Ben Hutchings <ben@decadent.org.uk>
To: Jani Nikula <jani.nikula@intel.com>
Cc: Josh Boyer <jwboyer@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 22 Apr 2013 02:03:31 +0100
In-Reply-To: <87obdmpvyo.fsf@intel.com>
References: <20130409123833.GC32476@hansolo.jdub.homelinux.org>
	 <87y5crpzct.fsf@intel.com>
	 <20130409142230.GD32476@hansolo.jdub.homelinux.org>
	 <1365561254.5814.44.camel@deadeye.wl.decadent.org.uk>
	 <87obdmpvyo.fsf@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-bsolB8DP6NTy6sD+FbKY"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:6834:ff73:7553:7f84
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-bsolB8DP6NTy6sD+FbKY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2013-04-10 at 12:37 +0300, Jani Nikula wrote:
> On Wed, 10 Apr 2013, Ben Hutchings <ben@decadent.org.uk> wrote:
> > I cherry-picked the following series for Debian:
> >
> > [pre-3.8]
> > 7bd90909bbf9 drm/i915: panel: invert brightness via parameter
> > 4dca20efb1a9 drm/i915: panel: invert brightness via quirk
> > 5a15ab5b93e4 drm/i915: panel: invert brightness acer aspire 5734z
> > 5f85f176c2f1 DRM/i915: Add QUIRK_INVERT_BRIGHTNESS for NCR machines.
> > [post-3.8]
> > 1ffff6032087 drm/i915: add quirk to invert brightness on eMachines G725
> > 01e3a8feb40e drm/i915: add quirk to invert brightness on eMachines e725
> > 5559ecadad5a drm/i915: add quirk to invert brightness on Packard Bell N=
CL20
> >
> > Should these all be applied to the various 3.x.y stable branches?
>=20
> Acked-by: Jani Nikula <jani.nikula@intel.com>

Queued up for 3.2, thanks.

Ben.

--=20
Ben Hutchings
Klipstein's 4th Law of Prototyping and Production:
                                    A fail-safe circuit will destroy others=
.

--=-bsolB8DP6NTy6sD+FbKY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUXSMY+e/yOyVhhEJAQqtTBAAjc2QFBvrjuFOoBFvajeIgq6V0tMaLTOz
oopqeR225SR0KKouSKMWtjb49V5pMoYBHOdVftXWvVPpUIGRHby93SHxtozqPkjM
MTPZNUfLkmbdlmYfL+R6QajlNcFM4f71Ds0Wc8qnY0mASqCjC3jgppQbpteo4TbH
+Do91cfoJTSOyYaTPxrjAfspWHMDKxoTLVg1c8N4fUqgiCoQhbkMhC1WGZxY/rm7
xvcaBkqzqvy3Msbx6nNFUCI0do06GmSGWF0L8YDa1YMPv2iB08kQOk+ZuMUPi2CN
SQV6glqV6070Y/8xKyVNSP3oPoDPXsV7XGZ7N4T39Hp0YNbc+i9iFF9kt3T6I5Bw
A1iLzh/nibG/GrBn97kxdwxBObR8KiRmcrmqNlYNKlAct0345RC5QOzO2UvxV0/8
zqGSNRupaV+HNLXmUkXrSBy8PUo8FxC63AvxBsWsckdaQ7Qe7MNbS8AMNJRBfjbe
Fs7OE2lWInUoCHHG1lSwBL/rwkj7B4unjxwEUsfc6OsqWteo+XCnOD5MJ4gezjTF
0yE1rGvIZO2B/gbSQkcaZ3qsdZGNHbghZrmYN1cPxua6/LZGnJHeFCyT4U4LdKKt
fOUpM7byuqD9Y6BIXnxMcvAXyOynKt7dnzVBit4TNkuDkIu31u6s3ayN3wLITSYo
k+u5UzsDLNQ=
=+z74
-----END PGP SIGNATURE-----

--=-bsolB8DP6NTy6sD+FbKY--
