Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757635AbaLIRIy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 12:08:54 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:55494 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbaLIRIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 12:08:53 -0500
From: Pali =?utf-8?q?Roh=C3=A1r?= <pali.rohar@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 0/7] Fixes for ALPS trackstick
Date: Tue, 9 Dec 2014 18:08:48 +0100
User-Agent: KMail/1.13.7 (Linux/3.18.0-031800rc5-generic; KDE/4.14.2; x86_64; ; )
Cc: Hans de Goede <hdegoede@redhat.com>,
        Yunkang Tang <yunkang.tang@cn.alps.com>,
        Vadim Klishko <vadim@cirque.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
In-Reply-To: <1415993906-13307-1-git-send-email-pali.rohar@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2496229.AcOt0lCa9i";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201412091808.49071@pali>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2496229.AcOt0lCa9i
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 14 November 2014 20:38:19 Pali Roh=C3=A1r wrote:
> This patch series fix detection and identifying trackstick on
> machines with ALPS devices. Last patch split trackstick and
> bare PS/2 mouse packets between dev2 and dev3 input devices
> which make sure that driver will send only trackstick data to
> trackstick input device.
>=20
> Pali Roh=C3=A1r (7):
>   input: alps: Set correct name of psmouse device in
> alps_init() input: alps: Move trackstick detection to
> alps_hw_init_* input: alps: Move alps_dolphin_get_device_area
> into alps_hw_init_dolphin_v1
>   input: alps: Use NULL instead dummy argument for
> alps_identify input: alps: Fix name, product and version of
> dev2 input device input: alps: Add sanity checks for non
> DualPoint devices input: alps: Do not report both trackstick
> and external PS/2 mouse data to one input device
>=20
>  drivers/input/mouse/alps.c |  361
> +++++++++++++++++++++++++++++++-------------
> drivers/input/mouse/alps.h |   14 +-
>  2 files changed, 264 insertions(+), 111 deletions(-)

Hi Dmitry, now when 3.18 was released, can you review this patch=20
series for 3.19?

=2D-=20
Pali Roh=C3=A1r
pali.rohar@gmail.com

--nextPart2496229.AcOt0lCa9i
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlSHLKEACgkQi/DJPQPkQ1K+iACgmcBsbXB8Dtbp8JnOZFe/cqeA
ZcgAoLYjFGzsNX2DvvdmsmBKFJveWCFF
=Fgg9
-----END PGP SIGNATURE-----

--nextPart2496229.AcOt0lCa9i--
