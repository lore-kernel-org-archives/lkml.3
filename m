Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaBTDBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 22:01:36 -0500
Received: from ozlabs.org ([203.10.76.45]:48511 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752456AbaBTDBf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 22:01:35 -0500
Date: Thu, 20 Feb 2014 14:01:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the sound-asoc tree
Message-Id: <20140220140121.6fa31d92fd9def2e118d9ae8@canb.auug.org.au>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.22; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__20_Feb_2014_14_01_21_+1100_q/a6jbnjHN2/bSlu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__20_Feb_2014_14_01_21_+1100_q/a6jbnjHN2/bSlu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

sound/soc/codecs/cs42l51.c: In function 'cs42l51_probe':
sound/soc/codecs/cs42l51.c:490:26: warning: unused variable 'cs42l51' [-Wun=
used-variable]
  struct cs42l51_private *cs42l51 =3D snd_soc_codec_get_drvdata(codec);
                          ^

Introduced by commit da0714897624 ("ASoC: cs42l51: Convert to direct
regmap API usage").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__20_Feb_2014_14_01_21_+1100_q/a6jbnjHN2/bSlu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBCAAGBQJTBXAIAAoJEMDTa8Ir7ZwVSDMP/1uQoD+v6NrUzENkAPDo7wm6
QRXQXSFfyc4XPtR4pv3T0/M+7pYTF15Xj++ENjF01nrhSnNwtMgU8Z7bG4TkIYo2
wZBdmjoJMIqrw67oOxpQrXJru/HJv6reoAZ7hUzPljSWcDxZAHFCgQk9SxSre5Ks
tKMhGfMZlpGUdL66caz1bdp4w8dUWjBQmnkTgv8Q2ZDNiSu6aEDOeczxK6lmF7L8
N+gw6VI5M8w9bKW4B59VLuRo6B0Gd6Xgbe6JorRiliMzrOY+SDLnPDPtS8y8EWV7
cOtVl1WyKM7zGCm9vk9AobOnCvxZQxBs0ackD2BlBtKqOuxS0cfbAnfo0+wYwnk+
XDG7BO0KaEyWK4oPG9rvibbcYDC+9HLDXSt7AYIrx/B8SCJloZcDcd975+Da4frn
igwiVBB7+mYA9QyFje0CzMxQL/DmvJdZjCewBniqRuaOUwUs60P2VkG5MgWJPUIQ
MXJT3y4Te/aMqNnay4QukamexNTTWl4cQrMZGNE6jZhuQdvg4Ct75ANWW4rlzo34
BgomMITFIdtnUEMDtlEWXBg3dodj2MgWYpq3iFaswM67mMalg1KvU1tQlw/P63UB
Ylm14hgrKCv3FSNyTOhTFJS7X/g63mf3mScQ+zOYIHOFgd5rosoQTRvCvo1F1eZH
G/0hXFXpNCOOpoY3yXgP
=N7UP
-----END PGP SIGNATURE-----

--Signature=_Thu__20_Feb_2014_14_01_21_+1100_q/a6jbnjHN2/bSlu--
