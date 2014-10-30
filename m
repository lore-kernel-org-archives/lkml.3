Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759369AbaJ3MFU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 08:05:20 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:57108 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758889AbaJ3MFS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 08:05:18 -0400
Date: Thu, 30 Oct 2014 12:04:40 +0000
From: Mark Brown <broonie@kernel.org>
To: Mike Looijmans <mike.looijmans@topic.nl>
Cc: lgirdwood@gmail.com, linux-kernel@vger.kernel.org
Message-ID: <20141030120440.GW18557@sirena.org.uk>
References: <1414570560-10320-1-git-send-email-mike.looijmans@topic.nl>
 <1414570560-10320-2-git-send-email-mike.looijmans@topic.nl>
 <20141029123005.GH18557@sirena.org.uk>
 <5451DF10.7030605@topic.nl>
 <20141030101555.GT18557@sirena.org.uk>
 <5452131F.9000307@topic.nl>
 <545218B1.8030306@topic.nl>
 <20141030105848.GU18557@sirena.org.uk>
 <5452219E.2070802@topic.nl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d5GF466EZ0c6qBMm"
Content-Disposition: inline
In-Reply-To: <5452219E.2070802@topic.nl>
X-Cookie: FORCE YOURSELF TO RELAX!
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] Add ltc3562 voltage regulator driver
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d5GF466EZ0c6qBMm
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 30, 2014 at 12:31:42PM +0100, Mike Looijmans wrote:
> =EF=BB=BFOn 10/30/2014 11:58 AM, Mark Brown wrote:

> >>Hmm, I looked into doing that, but that isn't trivial, and too many dev=
ices
> >>will suffer.

> >Why would this have a negative effect on other devices?  Unless somehow
> >the other devices add the property they should not be affected by it; if
> >users do add the property presumably that's because it's doing something
> >useful.

> The "default" would end up in the constraints, thus adding extra fields to
> that struct.

Sure, but why is that a problem?

> So far, all other drivers have accomplished this by setting min=3Dmax, and
> some experimenting proved that my driver is no exception to that. It even
> reduced the amount of code.

Yes, if you don't need to both set an initial voltage and support
voltage changing that works - it sounded like you needed both.

--d5GF466EZ0c6qBMm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQEcBAEBAgAGBQJUUilXAAoJECTWi3JdVIfQOoIH/3jP6mwYMMwem/mPky3CIr7s
Nzh60DLRGCdLvODD3zIEE9MsbeTTY5ImRi37lNXh5oR1QbgE8D1ZBOP+9KaFHiAA
CKMwRVsIlZz9+lm3IXRfLgnHJbD+LHm7hb1o1YbML3c3bdpi5zyJP04MLNHlsSgH
hMWqfRZ79GrsHQ+23qFguQCZXvZcM0cjvQGq3kyWWQ1a+M9TtPcYpT8zsBrs7NF0
4f5apjwb1f663JsHzk94GLCf9rpF/Bxpc5AZNXTLX/KUPCAnfEHnTUnwbbuxNZs0
2dxSewfZDpqTmW9SelXf7QDqiSE+OkVRRRTHEiQWdb4qgysUzkq9cYWGswMqNQE=
=9Gif
-----END PGP SIGNATURE-----

--d5GF466EZ0c6qBMm--
