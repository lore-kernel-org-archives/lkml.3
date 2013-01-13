Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768Ab3AMMD3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 07:03:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37265 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754628Ab3AMMD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 07:03:28 -0500
Date: Sun, 13 Jan 2013 21:03:18 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrey Smirnov <andrew.smirnov@gmail.com>
Cc: andrey.smirnov@convergeddevices.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] [regmap] [RESEND] Add "no-bus" configuration for
 regmap API
Message-ID: <20130113120316.GA5041@opensource.wolfsonmicro.com>
References: <1358024054-9895-1-git-send-email-andrew.smirnov@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
Content-Disposition: inline
In-Reply-To: <1358024054-9895-1-git-send-email-andrew.smirnov@gmail.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Jan 12, 2013 at 12:54:11PM -0800, Andrey Smirnov wrote:
> Second version of the initial patchset(can be found here:
> https://lkml.org/lkml/2012/12/21/98)

Please do use subject lines appropriate for the subsystem - in general,
if your commit logs look different to others for the same subsystem
there's probably an issue.  Not doing this makes it easier for things to
get missed.  Here you want "regmap: "...

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ8qJ8AAoJELSic+t+oim92m8P/2O1L0lxlXNxges1jQTEx/HQ
DQrajEckn8NnW+ZeGXNuEz4CfQgjq+ryI9nneGvMZl+le+rgKj45ZaKyvDPTK3oK
rQd+Hgz6LAQfhwpiPiNmhc5i/8bD2tD5SLeB9+bwIjrl2tRig2nUO+dKx9lRHMCo
FJw6KaWt+ENP9t0d0pr+Ys9lQwZVu0WV0amEjVwOQM6rFXgd8KSdiJ26UamoQmod
/oJzlxILWc515ZvfsPP4eeWA+8X1xbNO0wp+V4POQO5jo6JQAZLTFXD50MhHd0My
3myBXEcYAlDbRbe+zynkwmQv7qcTluPQxo/zoFU+0j7ijvUihlECERMsrZZBWlRy
vxbt0Z0cSn7KQWN//Q5+BpvH0kfWt36q2jAnNPEh2sZuFPR9XidvqStA0OuYA5sa
cTRIkYukGJbAQuLzx0DMdSx86hIIJBCamZJZ2qqFK6jQ7IA2AUXa0VW+0qnD6EOn
zsk72Zx7jr69HDTSQDA3ox/nmXanW7TFCR3DJCVHP2HDy3ztyOR0Jh2EEU2aPc86
IeA699a/ehgUbpmPeUD73+udwWR13935zUrGewudM//l3KDvK7DNTO33NrZpd+jX
69nZetgUf3WcoXLbg9P5JcKYhwmUTClrPv/77kqG+l9F/3KCE1H2bk4ZMT/m0ABv
qR6vu9c+s7BxSIG/DHEK
=OJ1h
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
