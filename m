Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759840Ab3BNMFb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 07:05:31 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38972 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757502Ab3BNMFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 07:05:30 -0500
Message-ID: <511CD300.7080207@pengutronix.de>
Date: Thu, 14 Feb 2013 13:05:20 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: Pengutronix e.K.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: artem.bityutskiy@linux.intel.com
CC: linux-mtd@lists.infradead.org, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Subodh Nijsure <snijsure@grid-net.com>
Subject: Re: [PATCH RFC 4/5] UBIFS: Add security.* XATTR support for the UBIFS
References: <1360750998-15191-1-git-send-email-mkl@pengutronix.de>  <1360750998-15191-5-git-send-email-mkl@pengutronix.de> <1360826890.12703.158.camel@sauron.fi.intel.com>
In-Reply-To: <1360826890.12703.158.camel@sauron.fi.intel.com>
X-Enigmail-Version: 1.5
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="----enig2LJJLALTOKVWQNJUWIOCB"
X-SA-Exim-Connect-IP: 2001:6f8:1178:4:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2LJJLALTOKVWQNJUWIOCB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 02/14/2013 08:28 AM, Artem Bityutskiy wrote:
> On Wed, 2013-02-13 at 11:23 +0100, Marc Kleine-Budde wrote:
>> --- a/fs/ubifs/journal.c
>> +++ b/fs/ubifs/journal.c
>> @@ -553,7 +553,8 @@ int ubifs_jnl_update(struct ubifs_info *c, const s=
truct inode *dir,
>> =20
>>         dbg_jnl("ino %lu, dent '%.*s', data len %d in dir ino %lu",
>>                 inode->i_ino, nm->len, nm->name, ui->data_len, dir->i_=
ino);
>> -       ubifs_assert(dir_ui->data_len =3D=3D 0);
>> +       if (!xent)
>> +               ubifs_assert(dir_ui->data_len =3D=3D 0);
>=20
> Shouldn't this snippet be in 2/5 instead?
will do

Marc
--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


------enig2LJJLALTOKVWQNJUWIOCB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iEYEARECAAYFAlEc0wAACgkQjTAFq1RaXHObRACZAa7xadNENbmsVDz5dy4yUtMy
33wAn22eKpbjiPgud+9AwduwBcpxeF9u
=wjuM
-----END PGP SIGNATURE-----

------enig2LJJLALTOKVWQNJUWIOCB--
