Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966412Ab3E2OvT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 10:51:19 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58448 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966311Ab3E2OvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 10:51:16 -0400
Message-ID: <51A60C74.4010307@ti.com>
Date: Wed, 29 May 2013 10:11:00 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Benoit Cousson <b-cousson@ti.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 3/3] arm: dts: add bandgap entry for OMAP4460 devices
References: <1368629928-6723-1-git-send-email-eduardo.valentin@ti.com> <1368629928-6723-4-git-send-email-eduardo.valentin@ti.com> <5193A875.1020000@ti.com> <5193B9AA.7020507@ti.com> <519488D3.5070003@ti.com> <5194D0AF.3010407@ti.com>
In-Reply-To: <5194D0AF.3010407@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2KUUHPHAEQWTSEPCMFMGT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2KUUHPHAEQWTSEPCMFMGT
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Salut Monsieur Benoit,

On 16-05-2013 08:27, Eduardo Valentin wrote:
> On 16-05-2013 03:20, Benoit Cousson wrote:
>> Hi Eduardo,
>>

<cut>

>> We need to check.
>>
>=20
>=20
> Yeah, I also dont think this will work, because we will reparent the
> interrupt, setting to a different controller. That will break the TALER=
T
> signal already defined at GIC (check original patch).
>=20
> I propose keeping the way I sent. Unless there is a way to set two
> different controllers to same device.
>=20

Any idea on this patch? Shall we keep the way it is?


>> Regards,
>> Benoit
>>
>>
>>>> Where is the gpio controller phandle?
>>>>
>>>> Usually it looks like this:
>>>>
>>>> 	gpios =3D <&gpio1 8 0>;
>>>>
>>>>
>>>> Regards,
>>>> Benoit
>>>>
>>>>
>>>>
>>>
>>>
>>
>>
>>
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2KUUHPHAEQWTSEPCMFMGT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGmDHUACgkQCXcVR3XQvP2QzAD+LUbGTeJN6QVdvm9G6B19Qslt
PVG0PhzwlCELr9If3KsA/22QSuAYuBxyBtwBApSh3bnJqtMH4736qOmwiN144Klw
=Upp6
-----END PGP SIGNATURE-----

------enig2KUUHPHAEQWTSEPCMFMGT--
