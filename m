Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962AbaL1QHw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 11:07:52 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:63683 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818AbaL1QHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 11:07:48 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Gabriele Mazzotta <gabriele.mzt@gmail.com>
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult, fan_max) from driver
Date: Sun, 28 Dec 2014 17:07:43 +0100
User-Agent: KMail/1.13.7 (Linux/3.13.0-44-generic; KDE/4.14.2; x86_64; ; )
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org, Valdis.Kletnieks@vt.edu
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <201412281648.55076@pali> <5055106.1nbl2aCxTj@xps13>
In-Reply-To: <5055106.1nbl2aCxTj@xps13>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2192132.fLOCLJ51AF";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412281707.44124@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2192132.fLOCLJ51AF
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 28 December 2014 17:02:35 Gabriele Mazzotta wrote:
> On Sunday 28 December 2014 16:48:54 Pali Roh=C3=A1r wrote:
> > On Sunday 28 December 2014 16:25:21 Gabriele Mazzotta wrote:
> > > On Sunday 28 December 2014 09:46:19 Pali Roh=C3=A1r wrote:
> > > > Ok, here are new patches for testing... Those you are
> > > > still reading this email thread and have your Dell
> > > > machines near, can you test them (ideally with
> > > > disabling dmi config data)?
> > >=20
> > > Could you please tell me exactly against what should I
> > > apply these patches? I can see that they depend on other
> > > patches in this thread, but I can't find any tree that
> > > includes them.
> >=20
> > Two patches in previous email could apply on 3.19-rc1 tree.
>=20
> I see that the second patch you've just sent depends on the
> followings: https://patchwork.kernel.org/patch/5524791/
> (I8K_SMM_GET_TEMP_TYPE)
> https://patchwork.kernel.org/patch/5524731/ (Copyright)
>=20
> If I'm not wrong, they are not included in 3.19-rc1.

Yes, they are not included in 3.19-rc1 but patches from previous=20
mail should work without them.

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2192132.fLOCLJ51AF
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSgKtAACgkQi/DJPQPkQ1J1BQCgveapH0u4teziZhchVS1eUPQD
PJYAnRBYgDsSlEzZhtaX2HjD1y2Zurzu
=WvFE
-----END PGP SIGNATURE-----

--nextPart2192132.fLOCLJ51AF--
