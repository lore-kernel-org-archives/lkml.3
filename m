Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab3FZUBD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 16:01:03 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56125 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab3FZUBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 16:01:01 -0400
Message-ID: <51CB4877.7000105@canonical.com>
Date: Wed, 26 Jun 2013 22:00:55 +0200
From: Stefan Bader <stefan.bader@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: ben@decadent.org.uk, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, hayeswang@realtek.com, romieu@fr.zoreil.com
Subject: Re: [16/26] r8169: fix 8168evl frame padding.
References: <lsq.1372214158.437609827@decadent.org.uk> <51CAAB98.6040706@canonical.com> <20130626.113708.974853729895213353.davem@davemloft.net>
In-Reply-To: <20130626.113708.974853729895213353.davem@davemloft.net>
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig79D3938C7A09D7005633C823"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig79D3938C7A09D7005633C823
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 26.06.2013 20:37, David Miller wrote:
> From: Stefan Bader <stefan.bader@canonical.com>
> Date: Wed, 26 Jun 2013 10:51:36 +0200
>=20
>>> [ Upstream commits e5195c1f31f399289347e043d6abf3ffa80f0005 and
>>>   b423e9ae49d78ea3f53b131c8d5a6087aed16fd6 ]
>  ...
>> No abjection, just make sure that
>>
>> commit b423e9ae49d78ea3f53b131c8d5a6087aed16fd6
>  ...
>> is included as well.
>=20
> Read the commit message carefully, the two commits were folded into
> one exactly to deal with this issue.
>=20
Oops, yeah you are right. Sorry for the noise. Should not reply while cof=
fee has
not kicked in.

-Stefan


--------------enig79D3938C7A09D7005633C823
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBCgAGBQJRy0h3AAoJEOhnXe7L7s6j0RIP/2ezapYIYVVwm+TYPoN33XtB
t5vNv/izt+G0ZCzlbD5D9O6MlBFj0f+gYAFeIZEByOyR/1Q/1w9SM2tcNftAcCm3
NnP049IJvBrVhDapQOye4HeGQLFEZWB1bk0KnS0LlOCnYtLM8F/dS1k5TBDKp7Gz
3hbMtJr6Il38/AnI2/g4BPeNaMHza4Cf2OUlmFi4bvFYawmTzvSRVpMxMeukWGlL
C8gmwHaBpKBBIlk0Om2o1pZGxvG5aG/9+SAxyzPxJMGn8etQlBcxrfMm9seQkDNu
Y+N9oeSJNiS3EB4Ii5w89pLqUzDK8ziWHSKwO2dSKvpBBiwiJyH+j/W9xJnPgn4Y
Xjns39aBqrzCfSW+TXMB1NPIib52JSHTNyx7yII4nBbGzUM0ZRVJNPg1ZF4B20Xq
bLE/p+Qf2lzPmD1UA47erC1IBNk9fTCRgrpsGoTos0GKgQOY+SY+MqYejxhu8uM9
yXAxNUNgroILh0ZrXHkjQtOnzJbsguhw8Kh3BDqR55/AQi3w6vPnwGbow1MIxll6
pIj/hCD2xXU4YOqNw2nDT+nNeUu4DLyHv4klmDlpO8DZbdm0VTtZkeGal4kiMNTM
31aVzZKdQcYhvxDvxU1LbeBuXF612pfyPZ6K2I4u4E87fAucFo3YF08Ms/hKKuun
r7QkzdZSNixeG1VvkoVT
=YSbF
-----END PGP SIGNATURE-----

--------------enig79D3938C7A09D7005633C823--
