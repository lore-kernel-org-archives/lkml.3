Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab3LFUTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:19:24 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:46949 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab3LFUTW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:19:22 -0500
Date: Fri, 6 Dec 2013 14:18:39 -0600
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
CC: David Cohen <david.a.cohen@linux.intel.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv5.1 3/5] usb: gadget: f_fs: remove loop from I/O function
Message-ID: <20131206201839.GC21086@saruman.home>
Reply-To: <balbi@ti.com>
References: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com>
 <1384201011-11114-4-git-send-email-david.a.cohen@linux.intel.com>
 <xa1twqkewkyl.fsf@mina86.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7gGkHNMELEOhSGF6"
Content-Disposition: inline
In-Reply-To: <xa1twqkewkyl.fsf@mina86.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--7gGkHNMELEOhSGF6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 12, 2013 at 12:57:22AM +0100, Michal Nazarewicz wrote:
> When endpoint changes (due to it being disabled or alt setting changed),
> mimic the action as if the change happened after the request has been
> queued, instead of retrying with the new endpoint.
>=20
> Signed-off-by: Michal Nazarewicz <mina86@mina86.com>
> Cc: David Cohen <david.a.cohen@linux.intel.com>

pretty obvious patch, looks good.

--=20
balbi

--7gGkHNMELEOhSGF6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSojEfAAoJEIaOsuA1yqRE3j0P/0upHkaafEpYSJoG8qFNaCpE
GRxzUol7AahLaoGCifGsucGw4nbFWWqRE0IJ1//Ot+UcMfmklhuy0AenwRTzBpog
m9rKB7LgAfGREaKndxdMFy8qv7JCGbTjsCMmuon1cZm2OIKgKErUwTDH+seEwUbq
cKnoLdnW9YvmUcDj0xBmQi/jW7opbhr5jkF06h0y9JXsLXYICX4oFOKkGVaDuMtH
6EhFmLyPyBmQdF4qS1wSOvLnZKTwTZZIAMiJi2kHzCOcnZZHraWU3BH078yJAAaK
U68pO0/Ra+91iLYAvD+cM54Qz2fu3qXl+F9jZl5exUb901MtbknY1/h3R5KrztYc
l87f4RavoqZVLXyJVzfHi4n3yyEoJFDlzHQTwZGe6pXGTwANbRozYqxAg60w3vbH
fl3GIX67wqgCp1wx8/ceB/mwGEDFmBFrBFA6pU4aHn5H38ZoEWvT8EluYPRpcmMf
ve5fljLxMJAWAfvtbuCYdHQN+9/PuqJPRrdGJ34t/RqL/AxFEh1efmzKhvxf9fms
Aa+lj6sOsBGStOwKwqG55LPvsmkr9YTMZk2nYufdjPlwE10VvKqaAszTojr/IC/F
oczKSL6MDyCpoDv6e/SrbnKj+qld5Smtj0OPV7aAOozR4sTCYOya3U5EqsuWy/AO
gvABFrCHhr9tnmaVANFh
=NFGr
-----END PGP SIGNATURE-----

--7gGkHNMELEOhSGF6--
