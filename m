Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755158Ab3LJROn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 12:14:43 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:53323 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754712Ab3LJROj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 12:14:39 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Subject: Re: [PATCH v2 15/16] wl1251: Add sysfs file address for setting permanent mac address
Date: Tue, 10 Dec 2013 18:14:34 +0100
User-Agent: KMail/1.13.7 (Linux/3.12.0-5-generic; KDE/4.11.3; x86_64; ; )
Cc: Luciano Coelho <luca@coelho.fi>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, freemangordon@abv.bg,
        aaro.koskinen@iki.fi, pavel@ucw.cz, sre@ring0.de,
        joni.lapilainen@gmail.com, Johannes Berg <johannes@sipsolutions.net>,
        Felipe Contreras <felipe.contreras@gmail.com>
References: <1382819655-30430-1-git-send-email-pali.rohar@gmail.com> <87txegpuyk.fsf@purkki.adurom.net> <201312101710.51015@pali>
In-Reply-To: <201312101710.51015@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2810353.qq4FXZTbCO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201312101814.35112@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2810353.qq4FXZTbCO
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 10 December 2013 17:10:50 Pali Roh=C3=A1r wrote:
> On Tuesday 10 December 2013 16:49:23 Kalle Valo wrote:
> > Pali Roh=C3=A1r <pali.rohar@gmail.com> writes:
> > > Driver wl1251 generating mac address randomly at startup
> > > and there is no way to set permanent mac address via
> > > SET_IEEE80211_PERM_ADDR. This patch export sysfs file
> > > which can set permanent mac address by userspace helper
> > > program. Patch is needed for devices which do not store
> > > mac address in internal wl1251 eeprom.
> > >=20
> > > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> >=20
> > We have ioctl() command for setting the mac address.
>=20
> Really? Is there ioctl for setting permanent mac address?
> Can you show me it?

Now I looked at it again and I did not found any ioctl for it.=20
There is only ioctl cmd for getting address, not setting it.

#define SIOCETHTOOL 0x8946

/* Get permanent hardware address */
#define ETHTOOL_GPERMADDR 0x00000020

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2810353.qq4FXZTbCO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlKnS/sACgkQi/DJPQPkQ1J31wCgrIJnLvfHn3mrxDuz5NXWGAZp
TdYAnAi+f8roZoYzm97nHVHz9VY/2KqV
=7/CT
-----END PGP SIGNATURE-----

--nextPart2810353.qq4FXZTbCO--
