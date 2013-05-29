Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756709Ab3E2PnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 11:43:14 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:50633 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753904Ab3E2PnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 11:43:13 -0400
Message-ID: <51A621EB.5080805@ti.com>
Date: Wed, 29 May 2013 11:42:35 -0400
From: Eduardo Valentin <eduardo.valentin@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: "Cousson, Benoit" <b-cousson@ti.com>
CC: Eduardo Valentin <eduardo.valentin@ti.com>, <tony@atomide.com>,
        <linux-omap@vger.kernel.org>, Russell King <linux@arm.linux.org.uk>,
        <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 3/3] arm: dts: add bandgap entry for OMAP4460 devices
References: <1368629928-6723-1-git-send-email-eduardo.valentin@ti.com> <1368629928-6723-4-git-send-email-eduardo.valentin@ti.com> <5193A875.1020000@ti.com> <5193B9AA.7020507@ti.com> <519488D3.5070003@ti.com> <5194D0AF.3010407@ti.com> <51A60C74.4010307@ti.com> <51A60E7E.2070905@ti.com>
In-Reply-To: <51A60E7E.2070905@ti.com>
X-Enigmail-Version: 1.5.1
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature";
	boundary="----enig2KVESOHHRXAJFUWOMHFSK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------enig2KVESOHHRXAJFUWOMHFSK
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 29-05-2013 10:19, Cousson, Benoit wrote:
> Hi Eduardo,
>=20
> On 5/29/2013 4:11 PM, Eduardo Valentin wrote:
>> Salut Monsieur Benoit,
>>
>> On 16-05-2013 08:27, Eduardo Valentin wrote:
>>> On 16-05-2013 03:20, Benoit Cousson wrote:
>>>> Hi Eduardo,
>>>>
>>
>> <cut>
>>
>>>> We need to check.
>>>
>>> Yeah, I also dont think this will work, because we will reparent the
>>> interrupt, setting to a different controller. That will break the TAL=
ERT
>>> signal already defined at GIC (check original patch).
>>>
>>> I propose keeping the way I sent. Unless there is a way to set two
>>> different controllers to same device.
>>>
>>
>> Any idea on this patch? Shall we keep the way it is?
>=20
> Well since we cannot use directly interrupt, I think we need to use at
> least the proper gpio binding.
>=20

hmm... OK. sounds reasonable. I will change the driver and resend this
one in one single series.

> Thanks,
> Benoit
>=20
>=20
>=20


--=20
You have got to be excited about what you are doing. (L. Lamport)

Eduardo Valentin


------enig2KVESOHHRXAJFUWOMHFSK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iF4EAREIAAYFAlGmIesACgkQCXcVR3XQvP37TQEAxrSUBxkTI4JmfVk7HhZWLm0g
G9lnqJzWPAGmxXVi6yYA/jiTHsN0hzhgGxYSTuTK2S/iITYDpfH6mDuLyew4Z64A
=wxT/
-----END PGP SIGNATURE-----

------enig2KVESOHHRXAJFUWOMHFSK--
