Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756243AbaLJLvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 06:51:35 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:41326 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790AbaLJLvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 06:51:33 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult, fan_max) from driver
Date: Wed, 10 Dec 2014 12:51:30 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.2; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <1418155621-21644-4-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1418155621-21644-4-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2773376.ca6kNlcEa0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412101251.30610@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2773376.ca6kNlcEa0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 09 December 2014 21:07:01 Pali Roh=C3=A1r wrote:
> Now we have autodetection code for fan multiplier and maximal
> fan speed so we do not need to have those constants for each
> laptop in kernel driver code.
>=20
> Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> ---
> !!!Please do not apply this patch until all affected machines
> will be tested!!!
>=20
> I tested autodetection code only on Dell Latitude E6440 (where
> it worked). Other machines which needs to be tested:
>=20
> Dell Latitude D520
> Dell Latitude E6540
> Dell Precision WorkStation 490
> Dell Studio
> Dell XPS M140 (MXC051)
> ---

Can somebody else with dell laptops test this patch series?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2773376.ca6kNlcEa0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSIM8IACgkQi/DJPQPkQ1KV8ACgyynBcEZobkduQfRMnGC9y5LY
w/8AnjBtzcuBXaccMlrOBX/pnkyLOfNR
=xLV+
-----END PGP SIGNATURE-----

--nextPart2773376.ca6kNlcEa0--
