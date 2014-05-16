Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaEPUiI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 16:38:08 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:59759 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751456AbaEPUiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 16:38:06 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Sebastian Reichel <sre@kernel.org>
Cc: linux-kernel@vger.kernel.org,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: Status of Power Supply Subsystem
Date: Fri, 16 May 2014 22:54:51 +0200
Message-ID: <1946020.rieJTheGae@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140516183812.GA17752@earth.universe>
References: <20140516183812.GA17752@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1466722.ajRJWqoQ9t"; micalg="pgp-sha256"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1466722.ajRJWqoQ9t
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"

On Friday, May 16, 2014 08:38:14 PM Sebastian Reichel wrote:
> Hi,

Hi,

> It seems the maintainer of the power supply subsystem, Dmitry, has go=
ne missing
> in action since about mid-Feburary. I couldn't find any mail from him=
 on the
> usual mailinglists, he did not reply to any of my mails and the power=
 supply
> subsystem git tree mentioned in the MAINTAINERS file has not been tou=
ched since
> 2014-02-01 [0].
>=20
> Is there a standard procedure to handle subsystem maintainers, who ar=
e missing
> in action? I have patches for the power supply subsystem and have see=
n more
> patches from other developers on the mailinglists.
>=20
> [0] git://git.infradead.org/battery-2.6.git

You can volunteer to take over the maintainership, but then I guess it =
would
make sense to push this through the PM tree anyway, so please feel free=
 to
send a pull request with those fixes to me.

Thanks!

=2D-=20
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
--nextPart1466722.ajRJWqoQ9t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAABCAAGBQJTdnshAAoJEILEb/54YlRxi74P/1U/D4AHf5u2VAdQMLVb2S8O
46m757bpQijfk7d31rsjjgL4wySkMoytYm6ebMOgBUVdPYp0hmTM8ldNtS5MHdaK
yothx2Kvl5VZ130wGv8RzP/mFtWgVdS5ifLoC7s7pg8LA67DLdp2KJGEe9pkVRqs
bgwpO2oKq3g7M0dpjNhgs4JX+p4gGbjbpDqXXMOybVcVVjRTBRpDIWlRjxS6+AX8
kG5ewlYugnYF3r6fobBQdQTeLaT8eNRu2NUMsNUl9WMYyQPXxaeF+HpmaIPRI92d
xaU5DeFNx86CWFcUHCNHTmUXhXq1xAbFjxSha9l3GVZBOzFUwR9H7REQ4MJGtBp7
22yk1u4v12WRATn+Y4m6e5hsnZfZzCW8z+CYd27fkdsSM7r0GdfWmeFc0pANjrTB
bTI9IzytNJl3R4gSsp/db2Ay7RJPBCIkiiR9s+tydANAVTOJRCSmDLW4pJXs63pz
L2BY2RMbHLBCpteAbEwbpysKqloK9jvcOccFFAgH01yL0vQEVNyUSdNMnw6hAtQn
aX7atB/fQmMvFZp2jJVJLdhDaOMM7S32p7ITcuHdEFcaOnLDivOrGqtGXN6npa0w
wDi13E20NO0HLSfsy0iJHPT7PnXN9TISqS8bv8MdJoAZQpELeMOuS1bv7u8dDTne
Acwapt3TjUpu6nnNLyDK
=BG4Y
-----END PGP SIGNATURE-----

--nextPart1466722.ajRJWqoQ9t--

