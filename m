Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3C1ALU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 20:11:20 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41829 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754323Ab3C1ALT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 20:11:19 -0400
Date: Thu, 28 Mar 2013 00:11:17 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 18/46] regulator: ab8500: Clean out SoC registers
Message-ID: <20130328001117.GM18316@opensource.wolfsonmicro.com>
References: <1363881583-15234-1-git-send-email-lee.jones@linaro.org>
 <1363881583-15234-19-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QlMGl5G66NJfRa6E"
Content-Disposition: inline
In-Reply-To: <1363881583-15234-19-git-send-email-lee.jones@linaro.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QlMGl5G66NJfRa6E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 21, 2013 at 03:59:15PM +0000, Lee Jones wrote:
> Clean out initialisation that is handled by SoC. Regulator
> settings for Vpll (partly), Vsmps1, Vsmps2, Vsmps3 (partly),
> Vrf1, Varm, Vape, Vbb, Vmod are cleaned out. They should not
> be touched by the kernel.

Applied, thanks.

--QlMGl5G66NJfRa6E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRU4qeAAoJELSic+t+oim9BdYP/3OvMUjh3D2bb6RBZiAp42YP
OREi+MuWbuYQ+E+Nfz0t4cauHQnHqQqqXWE3ZzkxWEyEED7ZBoWsw16XnhGNE1P8
KVmZRVesqxQc5jCgOuafyM18tJTc/pPq8mdZ8hiV+eVOJV2fDhxfGZCK4ie6iI86
4OViMezEX6ntOOntc/Wn+Lo2soWpprOLCCWAt5+oVBLyOw7S4wrUGiyJza+Aa//8
rRQgzrncEb+hF7nbIe/K/WsGReFOIbNQCQtEeoaghrDQPsKcM66w/98STe76t430
tzhgqaOzN6n4dBtfoH3bq5RKzn6nz10fCsVeN5NfjGwabK0OyS78C+kUOeDc5T7I
Juef2d3OWFEewJhYwgIsVOKy3VUiDtcKOsNWJ26CJ27D7I53vEBoLzT4E7e+i0gU
fK39VE5H4Ig+ls1+08VCX8F4+yk0YdE+6jKdmy+eoXZiDURZxBbBJ02yWzwzWmSt
Zo1bIr3XYqawkF9uU9DvRry3y7jyMC/5XAMEhisX27UaBZwm171ckWajUSAX3NA0
4ZBBQmuRtUZrIw3Yv3bXM+Vk3MGQVzmRxbc0enEf1UBLM7cSoxA8jZwffK9RQpFS
XlYc45MD+o/SYWuUhzqjMXDgJ60BNioFzM3CFkMLNPR37GOcdvoGHcWbNGzshXpA
eM9MAZ++ITJ7V5YAXwX7
=gvox
-----END PGP SIGNATURE-----

--QlMGl5G66NJfRa6E--
