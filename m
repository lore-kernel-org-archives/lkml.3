Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757130Ab3BFEp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 23:45:57 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58827 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755163Ab3BFEp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 23:45:56 -0500
Message-ID: <1360125941.32217.26.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 105/128] efi: Make efi_enabled a function to query EFI
 facilities
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Matt Fleming <matt.fleming@intel.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, akpm@linux-foundation.org,
        David Airlie <airlied@linux.ie>,
        Corentin Chary <corentincj@iksaif.net>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Dave Jiang <dave.jiang@intel.com>, Olof Johansson <olof@lixom.net>,
        Peter Jones <pjones@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        Steve Langasek <steve.langasek@canonical.com>,
        Tony Luck <tony.luck@intel.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Date: Wed, 06 Feb 2013 04:45:41 +0000
In-Reply-To: <20130204182009.GA3219@kroah.com>
References: <20130203144653.313760856@decadent.org.uk>
	 <1359904557.1822.2.camel@deadeye.wl.decadent.org.uk>
	 <1359996265.7515.180.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20130204182009.GA3219@kroah.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-eEV89KNJHafxb3D6PIJL"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eEV89KNJHafxb3D6PIJL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-02-04 at 10:20 -0800, Greg KH wrote:
> On Mon, Feb 04, 2013 at 04:44:25PM +0000, Matt Fleming wrote:
> > On Sun, 2013-02-03 at 16:15 +0100, Ben Hutchings wrote:
> > > As you can see this needed quite a lot of work to backport, and I
> > > haven't been able to test it yet.  So I would particularly appreciate
> > > careful review of this.
> >=20
> > Everything looks fine to me but I haven't actually booted with these
> > changes.
>=20
> I didn't backport this to the 3.4 kernel, as I didn't think it really
> was necessary, but now that Ben did all of the hard work, I'll see if
> his version applies there, as it would be good to solve this issue for
> that kernel release.  Thanks for verifying that this work at least looks
> sane.

No, my backporting work for 3.2 is not applicable and not needed on 3.4.
I think you just need to adjust context in arch/x86/kernel/setup.c and
init/main.c.

Ben.

--=20
Ben Hutchings
Everything should be made as simple as possible, but not simpler.
                                                           - Albert Einstei=
n

--=-eEV89KNJHafxb3D6PIJL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAURHf9ee/yOyVhhEJAQotrg//RKZfLQAPeojHMTkkU6789d/1XQWAvgtD
8v3P7OYaw10rHjopbwaV7ikPXUDNbJI7Pyfoui0ox5Xdk0/8ghjTBngC+RowI8Q0
wzHSYNeYGPOrr9Ai30rL6EiiGBmSAv1e/JWhpXNHH68k/BtsalxHk1tUTKQsqjun
1Bfa+34X602jsMU0yDyLQIs1y5mCsKPAbs0bk8m6i+4oibZJC2z/EGSon2ApvTqQ
SPPbbm78g93DfLYUn/AYF9f4JgwqAprmxq6uUB7Ww+NSbAaiJryV/vL30n1+sadO
YaBCmT+PXgYAiuiJ14mPxynv+6FG+hBUK6OcR2P/orowJwr383alaO9gpEE6Bu4w
Tr5XCfi2t6R2qMPd5xsITY9k3WKOYmHftG85xz6dKJzzqbqaLO+YCN2agC7UKv3y
kDppj2/+oVFvN8mhZTIbeN4hosNUVEN9rv46+yk16M74E/FZw+f7QuqoZI+RGGum
lZm4jkBotIrsjY6zmJqijyVg7OMqcq8xiZg3P2Nmgq3xKgFhdLtWtujUlCyR8h9r
1Ol3tXIwn1LWxzgy6lmtSH7kti6ON9LYClRn4OgMSb4rDAlXqGjdXYkpeBYVP0j8
qQzBbVxJG74D9x6M0AtTcx/85DTRQB7tN0zEK09ssZJxjDYemYHp3bgtAEl/1JHL
bgjWo1e6sdM=
=HXrQ
-----END PGP SIGNATURE-----

--=-eEV89KNJHafxb3D6PIJL--
