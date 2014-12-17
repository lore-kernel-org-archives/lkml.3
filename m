Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229AbaLQRyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 12:54:08 -0500
Received: from mail-wg0-f45.google.com ([74.125.82.45]:46131 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750976AbaLQRyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 12:54:06 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Steven Honeyman <stevenhoneyman@gmail.com>
Subject: Re: [PATCH 3/3] i8k: Remove laptop specific config data (fan_mult, fan_max) from driver
Date: Wed, 17 Dec 2014 18:54:00 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.2; x86_64; ; )
Cc: Guenter Roeck <linux@roeck-us.net>, Arnd Bergmann <arnd@arndb.de>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>,
        linux-kernel@vger.kernel.org
References: <1418155621-21644-1-git-send-email-pali.rohar@gmail.com> <1418155621-21644-4-git-send-email-pali.rohar@gmail.com> <201412101251.30610@pali>
In-Reply-To: <201412101251.30610@pali>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10671797.cXR51W3b8y";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412171854.00902@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart10671797.cXR51W3b8y
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 10 December 2014 12:51:30 Pali Roh=C3=A1r wrote:
> On Tuesday 09 December 2014 21:07:01 Pali Roh=C3=A1r wrote:
> > Now we have autodetection code for fan multiplier and
> > maximal fan speed so we do not need to have those constants
> > for each laptop in kernel driver code.
> >=20
> > Signed-off-by: Pali Roh=C3=A1r <pali.rohar@gmail.com>
> > ---
> > !!!Please do not apply this patch until all affected
> > machines will be tested!!!
> >=20
> > I tested autodetection code only on Dell Latitude E6440
> > (where it worked). Other machines which needs to be tested:
> >=20
> > Dell Latitude D520
> > Dell Latitude E6540
> > Dell Precision WorkStation 490
> > Dell Studio
> > Dell XPS M140 (MXC051)
> > ---
>=20
> Can somebody else with dell laptops test this patch series?
=20
Steven Honeyman, can you test this autodetection patch on your=20
Latitude E6540?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart10671797.cXR51W3b8y
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSRwzgACgkQi/DJPQPkQ1IHtACfYoLFzVhv6TfYH7l3YQKlLlCR
L+0AnAjxbXN+Liop39RjRehIW/oN3kOk
=pcnl
-----END PGP SIGNATURE-----

--nextPart10671797.cXR51W3b8y--
