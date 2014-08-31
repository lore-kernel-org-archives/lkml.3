Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751107AbaHaIYL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 04:24:11 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:55608 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaHaIYC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 04:24:02 -0400
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Marcel Holtmann <marcel@holtmann.org>
Subject: Re: patch "staging: remove nokia_hp4p driver
Date: Sun, 31 Aug 2014 10:23:57 +0200
User-Agent: KMail/1.13.7 (Linux/3.13.0-32-generic; KDE/4.13.2; x86_64; ; )
Cc: Pavel Machek <pavel@ucw.cz>, Greg KH <gregkh@linuxfoundation.org>,
        Miguel Oliveira <cmroliv@gmail.com>,
        kernel list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <14094295422869@kroah.com> <20140830224430.GA19622@amd> <B39194F7-2057-4D14-A3F7-EB6E73BF84F8@holtmann.org>
In-Reply-To: <B39194F7-2057-4D14-A3F7-EB6E73BF84F8@holtmann.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart18073896.AQ9HURVjSc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201408311023.57669@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart18073896.AQ9HURVjSc
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 31 August 2014 01:09:01 Marcel Holtmann wrote:
> Hi Pavel,
>=20
> >>> What is going on here? I get flamed for not cleaning up
> >>> the driver, because I cleaned it up before merging to
> >>> -staging. Ok, so I did more cleanups, sent 3 cleanup
> >>> patches, no reaction on those, and now I got a note that
> >>> you are going to remove the driver...?
> >>=20
> >> For the 3 "cleanup" patches, the first one was rejected and
> >> you said to not include it, so I couldn't apply the
> >> others.
> >=20
> > That was different series. I'm talking about:
> >=20
> > [PATCH 1/3] staging: nokia_h4: switch to right types and use
> > bdaddr_t [PATCH 2/3] staging: nokia_h4: avoid __uX types
> > [PATCH 3/3] staging: use inlines where it makes sense
> >=20
> > That is still valid and received no comments at all.
>=20
> and these are all trivial cleanups and could have been done
> back in January when this driver was merged into staging. It
> is end of August now and nothing happened to address anything
> in the TODO file.
>=20
> The warning from end of May that this driver will be removed
> seemed to not have triggered anybody to work on the core
> issues of the driver.
>=20
> There are 3 major topics that needs addressing before this
> driver should come anywhere near upstream kernel again,
> staging or otherwise.
>=20
> a) Convert to using device tree for device detection
>=20
> b) Convert to using hdev->setup for firmware loading
>=20
> c) Convert to using hdev->set_bdaddr and
> HCI_QUIRK_INVALID_BDADDR
>=20
> Please keep in mind that this was not an ugly Windows driver
> with a lot of Windows specific typedefs or bad coding style
> or OS abstractions. From that point of view it was always
> good since it was written for Linux in the first place. It
> was just a bit dated. Any fixes to bring that in sync with
> all other drivers could have been done easily after it was
> merged into the Bluetooth subsystem.
>=20
> The reason why it ended up in staging is that the 3 core
> problems needed fixing. And 8 month later they still have not
> been fixed.
>=20
> >>> Please don't, I'd still like to clean the driver up and
> >>> get included, as n900's are still under active use.
> >>=20
> >> As the Bluetooth maintainer has said a number of times, he
> >> doesn't want the driver in the tree as it is not doing the
> >> correct things.  It's been a long time in the tree with no
> >> work on it at all, and I follow the suggestions of the
> >> maintainers of the subsystems that staging drivers follow.
> >=20
> > You asked for more work and explained how easy it is to
> > revert the removal.
> >=20
> > I did more work, you ignored it, and are removing the
> > driver, anyway.
>=20
> I have seen only fluff patches. Someone needs to address the
> core problems of the driver.
>=20
> >> I suggest cleaning this up  in your own tree, and then just
> >> submitting it for inclusion in the "normal" part of the
> >> kernel.  That way I'm not
> >=20
> > ...creating a mess in the history, and fun merge problems
> > for people actually using the driver :-(. And yes, n900
> > people actually are using it and have their own changes on
> > top of it.
>=20
> That is even worse. We have a staging driver with external
> patches on top of it. Getting a driver into staging has an
> almost zero barrier and then people still not get their
> patches merged into staging. That is just plain said.
>=20
> Regards
>=20
> Marcel

Hello, external patch is only renaming driver name from=20
btnokia_h4p to hci_h4p - nothing more. And it is only because of=20
Maemo 5 userspace compatibility (which I fix when driver will be=20
in regular bluetooth tree and will be stable). Driver itself is=20
working (with any userspace). So it is not as bad as you think.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart18073896.AQ9HURVjSc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlQC250ACgkQi/DJPQPkQ1KQGwCgud9sYGMTRSbkFo4tXcjj8pZt
VWEAoLPu4sI7aQL0xC1VEfsLT3uzf7mC
=szpW
-----END PGP SIGNATURE-----

--nextPart18073896.AQ9HURVjSc--
