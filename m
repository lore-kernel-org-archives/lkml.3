Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab3FLKM5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:12:57 -0400
Received: from mail-bk0-f47.google.com ([209.85.214.47]:38557 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751454Ab3FLKMz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:12:55 -0400
Date: Wed, 12 Jun 2013 12:12:51 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v3 0/5] Renesas TPU PWM support
Message-ID: <20130612101250.GB30841@mithrandir>
References: <1370958344-19470-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UHN/qo2QbUvPLonB"
Content-Disposition: inline
In-Reply-To: <1370958344-19470-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UHN/qo2QbUvPLonB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 11, 2013 at 03:45:39PM +0200, Laurent Pinchart wrote:
[...]
> I believe I've addressed most comments received in response to v2, with the
> exception of channel allocation at .request() time for which I haven't received
> any answer to my questions. That will hopefully not be a showstopper.

I totally forgot to reply to that mail. Done now. Irrespective of my
comments, I think that cleanup could also be done as a follow-up patch
after 3.11.

Thierry

P.S.: please not that I've switched email addresses and there's also a
linux-pwm mailing list that you should Cc on PWM subsystem related
patches. The info should have propagated to linux-next's MAINTAINERS.

--UHN/qo2QbUvPLonB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRuEmhAAoJEN0jrNd/PrOhnykP/3VAaUoaKCEQ2XYcz0YYCCv6
jLqz7U6DH4ooif/stJXrkyebRENz+or7zTRaLN7xPTcSCF9AjRCOJM/yITmTQPN0
ArKYPB7U7IicXaUn8DZskpnpDOz4z69CFywbqQ2genpclZj0JZ8RKA0gJoI+3PsL
XWP6AJ0sBR2qq4G1vsfG1/JGXVX0wNJB3xjrUKKTEa4mHlAeV8FO4C/Mx3m7l9L1
oxqHVYXToTANDv6pBd9by4IGTZa08NfPRl7VKWeFmU6QrGI0F51EtKg8bVNXgYUH
IyF3jBBO5t4DG5+dD1YUutAqGMPu5CD68hqpFE6ktowJeIiwddV6ismqUbt0Hxb4
7exSOCm3LKwbU4zRNF1khemv4Xy/IUqqQPvDVLEx/iAss7DFmqvaeZyyl6puqU4R
pfJUIe8LY3D3QhuXGXQp8X5rJmkaZFyN7uHup5DWBGXNfIf1ECnJXCHm8YAfdFiS
BEFieoVmNyLlc1vkKP7T8HWBYTiW3d838z0nZ9hmR+XkMnqN2cXmVi+WnbGe2qa4
KZjweJdMV3OraAMIUadONN4d8DPRYI63Kc1B2DvGkxEYF0CTo/E+jWlF3NpOL13S
HmhwU5IhXkAjUmpR+pvKvcXgR9OjPagpLS9PGU1dtvC62chOUGbJ7MxPWf+hakxp
9ZflTnigBwq9vh9VVZdj
=MGUc
-----END PGP SIGNATURE-----

--UHN/qo2QbUvPLonB--
