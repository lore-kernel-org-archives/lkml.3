Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab3GPMnv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 08:43:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41178 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932086Ab3GPMnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 08:43:49 -0400
Message-ID: <1373978601.2537.8.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [Ksummit-2013-discuss] KS Topic request: Handling the Stable
 kernel, let's dump the cc: stable tag
From: Ben Hutchings <ben@decadent.org.uk>
To: Jiri Kosina <jkosina@suse.cz>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>,
        Greg KH <greg@kroah.com>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date: Tue, 16 Jul 2013 13:43:21 +0100
In-Reply-To: <alpine.LNX.2.00.1307161124430.29788@pobox.suse.cz>
References: <1373916476.2748.69.camel@dabdike>
	 <20130715214422.GA2478@kroah.com> <1373951852.2148.9.camel@dabdike>
	 <20130716062058.GB19052@kroah.com> <1373960616.2148.34.camel@dabdike>
	 <alpine.LNX.2.00.1307161124430.29788@pobox.suse.cz>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-LDBffvhz9SXMqkjTgAWW"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LDBffvhz9SXMqkjTgAWW
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2013-07-16 at 11:46 +0200, Jiri Kosina wrote:
> On Tue, 16 Jul 2013, James Bottomley wrote:
>=20
> > > But I need, from the distros, specific examples of what they object t=
o.
> > > So far all I've gotten is one security patch (that was needed), and o=
ne
> > > patch for sysfs that I backported too far in the version numbers (my
> > > fault.)
> > >=20
> > > Given the huge number of stable patches over the past few years, only
> > > having 2 patches be an issue sounds like things are working well for
> > > people here.
> > >=20
> > > If I don't get pushback, with specifics, from the distros, I will not
> > > know what to change, so if people can provide me that, it will help o=
ut
> > > a lot.
> >=20
> > I agree ... I think Ji=C5=99=C3=AD and his Red Hat equivalent need to p=
ipe up and
> > give us more examples of the problems they've been having.
>=20
> I am still continuing with my pushback against the /dev/random revamp tha=
t=20
> happened in -stable; at least in the form it happened. I still strongly=
=20
> believe it's something that's not a stable material. But that's happening=
=20
> in parallel in a different thread already.
>=20
> Okay, if you want another example:
>=20
> 	commit a6aa749906b92eaec6ca0469f90f35de26044d90
> 	Author: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> 	Date:   Thu Dec 20 15:05:14 2012 -0800
>=20
> 	    drivers/firmware/dmi_scan.c: fetch dmi version from SMBIOS if it exi=
sts
>=20
> While this is a correct fix for major kernel release, as it achieves=20
> correctness by checking SMBIOS version properly and behaving according to=
=20
> the spec, it actually causes an userspace ABI regression in some sense, a=
s=20
> it just changes byte order of /sys/class/dmi/id/product_uuid on certain=
=20
> systems.
[...]

It wasn't even a correct fix, as it caused the DMI header to be detected
in the wrong place on some machines.

Ben.

--=20
Ben Hutchings
Humans are not rational beings; they are rationalising beings.

--=-LDBffvhz9SXMqkjTgAWW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUeU/6ee/yOyVhhEJAQpPAA//SQWKIrv29X3x3vjvRZd8H9cKoG/MSBWq
ihD3dZT0RJ1gtEl64DGdLi0zsWJnE1GdWIDDfKZ1ng1gD3KAqL9vqRgrKSS+XZIp
tfZGD6DYS2UW7oXejDlxca80fiTd0e4ex7QcKHvVe5wiJ6t36LPRoKojKxEke5MT
Ni/WOUOjvbgW/6euTEqCRo0r2WppsIdE8oivAKVQwVUa7E6sAmJ2MCf/Bdgiu5Ud
utpaXZIKNmodAc66vl/kxDSK+ULlpDAYebKafcDhopgKbzvvIZy7mHsSxzwBvtQF
A+9h8gHzsmQWEYIRzqz4kIrH0/8DzqsUXS5vOkdMeGxZuKVqezCyrmHtLW9vJ1qy
o9aju2SABO/Y1hmMzAzr4woAtfaA8badurRUE26Y3KiquQ94D2fSVCBkoOJl62It
oJAtBAAqbxH9qokAVNhrIRY5L3vz21f3KrEXzLX6r6EO5IWeuCTkH/Ja0VNMbq90
DrzqxseAe9L00D1NvZhpeAqWCMkamNeL2VmZDc8I2yN8YUGT0L+TEdI5qMZxUddJ
OAwbK2MLpKR/EXmm/HEyZY3iv6tsHzJfjFZbU3UGMcatOtTfSDPVuT0+aTB5FEFh
JqCbzw5RqDC/VDi7uQm2aRMr6H9aJ30lfRsvrQSv2bL8I0RW3dbHLMI4r56NniZA
3P3Fv38S+WA=
=HzuL
-----END PGP SIGNATURE-----

--=-LDBffvhz9SXMqkjTgAWW--
