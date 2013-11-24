Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752888Ab3KXTBX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 14:01:23 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:40458 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab3KXTBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 14:01:20 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Anton Vorontsov <anton@enomsg.org>, David Woodhouse <dwmw2@infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, freemangordon@abv.bg, aaro.koskinen@iki.fi,
        pavel@ucw.cz
Subject: Re: [PATCH v2 2/3] bq2415x_charger: Use power_supply notifier for automode
Date: Sun, 24 Nov 2013 20:01:16 +0100
User-Agent: KMail/1.13.7 (Linux/3.11.0-14-generic; KDE/4.11.3; x86_64; ; )
References: <1378630239-10006-1-git-send-email-pali.rohar@gmail.com> <1384856285-19593-3-git-send-email-pali.rohar@gmail.com> <20131124165959.GA655@earth.universe>
In-Reply-To: <20131124165959.GA655@earth.universe>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6393481.xzxlF9Hhgc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201311242001.16299@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6393481.xzxlF9Hhgc
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 24 November 2013 18:00:00 Sebastian Reichel wrote:
> Hi,
>=20
> On Tue, Nov 19, 2013 at 11:18:04AM +0100, Pali Roh=C3=A1r wrote:
> > This patch removing set_mode_hook function from board data
> > and replacing it with new string variable of notifier power
> > supply device. After this change it is possible to add DT
> > support because driver does not need specific board
> > function anymore. Only static data and name of power supply
> > device is required.
>=20
> I'm wondering if the watchdog thread should check some values,
> like e.g. battery temperature. It should stop charging the
> battery if some critical battery temperature threshold is
> reached.
>=20
> -- Sebastian

=46or checking battery temperature is needed third driver=20
(rx51_battery.ko). And I think this should not be implemented in=20
driver itself but in charger manager framework...

Currently on Maemo 5 this is handled in userspace (with open=20
source dsme daemon).

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart6393481.xzxlF9Hhgc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKSTPwACgkQi/DJPQPkQ1KLHgCgrqxHcBZaRRQAJ8mSPELssg9j
Tn8AnjBGx6snq5+26d7tOrV8GKv7KHgB
=QcMP
-----END PGP SIGNATURE-----

--nextPart6393481.xzxlF9Hhgc--
