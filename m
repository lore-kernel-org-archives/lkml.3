Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab3CaXSJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Mar 2013 19:18:09 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:39888 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755975Ab3CaXSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Mar 2013 19:18:07 -0400
From: Oleksandr Natalenko <pfactum@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Internal mic doesn't work on Dell Vostro 3360
Date: Mon, 01 Apr 2013 02:17:50 +0300
Message-ID: <2069320.C4QE5MJ4Xi@spock>
User-Agent: KMail/4.10.1 (Linux/3.8.1-pf; KDE/4.10.1; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2231503.ZAXYhHxdgH"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2231503.ZAXYhHxdgH
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hi.

I've got Dell Vostro 3360 laptop, and internal mic doesn't work. I use 3.8 
series kernel.

When I try to record sound from mic I get only weird noise. All sliders in 
alsamixer are 100% and capture is ON.

alsa-info.sh script output could be found here: 
https://gist.github.com/a043fcf2686076d3e48f

I guess it could be fixed by specifying model for snd-hda-intel module but I've 
got no idea what model I should specify.

Takashi, could you help me?

Regards,
  Oleksandr.
--nextPart2231503.ZAXYhHxdgH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJRWMQrAAoJELftKrVLdx04rVkIAISR9WYvTmr3UBL0gk4wpi6S
ccnaY5AfkZDyrWtW+lldPDtDbWgfqSXclawVjFIIjiTZ6dV1VCGaJ+SigNqR1vGP
DjwKSNPCGYFFnh+cATgSW/ArKvMsu2PG0WbYhRyyOBPR5EW5DOF3N8pMCZvhnvIz
XDlkcIhG5VgEUYQIjoIukNroH25vcSdJN7rDp8myX0rZbrSyNz6Ubcji5UMLG0GY
08KJh0xIz+xGSOUpmHZGkeJU+KKDfOEr/to+Twq5zaHVVEGofBKv/TbgqRoCInag
ts0g6nwla/nLz3qMqWt4AzHRvGXSI148m1oHZOX1Pm2HorUMrz99rEsGLss/nes=
=OP7p
-----END PGP SIGNATURE-----

--nextPart2231503.ZAXYhHxdgH--

