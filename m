Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290Ab3D3LKU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 07:10:20 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:43962 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760149Ab3D3LKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 07:10:09 -0400
Message-ID: <517FA68B.20001@ti.com>
Date: Tue, 30 Apr 2013 14:10:03 +0300
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Sam Ravnborg <sam@ravnborg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <linux-kbuild@vger.kernel.org>
Subject: Re: Kconfig "softdepends" idea
References: <517F9472.2030106@ti.com> <20130430102440.GA15522@merkur.ravnborg.org> <20130430103318.GB12161@arwen.pp.htv.fi>
In-Reply-To: <20130430103318.GB12161@arwen.pp.htv.fi>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="----enig2EFWDUUOAROBKOVRLQTJB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2EFWDUUOAROBKOVRLQTJB
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 04/30/2013 01:33 PM, Felipe Balbi wrote:
> Hi,
>=20
> On Tue, Apr 30, 2013 at 12:24:40PM +0200, Sam Ravnborg wrote:
>>> So, my idea is to have a new kind of Kconfig dependency. I'll call it=

>>> "softdepends" in lack of better name. A driver maintainer could use
>>> "softdepends on ARCH_OMAP", instead of "depends on ARCH_OMAP", to say=

>>> that this driver does not actually build depend on ARCH_OMAP, but for=

>>> all normal purposes it does.
>>>
>>> Normally, this would result in the same behavior as the normal
>>> "depends", and Linus would not get a questions whether he wants to
>>> enable this OMAP specific driver or not, and the driver would not be
>>> visible on the menuconfig.
>>>
>>> But the user could enable the driver if he explicitly so wants. Perha=
ps
>>> a Kconfig option such as "ignore softdepends", enabling of which woul=
d
>>> allow the user to enable the drivers that use softdepends. Or, maybe
>>> just require the user to add the config option manually into his .con=
fig.
>>
>> If I understand you correct this is already possible today without
>> extending the kconfig language.
>>
>> config OMAP_SPECIFIC_DRIVER
>> 	depends on ARCH_OMAP || SHOW_ALL_DRIVERS
>>
>>
>> If SHOW_ALL_DRIVERS are "y" then user can say "y" to the OMAP specific=

>> driver too, even without ARCH_OMAP being selected.
>=20
> SHOW_ALL_DRIVERS might create another set of issues. If Linus isn't
> taking patches removing 'depends on ARCH_OMAP' would he take patches
> adding SHOW_ALL_DRIVERS ?

Wouldn't the SHOW_ALL_DRIVERS be just a one time query from Kconfig to
the user? So Linus only needs to say "n" once. Why would he object to tha=
t?

Then again, as a personal opinion, "depends on ARCH_OMAP ||
SHOW_ALL_DRIVERS" is not very descriptive. I'm not sure if that matters,
though. One doesn't need to read the Kconfig files every day =3D).

But presuming most of the drivers would use that, it would add quite a
bit of repetition to the Kconfig files. Well, ok, I have no idea how
many drivers have dependencies that could be removed.

So SHOW_ALL_DRIVERS sounds quite an easy solution to this.

 Tomi



------enig2EFWDUUOAROBKOVRLQTJB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJRf6aLAAoJEPo9qoy8lh71eZ0P/iPaxK1MxwGbwewqTD4oibXM
waav5U22+pzpw40OR3VWzUJqsQWrI04azG4h7tL988NdMkQe4yGlNORFSm4m96P/
cIUxhAiESX2ZSBMndLLUlCCSuDSPJvjFkCl7VerZBDbI0oqwkoU/cKaDZLrVpkqW
EUG3gzJ+ttCqjSxh/AuCAyxiFE/bqw42es7IvG06Fd1886m/7Ehw+jRkQTfLsl/g
3TDHrfHOk6L2jQ/ydVdjyiaWvaGuZB8EsfxgYxKs45tWsNwGaoddCegqahYfBixG
2U6cB4x8IJDQV8mPqP9Rv2s8AEfuzGjWukdqxiyQrwba6PmABnLgGR1GagOoyq7B
RjcIW1iWqWkVmYkpo4FIOS2y6VCW0YZMY7lbKD5CD+n+DXmBD1o4eLlL39jXXJ28
yhhTm88+o7ySn7eKt0A17qlGxoqPlLkiOTwZV0H0dAgomejS3mPEmvaYRcfeBbRj
0gfoOkaNc1kNfsKTnGm0I3a+INp935ZeU+EHInWt5JOeyBlmHLiRnkj3i8ChiTyP
bej/3o6DfkIwV7ZY987YaYcbeWyNurNMdqm92xeIhm8hDGahZvHb0UNOt2EG8ORN
Dft5Z3zpJZ61yJSQvKOA3JTFCaheW8HXlSMNeifSfzSDtyH6vDyChmuD2PDjHAQ3
3RlgDq2EiM9OQfx+bnym
=FHhP
-----END PGP SIGNATURE-----

------enig2EFWDUUOAROBKOVRLQTJB--
