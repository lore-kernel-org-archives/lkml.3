Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754724AbaDNI2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 04:28:23 -0400
Received: from gerolde.archlinux.org ([66.211.214.132]:44681 "EHLO
	gerolde.archlinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaDNI2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 04:28:09 -0400
Message-ID: <534B9C12.4050708@archlinux.org>
Date: Mon, 14 Apr 2014 10:28:02 +0200
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt@console-pimps.org>
CC: "H. Peter Anvin" <hpa@zytor.com>,
        =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] efi: Clarify Kconfig help for EFI_MIXED
References: <1397239154-30121-1-git-send-email-thomas@archlinux.org> <53482E61.8050606@zytor.com> <20140411184433.GA15344@console-pimps.org> <20140414071534.GA19501@gmail.com>
In-Reply-To: <20140414071534.GA19501@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Reh3gL8cIXIWFkig8QbcxkxS4moq3KsxM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Reh3gL8cIXIWFkig8QbcxkxS4moq3KsxM
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 14.04.2014 09:15, schrieb Ingo Molnar:
>>> Right, it is really that it is not possible to boot a mixed-mode kern=
el
>>> on its non-native firmware using the stub, since the stub itself can
>>> only be one way or the other.
>>
>> Yeah, my help text was a bit... unhelpful.
>>
>> CONFIG_EFI_MIXED does not introduce a regression of any sort, you can
>> enable it without worrying about that.
>>
>> All the boot configurations that used to work will continue to work.
>>
>> What I meant to say was that it isn't possible to use the EFI mixed=20
>> *feature* (booting a 64-bit kernel with 32-bit firmware) with the=20
>> EFI boot stub - so you can build support into your kernel but=20
>> there's no way to make the CPU actually execute those code paths.
>=20
> Same goes for booting a 32-bit kernel on 64-bit firmware, right?
>=20

It seems that isn't implemented:

config EFI_MIXED
        bool "EFI mixed-mode support"
        depends on EFI_STUB && X86_64



--Reh3gL8cIXIWFkig8QbcxkxS4moq3KsxM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJTS5wVAAoJEChPw0yOSxolznIP/jA+IUESW0J+1y3EYsKUf5G2
Hu99NeEOLsBUAKbLfv4aIhsU5n9hw0AXVCEGUo9/9CUG4hak1zXolh3zgl3VHkJL
4IdB8XovWku5yzaqujrXzSLb92YyRSLCuUfz0l/qOT+DEgXv102LfjFNwLj/mw4X
aMqzc5zeVWi/z9NXEfVzYhH5MK2Xwr5VvDkrkHbsRiTeYEvkfgMfVdSXk6Ehy35j
1ojEEwPLMQGfr1Y329Tp/jf0WQQyTYTXOW4s8dOMz5iY3O7MZX+/V2emLYgkLEPK
6JzkcBajPM8GyZ9FG+j/sR6eSJsKlvz9jq8IJzf8S9MPdJ4mLsas7mOrhzrjoU2D
VTHYPsLT70ARn779wvqM9oBmGi8eDoHU1Sg9OvEzHU64nxaywX2WH6kt1GZSA+No
kThktOp2TK/RovC3HfAlDB0ntu5rOXd3qyaVB7AQAc7L3F8Nyd3RqV3QkK5d0R2S
8lDz0kIfkWJv3RmWkfyMfAl8w0E/HtpML1SUnjpeFruiUzhwxeXkH90711ylcs/V
YvxOEr2k9n03DSpZsd25TUUPE/fvRjCBFWNqxMXaIz4ytBQaIuANUFxb1uedd9+V
OuYs3i6LgM2OxVLGYTCDWq34NTP//cORX1ZnrsReCET2IwMflQC0nvU2vSkH+PYE
Bek0UFWEIfhMhy9fjxv2
=ouLE
-----END PGP SIGNATURE-----

--Reh3gL8cIXIWFkig8QbcxkxS4moq3KsxM--
