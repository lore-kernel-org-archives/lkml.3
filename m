Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933882Ab3GWSqq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 14:46:46 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56295 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933683Ab3GWSqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 14:46:45 -0400
Message-ID: <1374605189.31029.25.camel@fourier>
Subject: Re: Linux 3.11-rc2 (acpi backlight)
From: Kamal Mostafa <kamal@canonical.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        James Hogan <james@albanarts.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Steven Newbury <steve@snewbury.org.uk>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Date: Tue, 23 Jul 2013 11:46:29 -0700
In-Reply-To: <9012759.Alzqtdvh5b@vostro.rjw.lan>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com>
	 <5728692.GlhGgHY92H@vostro.rjw.lan>
	 <CA+55aFyrMRDD8qe9DYXixaSLJXEURMYYku1azABA72m71_X+cA@mail.gmail.com>
	 <9012759.Alzqtdvh5b@vostro.rjw.lan>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-lqqy07Vgp17JQ/x5L8IR"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-lqqy07Vgp17JQ/x5L8IR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2013-07-22 at 21:54 +0200, Rafael J. Wysocki wrote:
> On Monday, July 22, 2013 11:11:54 AM Linus Torvalds wrote:
> > On Mon, Jul 22, 2013 at 6:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > >
> > > Linus, do you want me to send a pull request reverting 8c5bd7a and ef=
aa14c?
> >=20
> > Yes, but [...] I'd suggest doing the revert just in time for
> > rc3, but waiting until then to gather info about people who see
> > breakage.
> >=20
> > Sound like a plan?
>=20
> Yes, it does.
>=20
> Rafael


Hi Rafael-

For your reference...

As James Hogan reported, those ACPI changes break backlight control on
the "Dell XPS13" Ivy Bridge models (the Sandy Bridge XPS13 model is not
affected).

I confirm that reverting 8c5bd7a and efaa14c fixes it again.


Also FYI...

On Mon, 2013-07-22 at 00:08 +0100, James Hogan wrote:
> Note that acpi_video0 only worked because I was applying "[PATCH]
> drm/i915: quirk no PCH_PWM_ENABLE for Dell XPS13 backlight" [1], so
> strictly speaking mainline already didn't work.
>  [1] http://lkml.org/lkml/2013/7/19/748

That patch is now queued up in drm-intel/drm-intel-fixes, so should be
making its way to mainline soon.

 -Kamal


--=-lqqy07Vgp17JQ/x5L8IR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJR7s+FAAoJEHqwmdxYrXhZZ5gP/04OQ6KQaNYBRgIIdv3/xKOF
3297CwFPYYeHDagrac58o2QwTghmwHDhUFLRN+4yP1CRfKgGede/ye4LnNL7EZhL
jJQfMtCGhrFvbuittgqg4tB1sKWcBuEErenmap0VsFM8kELBDOD6ICK/fSStd78I
LH13o7few/PO1XwxcDtica5oQKqZbUPGQV6njOu7TTPQu1K4fWst4BQvh77p+x0P
/bUmqn0wvY+XuyfgFSSSZ/VhBpvrtoI035OqwOY5BJafX4Jd0cN4DrulXZrdh3lm
MBMemEGJXgMomdqvS7LuyqTkAKQnMDpooiEk1hJpxrW1Cc1OyJ5O6ubXQgcOzr3U
dvo/WSgLWvACtm4I+8ta+EFsuf29uuTL/oZ5n0IUve6X8zCNNKznNp6yrx0smYRf
BLPhQmJcvUK9O92XqPMM3x9NNdWjewwA9HKzrQwu1pihJSBPn95J7dthr9dV/bRA
c4T50jI7XbtMNY/kt/bVvJfDaIH8iJ4LdMLXOsD15apV4WwMQMpcNJcW5bV7fejG
2rkaMh15DsUD9r+IZQTAK+oNbuYf03tvA2zTx8KGX2VhJVj9IZ6j91/LpYuUr3yQ
mKDlCjUzjQnZU0e6siue3SvIGG4E03sBSVlqJqWbldgkMBHye6aqoZbj3NHQ9Nd6
Sy7ZhLmR+zakrGdW8nSn
=UVh+
-----END PGP SIGNATURE-----

--=-lqqy07Vgp17JQ/x5L8IR--

