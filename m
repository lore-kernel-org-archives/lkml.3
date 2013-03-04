Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555Ab3CDN5X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 08:57:23 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37231 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756992Ab3CDN5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 08:57:22 -0500
Message-ID: <1362405431.3768.314.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 093/153] ALSA: hda - hdmi: Make jacks phantom, if theyre not
 detectable
From: Ben Hutchings <ben@decadent.org.uk>
To: David Henningsson <david.henningsson@canonical.com>
Cc: stable@vger.kernel.org, akpm@linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 04 Mar 2013 13:57:11 +0000
In-Reply-To: <51345148.1040102@canonical.com>
References: <20130304033716.795093499@decadent.org.uk>
	 <1362374037.3768.298.camel@deadeye.wl.decadent.org.uk>
	 <51345148.1040102@canonical.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-tppISj53lcgFPn91aPvB"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tppISj53lcgFPn91aPvB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-03-04 at 08:46 +0100, David Henningsson wrote:
> On 03/04/2013 06:13 AM, Ben Hutchings wrote:
> > On Mon, 2013-03-04 at 03:38 +0000, Ben Hutchings wrote:
> >> 3.2-stable review patch.  If anyone has any objections, please let me =
know.
> >>
> >> ------------------
> >>
> >> From: David Henningsson <david.henningsson@canonical.com>
> >>
> >> commit 30efd8debd1ef30be342d374f01e993509f5b76b upstream.
> >>
> >> Just as for analog codecs, a jack that isn't suitable for detection
> >> (in this case, NO_PRESENCE was set) should be a phantom Jack
> >> instead of a normal one.
> >>
> >> Thanks to Raymond Yau for spotting.
> >>
> >> BugLink: https://bugs.launchpad.net/bugs/961286
> >> BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=3D903869
> >> Signed-off-by: David Henningsson <david.henningsson@canonical.com>
> >> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> >> [bwh: Backported to 3.2: adjust context]
> >> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> >
> > David, do I need to change this further for 3.2.y?
>=20
> Greg and Ben,
>=20
> Given some thought, the definition of is_jack_detectable has=20
> changed/improved over kernels. Therefore I think it's safer not to apply=
=20
> the patch at all for kernels earlier than 3.6. Let's revisit this=20
> decision if there's actually a user demand for this fix.

OK, I've dropped this from the 3.2.y queue.

Ben.

--=20
Ben Hutchings
Always try to do things in chronological order;
it's less confusing that way.

--=-tppISj53lcgFPn91aPvB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUTSoN+e/yOyVhhEJAQqa5g//TKW48fUYF73E6pzap2zX5RF+TJmihmcr
Ppz0gv1CbdW7mBQFSvck3ISEnfbK6YjepTRICGs3PXQ917kLUD8Ksl9buKtY3V81
CqaC2lG8234WOeeokyjC1sriGgIfrW+nYeIL8GBBeWHnJI3ItiuKzuS88naAVgp0
Ii6oOy+z37cTYA8taBoqtq9YMB3bWtto9KkQtdtXbDcWo4U2gEWlLIy9VCaJHb7j
Bg8Bvq4JrufGilzlvqZ32+Q70BM8/87HSfznkFEZD/5KPAAVdxgtmr9CxrtwLoYh
1Lp2WMc1e5PwxEfBvxcDCQM5OUxAFTic96ynyXsVHuEu/cj0CSqMWUh01G68rQ0k
OooK9obxQ7Y7WCqIRddftWIxt4YhangitzkRg89+v4AYoLXtBKTIAjai+YnrW9D2
GYyFOH/mt83CCP7unlHOvEqXz9DZnCbJD2VUTxx3Er5M+o6lVIa4vkbXxnSq4P5W
wPHA3zF4tLefc1nBp+77LeodVinqCyFW5QTQm79Ra3jlWAs9W8WWbus8rdbo+XXz
yAoOPASY+SSxD0oTeDveSTBDqksU4a1OpBeMNiNOZRIyh8SeqJV+OqsI/QFZYdfu
XVfvNqxLP1SXZ0glvEk8Z+qs7gSdJk0ytbhzl6ej2+C7xZdr95EIcCSkwNBdVwt5
nDCgc/0R9hY=
=kETF
-----END PGP SIGNATURE-----

--=-tppISj53lcgFPn91aPvB--
