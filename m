Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751731Ab3CURgS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:36:18 -0400
Received: from mail-vb0-f48.google.com ([209.85.212.48]:54883 "EHLO
	mail-vb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490Ab3CURgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:36:17 -0400
Date: Thu, 21 Mar 2013 13:36:13 -0400
From: tmhikaru@gmail.com
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux 3.2.41
Message-ID: <20130321173613.GA1948@roll>
References: <1363809494.31336.73.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Content-Disposition: inline
In-Reply-To: <1363809494.31336.73.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 20, 2013 at 07:58:14PM +0000, Ben Hutchings wrote:
> I'm announcing the release of the 3.2.41 kernel.
>=20
> All users of the 3.2 kernel series should upgrade.
>=20
> The updated 3.2.y git tree can be found at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
=2Egit linux-3.2.y
> and can be browsed at the normal kernel.org git web browser:
>         http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.g=
it
>=20
> Ben.
>=20
> Ben Hutchings (3):
>       Revert "powerpc/eeh: Fix crash when adding a device in a slot with =
DDW"
>       dmi_scan: fix missing check for _DMI_ signature in smbios_present()
>       Linux 3.2.41

	I confirm that this is booting and working properly on my system.
Thank you again for helping me get this fixed!

Tim McGrath

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQEVAwUBUUtFDZEncCrqzVruAQJjxQf/ZXNyet5qkHstZlaZ9pHVhC0lg2WkgDky
WeFJ3FyBJPOl7x70fnvHppt/4I5621nJqG1zq/CqtVwLiMk14Tka5gzG6oLlkcv/
urvGPyA1gV4azFBd6YL53cwFz1x2V3mTjwa5Wvr+Ekvz1w1qGCfuLYJu82WvyJtk
3eoYeQSv8XumKbTNg3pD9RUi0ubOG27PNbo3BnVNIALJPcbRWICWb/A49VrtV7GR
08o9idE+Xws1vLxVbjG+Bg7JuU7UbrXbdLV/+3lBO+u5a1jtTFtNqyI3UGOC79IA
f3cTdqAyKPgWLWNHoGHtIAP6IBMFpYrFepk7Z61KQoGs5x24nMkf/Q==
=CpQm
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
