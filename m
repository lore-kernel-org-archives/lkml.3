Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935951Ab3DHUX0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 16:23:26 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:48381 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935607Ab3DHUXZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 16:23:25 -0400
From: Oleksandr Natalenko <pfactum@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Internal mic doesn't work on Dell Vostro 3360
Date: Mon, 08 Apr 2013 23:23:20 +0300
Message-ID: <2752429.vDjr2sliNi@spock>
User-Agent: KMail/4.10.2 (Linux/3.9.0-pf; KDE/4.10.2; x86_64; ; )
In-Reply-To: <2069320.C4QE5MJ4Xi@spock>
References: <2069320.C4QE5MJ4Xi@spock>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2367414.bjUliJmvPl"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart2367414.bjUliJmvPl
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Thanks to large HDA code rework the problem is fixed in 3.9 kernel, at least in 
3.9-rc6 and at least for me :).

On Monday 01 April 2013 02:17:50 Oleksandr Natalenko wrote:
> Hi.
> 
> I've got Dell Vostro 3360 laptop, and internal mic doesn't work. I use 3.8
> series kernel.
> 
> When I try to record sound from mic I get only weird noise. All sliders in
> alsamixer are 100% and capture is ON.
> 
> alsa-info.sh script output could be found here:
> https://gist.github.com/a043fcf2686076d3e48f
> 
> I guess it could be fixed by specifying model for snd-hda-intel module but
> I've got no idea what model I should specify.
> 
> Takashi, could you help me?
> 
> Regards,
>   Oleksandr.
--nextPart2367414.bjUliJmvPl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQEcBAABAgAGBQJRYyc9AAoJELftKrVLdx04wB8H/278SoJE4RWIxAVwnY5M+m+A
sCZjmdRvJWNAdpWZDz+eAiCPnv5sBgb3UhEhi15YbVippea5wPPMTR4wrAFtQ+rj
REYF2U2NG1rVOrItXvnelIGNin30/mOkqRMERoLuTqAOH6aSnSvnKejE4YPadMWm
9j3VRrl+jaGVm1QiDFIcEJ4HDpZ3MlxAXjLtM3juQFWI9FryrtQfMU1fbKxZc64f
hDYDc8EsDWcMuK/KWk2tdgORx71DVAzlh6Fi8HBs+VViACzOq9IOE55Y8BkdN0mc
mytOGlUW0/gIU77IpEwdiALVhyQXHuI2celt8ZJsSsk4ga9dggaZdnVSt+lxRTc=
=yYXJ
-----END PGP SIGNATURE-----

--nextPart2367414.bjUliJmvPl--

