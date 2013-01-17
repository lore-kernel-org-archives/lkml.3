Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab3AQM3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 07:29:25 -0500
Received: from mga01.intel.com ([192.55.52.88]:30128 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab3AQM3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 07:29:24 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,486,1355126400"; 
   d="asc'?scan'208";a="274937446"
Message-ID: <1358425853.2731.241.camel@sauron.fi.intel.com>
Subject: Re: [PATCH v2] mtd: vt8500: Add support for Wondermedia Serial
 Flash Controller
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Tony Prisk <linux@prisktech.co.nz>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        vt8500-wm8505-linux-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Date: Thu, 17 Jan 2013 14:30:53 +0200
In-Reply-To: <1358421664.2731.228.camel@sauron.fi.intel.com>
References: <1358272414-6266-1-git-send-email-linux@prisktech.co.nz>
	 <1358421664.2731.228.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-MYiRyFB5Pp5cZfSkhtuT"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-MYiRyFB5Pp5cZfSkhtuT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2013-01-17 at 13:21 +0200, Artem Bityutskiy wrote:
> Probably this should also be outside of the driver, since it is not
> specific to this driver.

Take a look at this huge array which constantly gets updated with new
chips (see git log):

drivers/mtd/devices/m25p80.c
static const struct spi_device_id m25p_ids[]

I think this should be generalized and shared across the drivers.

--=20
Best Regards,
Artem Bityutskiy

--=-MYiRyFB5Pp5cZfSkhtuT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQ9+79AAoJECmIfjd9wqK0igIQAMo0fQu/pXNLAZOIxeOh7Llt
YwpMPSrDWAJSFzBtkkYSUPr5pXHi9n4vOQDdpiFOJJayr7KugmfTGR/T3WFlO73O
LTgIFDWs64U5A4+9t8Hpmn/Z0DOU4TXIQWCZRxNujGlJeqaNIAma7fBRrq+xRBxS
S2r0rmrRGBBI5asdMCZdZ+3FsQGFFsnLKFykmBweZY+zJiGgFGdfG5YmNvtApQEL
k8vj0hCLQnqoJ9lrOO9U/3QRYG6Z4RrjIFpb33VUDLLqbnQDJWMc05AUk5W2Zzrr
uogBCCnmTj1yqf/6pOMUjg1VowlKJbIwtUVDpEhZWxGvRCgfW+VU6ax+0qZD7p0v
tSaaJlyWXUpa1G4h9Y1sEVHfGdrD3xsiO7lQYETKvrLhkV84aIOzYlI5Bweaws2x
ywy2USGBc9JFjm+ZNows022BTtO9qncfsizIp4oeKUnRCQOOxYJruo5dEBrWkpzu
yYTOJ357W+ydUp79p0DkwmtrnPppx+E5ccvFq6FBEnXYwt6+60jAPcg4ZOZZ+ncE
+J6vy5FDM0HYO+C2J+7V/4Nv6cIfclojvn4nx/UjwWp+Xg/VjXPMU8fnXA1/qdO1
aTyZZHg3jti7zxtD3sQutWrCeAaSFhscFlLclDF3FUgKgOwOscqZ9DJgFtGD81kx
Rsieu5Ovkwm94c3J/3Jq
=ZhqR
-----END PGP SIGNATURE-----

--=-MYiRyFB5Pp5cZfSkhtuT--

