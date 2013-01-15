Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab3AOGoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 01:44:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:61357 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753678Ab3AOGoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 01:44:38 -0500
Date: Tue, 15 Jan 2013 07:44:18 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Laxman Dewangan <ldewangan@nvidia.com>, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, swarren@nvidia.com,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH v2 2/4] input: keyboard: tegra: use devm_* for resource
 allocation
Message-ID: <20130115064418.GA31561@avionic-0098.adnet.avionic-design.de>
References: <1357371910-3164-1-git-send-email-ldewangan@nvidia.com>
 <20130114161644.GC14721@kroah.com>
 <20130114221551.GA30020@avionic-0098.adnet.avionic-design.de>
 <201301142224.11243.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <201301142224.11243.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:zWoxootpoLcUatGcO2m++2S3uAvn1UCiE7gY4sfbRY9
 ugVku8Rqf9S8nHuiqaVcjs2FGowiTvrBXA1qIW3mudZqXGcXiw
 MEArPTjDGy0PWcAgWsU/v0wIIA5XgmAcCWKXhBXU2HRO1NGN6B
 kLrCZj3vsi8TP3CQN/29Bv0ZhaltpRyFAcnMlD54YsRLeSvi+m
 oe/6zODONfADdbuXxNmd8bh0An3PR8GChYmH0jhvLdQBO7JYO6
 y7VrIjQYPzgSYXVKSRrpGA/hi905BXJ4DMfRfOmKECHLyYVkZT
 3XgdmzN3sCIdscp++FUIb2Sp4+2TEbHZovHyxik69tYWO6GrMw
 mSYjk151PMmXrMo4uLLDhpfknbwqt+Jvb1N8kaxfE07jgnzM96
 SMnvByh3gXUtgfEvna+xVmldUx54x8ShVg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 14, 2013 at 10:24:11PM +0000, Arnd Bergmann wrote:
> On Monday 14 January 2013, Thierry Reding wrote:
> > It certainly sounds like a less complicated way to do it. But it also
> > involves adding a function with a made up name and drop a function with
> > a perfectly good name instead. I wouldn't even know what name to choose
> > for the new API.
> >=20
>=20
> How about devm_ioremap_resource()? Sounds equally fitting, and is shorter.

Yes, that sounds good. Thanks for the suggestion.

Thierry

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ9PrCAAoJEN0jrNd/PrOh8EUQAINqNe6OAwnG8+v2YacerpeP
jpM0W7ng9kly+Jh7wPl2MpBEzDoKAp9AvmPmOuPZVaLBhVikJB0pB/cQgtERlLxA
KJgtdEepQb5RInvaZ3lMO07W/OlsZyP3F16e4GO5MEN3VN93QqFgWACRl8U+52aM
yEbUu6cHImAsxEeWTiLzAJJpTqTmvj0+BN15W4jirVJKWG6dyp6QQP0QyWONro/a
FEH0UygwPMAz8Mv5eL3p8of87Xt07A4NMAjfTSOpLVIilX3ElJkKsKfr5IbHD+nX
r8UODa6sM4LD1c1w0TM5so1DpsVE+YEdm6PbCOeqLa3zqJ3gpkm/psrd9Dwp6ThG
P0FZUrjDcGucznVzRY9LuU5etPd9oLcdMsF65J6k4wXgaAFQ92lQ2yC97H6p7q2j
k+YdPIPz8jKouwlpywHvLvmcjZv4tO8r/L5dVuT77uinWN8ZNFjfFbRylgbrLPxb
OfVF1sBokC6kGTAww71VaNURxOFt28QkGEkr8juCO83eZR2Ms4/NQxmLHggoGPf/
GDdDX81LW2tXRK5AFPFduXOsxt+Fek/E7R0B0EyFY6u+JLVeLhj2htZz2LOh/JHF
hbU9kZaO44C16wx4/4XhnGsLUxhPGw0MS1aVF/EmKiq4op9QxR2BO0xpDM3i6H45
piEnYv4jP0kNIUbOhlJm
=n2WD
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
