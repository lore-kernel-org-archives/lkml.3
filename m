Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaG1M2S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 08:28:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51465 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751598AbaG1M2Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 08:28:16 -0400
Message-ID: <53D641DC.4020804@suse.de>
Date: Mon, 28 Jul 2014 14:28:12 +0200
From: =?ISO-8859-1?Q?Andreas_F=E4rber?= <afaerber@suse.de>
Organization: SUSE LINUX Products GmbH
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Michal Simek <monstr@monstr.eu>, Lars-Peter Clausen <lars@metafoo.de>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        Matteo Vit <matteo.vit@starwaredesign.com>,
        Sean Rickerd <srickerd@suse.com>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 09/11] Documentation: devicetree: Fix ADI AXI SPDIF
 specification
References: <1406242820-20140-1-git-send-email-afaerber@suse.de> <1406242820-20140-10-git-send-email-afaerber@suse.de> <53D20A61.1050506@metafoo.de> <53D21066.8000905@monstr.eu> <20140725101815.GO17528@sirena.org.uk> <53D2324B.4070602@suse.de> <20140725103905.GP17528@sirena.org.uk> <53D63746.3000905@suse.de> <20140728122042.GR17528@sirena.org.uk>
In-Reply-To: <20140728122042.GR17528@sirena.org.uk>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="6QqR6FuGNcK35Uj4Dv97DxmKABTHoLefr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6QqR6FuGNcK35Uj4Dv97DxmKABTHoLefr
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 28.07.2014 14:20, schrieb Mark Brown:
> On Mon, Jul 28, 2014 at 01:43:02PM +0200, Andreas F=E4rber wrote:
>> Am 25.07.2014 12:39, schrieb Mark Brown:
>>> On Fri, Jul 25, 2014 at 12:32:43PM +0200, Andreas F=E4rber wrote:
>=20
>>>> Maybe this works for you?
>>>> https://patchwork.kernel.org/patch/4620191/
>=20
>>>> Otherwise I can resend with Ab/Rb.
>=20
>>> Documentation/SubmittingPatches.
>=20
>> Not helpful here, nor is
>> Documentation/devicetree/bindings/submitting-patches.txt. It's separat=
e
>> from code changes, sent via git-send-email, has a Sob, went to LKML an=
d
>> LAKML and DTML. I could add a Fixes: header and CC trivial for this
>> one-line fix IIUC.
>=20
> It's telling you that the kernel process is to review patches sent via
> e-mail, not random links to web appliations - notice the context to
> which I'm replying, I'm saying that sending a link to something on the
> web isn't a good way of submitting a patch.
>=20
>> Doesn't tell me which patches I should CC you on in the future though.=

>> Therefore my request to fix the false negative in MAINTAINERS so that =
me
>> and other kernel newbies don't run into it again.
>=20
> Feel free to submit patches if you want to see changes.

Dude, this patch *was* submitted and has been reviewed by two people.
Don't pretend I didn't follow the SubmittingPatches workflow.

The link I gave you contains an mbox-format link that can be used with
wget and git-am to *apply* the patch if you apparently missed it on the
mailing lists.

I will *re*-submit it for your convenience.

Andreas

--=20
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imend=F6rffer; HRB 16746 AG N=FCrnbe=
rg


--6QqR6FuGNcK35Uj4Dv97DxmKABTHoLefr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJT1kHdAAoJEPou0S0+fgE/84YP/0gh8qqQhaOOWXVD22Lb4ib9
I1CQ1weeLcc3MIVMWTyS9PqmvrsScfKMNbJ5X+HxKETN1uj/i62d25yVSlntxntJ
//1QJwlH3JchSqHs3j9TkrpWU4f4QQY4J5P0k2ppKmyAChlZQLuszmsl51CBJX7A
wEtmPj4141ZGq40dbBheN2vgpkWGSJmmVvy+6kunhuPpVEXOSRP0225N2wQ+sAq8
5twkbHAXGsd1qIjrT7TnF6YAAFSFWnEBx5PxUWH6HbqE4WojEDTcdlM3T0dl9kcI
teXJrI1h++j+RfRJYh6qXpzR9NvrLfpJl5ZqBE8vzQgNcDqu3TcwPanNUukq2ng9
8hrnXRQQKA/v1qgsH7dB/BgBFDNOT1KgvA12KOAY2ZDBq/NiEFNuOOEy7o+H0Y0N
aEf8qkjZjHmr9y+/UV2jE7dkwvTA05lhmq7CKT8/0A3+DgscranORrZuk/y5sKp5
pPC+nvvdoGu2Eg6N4/M8PVgMZcctQT1nb89kS2QOTLUBsAJbwU+35d1pyUN1MOo4
+q3a5piZP1yg3jvNYrj3NP4xRrfGIa1JyiKrtIrU7atWjyu+8UyjzKb2B+bEMIq5
6NBLoXPjJCXbr+9IahiyamQfYIsNGKAHhnkcZO9lSf9jrvjKU1UjX+uiOfyTj68p
b/Fa5Osz1gOqKrYc1CVm
=Ashm
-----END PGP SIGNATURE-----

--6QqR6FuGNcK35Uj4Dv97DxmKABTHoLefr--
