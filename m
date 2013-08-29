Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab3H2WU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 18:20:59 -0400
Received: from vm1.sequanux.org ([188.165.36.56]:40472 "EHLO vm1.sequanux.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756119Ab3H2WU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 18:20:57 -0400
Date: Fri, 30 Aug 2013 00:20:54 +0200
From: Simon Guinot <simon.guinot@sequanux.org>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH v3] gpio: add GPIO support for F71882FG and F71889F
Message-ID: <20130829222053.GE13942@kw.sim.vm.gnt>
References: <1374486633-9737-1-git-send-email-simon.guinot@sequanux.org>
 <CACRpkda2bH_TkFR6c0cXvjye4SmFWN5xuzQSO=NqBq8mNDgV0g@mail.gmail.com>
 <20130801134632.GY9916@kw.sim.vm.gnt>
 <CACRpkdZcEPM-u19pc+v_cRqUSfJBFZ49rJYiewQ1sWWSU5YxEg@mail.gmail.com>
 <20130829125754.GA8813@srcf.ucam.org>
 <521F4F95.5080103@roeck-us.net>
 <20130829153738.GA16306@srcf.ucam.org>
 <20130829160830.GB25021@roeck-us.net>
 <20130829162551.GA17411@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6Vw0j8UKbyX0bfpA"
Content-Disposition: inline
In-Reply-To: <20130829162551.GA17411@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6Vw0j8UKbyX0bfpA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 29, 2013 at 05:25:51PM +0100, Matthew Garrett wrote:
> On Thu, Aug 29, 2013 at 09:08:30AM -0700, Guenter Roeck wrote:
> > On Thu, Aug 29, 2013 at 04:37:38PM +0100, Matthew Garrett wrote:
> > > On Thu, Aug 29, 2013 at 06:41:41AM -0700, Guenter Roeck wrote:
> > > The majority of board vendors clearly don't expect the OS to drive th=
e=20
> > > hwmon chips - they're there for the benefit of ACPI and SMM code. Tha=
t=20
> > > doesn't mean that there's no benefit in having drivers for them, just=
=20
> > > that the board vendors don't care about that use case and so won't do=
=20
> > > anything to make it easier.
> > >=20
> > Actually, not entirely true. Some vendors even provide software running=
 on
> > Windows to access those chips (including access to fans controlled thro=
ugh
> > GPIO pins) and to provide information to the user. It might be more acc=
urate
> > to say that some board vendors don't care about Linux (or about providi=
ng
> > access through ACPI, for that matter).
>=20
> Eh. If they're really providing code that just assumes that hardware is=
=20
> present and bangs on it, what choice do we have? You've checked that the=
=20
> machines in question don't have a magic ACPI device that provides=20
> resource information?
>=20
> > Question here is what the Linux kernel community's policy is going to be
> > to handle such cases. Pragmatic or dogmatic ?
>=20
> I don't see any benefit in changing the status quo. Sometimes hardware=20
> is just shit. The majority of x86 vendors certainly don't care about=20
> anything we do, so it's not like we're in a position to force them to=20
> change.

Almost all the LaCie NASes are running a Linux based OS. I can assure
you that LaCie really takes care of Linux. Now, the main reason why the
Super-I/O ACPI support is missing on this boards is a lack of knowledge.
Thanks to this discussion, I am now aware of that. Then, for the next
products, I will do my best to get AMLs or at least ACPI IDs.

Thanks,

Simon

--6Vw0j8UKbyX0bfpA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlIfyUUACgkQgtp0PDeOcDqI4ACePNV1GULAOlN5PSqkK8/GiUxO
aToAoIQBQ804PKbdsLdepqGEbxMwy+9v
=8cCj
-----END PGP SIGNATURE-----

--6Vw0j8UKbyX0bfpA--
