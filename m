Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755320AbaJWPG3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 11:06:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:60385 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753761AbaJWPG0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 11:06:26 -0400
Date: Thu, 23 Oct 2014 10:06:05 -0500
From: Felipe Balbi <balbi@ti.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Adrian Hunter <adrian.hunter@intel.com>, Felipe Balbi <balbi@ti.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        <linux-usb@vger.kernel.org>, <linux-acpi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [resend PATCH 1/3] ACPI / platform: provide default DMA mask
Message-ID: <20141023150605.GJ13573@saruman>
Reply-To: <balbi@ti.com>
References: <1411545639-18741-1-git-send-email-heikki.krogerus@linux.intel.com>
 <54465C0E.50801@intel.com>
 <54475DB4.5000005@intel.com>
 <2473176.cCrEmjuJQD@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HSQ3hISbU3Um6hch"
Content-Disposition: inline
In-Reply-To: <2473176.cCrEmjuJQD@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--HSQ3hISbU3Um6hch
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 22, 2014 at 04:19:45PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, October 22, 2014 10:33:08 AM Adrian Hunter wrote:
> > On 21/10/14 16:13, Adrian Hunter wrote:
> > > On 21/10/14 16:08, Rafael J. Wysocki wrote:
> > >> On Tuesday, October 21, 2014 03:27:45 PM Adrian Hunter wrote:
> > >>> On 24/09/14 16:49, Rafael J. Wysocki wrote:
> > >>>> On Wednesday, September 24, 2014 11:00:37 AM Heikki Krogerus wrote:
> > >>>>> Most devices are configured for 32-bit DMA addresses.
> > >>>>> Setting the mask to 32-bit here removes the need for the
> > >>>>> drivers to do it separately.
> > >>>>>
> > >>>>> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
> > >>>>> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> > >>>>
> > >>>> ACK
> > >>>
> > >>> Hi
> > >>>
> > >>> I need this for another driver.  Did this patch go anywhere?
> > >>
> > >> It's not in 3.18-rc1 as far as I can say.
> > >>
> > >>> Note Heikki is away at the moment.
> > >>
> > >> That's OK.  I guess I can queue up this one for you.
> > >>
> > >> When do you need this to get into the Linus' tree?
> > >=20
> > > My patches are aiming for 3.19
> >=20
> > Actually it would be easier for me if Heikki's patch is already in
> > 3.18, but all I need to know is when it will hit?
>=20
> I've applied the Heiki's patch and I'm going to push it for 3.18-rc2.

I had this queued for v3.19 with your Ack. It didn't feel like it should
be in v3.18-rc as it's not really fixing any bug. In any case, fine by
me; I'll drop it from my queue.

--=20
balbi

--HSQ3hISbU3Um6hch
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJUSRldAAoJEIaOsuA1yqREbfUP/3MAGasxNzH9LxTuMYGYaZAU
KNkFZLVo0FHOQVtUf2zquQEgkn0FN3wY+QxVyeyeGtsqW7uUBIqJdFf2k9XSGL5E
wQO7bour4aMd2Mex5k/nUBfNciSn1MNrnB7WqVnGENZ9VJNI1pGiHM9b4bqsT91q
Ibz1diOCL9NMluGxrHqqXicMZclcpCud+XgkmWTeqozjzkrjj4sssyfsuzh5E3au
erqZaiqRobqCaiMrNGm0/wfuKg1mE744jPD8R4aEEWcpu0RkwqjxLgw83uwrvRu9
1u5WGbJoOd4zgYvlxviPJ1DplFVyRJCZCPPrWNDU984EhUFs5ssUgvbM8uJPEkWR
271lc5XncXkKAsk6IE7ymyxXKJwqQS6kvHlyhYfC/CbJnFkxfLfcQ53+1QKtwOOV
bDK4jqAgS4y1Bbv227823USZ2mFphaJQSBXRnWon3UICcvwePgBvNYKpu86lSEbJ
jB8F8HVn24FjspAle2ZepVMVIS6r66eHE+EsE+X9XpraZiZk2t/2LWpvO5rBXFaF
kSLPtojJwtTMfvIfpEdKGezBu0xJ/ew0P4CIqtOs9rEszmSdCnFKi5E8nShM3zlk
0MfSzrZA5dxvsAD5aTJ2b+/etL07ViHgaD3bTz7V7UikK2XttkTJZFGww9GVcg4E
KyoDg7Y44QfflnFbzmGF
=wMkX
-----END PGP SIGNATURE-----

--HSQ3hISbU3Um6hch--
