Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934837Ab3CZPoz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:44:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49113 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934758Ab3CZPox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:44:53 -0400
Date: Tue, 26 Mar 2013 15:44:43 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Eric Piel <eric.piel@tremplin-utc.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: Driver lis3lv02d_i2c not working on Nokia RX-51
Message-ID: <20130326154442.GE18316@opensource.wolfsonmicro.com>
References: <201302170046.26569@pali>
 <201303242345.00176@pali>
 <20130324230435.GE18316@opensource.wolfsonmicro.com>
 <201303261602.40219@pali>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Vx/N56bIaYnO6ICL"
Content-Disposition: inline
In-Reply-To: <201303261602.40219@pali>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Vx/N56bIaYnO6ICL
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 26, 2013 at 04:02:39PM +0100, Pali Roh=E1r wrote:

> What do you think how to fix this problem? I do not know about any=20
> HW regulator for n900 accelerometer and possible solutions could=20
> be revert that commit or adding fake regulator to board code...

Reverting the fix is not an option, this is a clear bug in the platform.

There will be a regulator here, the device needs power.

--Vx/N56bIaYnO6ICL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRUcIcAAoJELSic+t+oim9Gm0P/i/pBWkZ8kMnolB6H4TQFHK+
CQI6XwGmg5fX6dlYR5BNcwDtOcfy7H9Tj4R5dzz6xjGqcaFe99MoBQ6TgW4RI3mz
LsoFtqWDcvJrmREju6GPOS385d4PPEsafrF/MDcpmskuVgB+9jFsGtglNZD2m1Bi
oxVurNCLcp2PBNfqyDb6kbv3ie+Ni92DaYfRWAAKWr0MxfTScky5PmyLjna6A2mL
NGM+VkIcehIg56BO2p3tb0cBtwcGCkRAqTbncI248kx7QH4qaT5grVcxjGBCtuis
2n2CWOxL8xw6ICNus8sxfZ1S9eomnEpuhfPOee59h7dWHR8HP+ZftDO6UbR1pVWV
L8Xe1gt+gmusRDIwccToe+AiBxxCcql57ZUuXs3I54I2hEi16bXuieSOE7YajyhT
MUgE1U5ypmw8ObLH0/K6gl2qViZ2WcFdln5l3oKHBBJAARjBnkowMMC3B8Tdi2bc
yIYb0aSuZyhcq5wOcfUA3FsHqd+SjaFRMPT/JEaBIT6m80E0oA9IvFttq3DF7+NF
uNbTKhmTq8/T5XA5LGifIpiU2b8pyrb8A8UsWUlsikNVva+xZ9dqL7mnHmxjGQbr
FENydaf37igicUeoHpK4MrB6D+f8Vcp8yLysnznF2Qvy+JBI3cDYqsxYneaBm051
8cnWRXav+86Cig4qBjRM
=pswm
-----END PGP SIGNATURE-----

--Vx/N56bIaYnO6ICL--
