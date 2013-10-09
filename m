Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756340Ab3JISBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 14:01:46 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:39080 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912Ab3JISBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 14:01:45 -0400
Date: Wed, 9 Oct 2013 19:01:17 +0100
From: Mark Brown <broonie@kernel.org>
To: Illia Smyrnov <illia.smyrnov@globallogic.com>
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, Illia Smyrnov <illia.smyrnov@ti.com>
Message-ID: <20131009180117.GW21581@sirena.org.uk>
References: <1381320308-25258-1-git-send-email-illia.smyrnov@globallogic.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eWRR3l8InVf/JbgT"
Content-Disposition: inline
In-Reply-To: <1381320308-25258-1-git-send-email-illia.smyrnov@globallogic.com>
X-Cookie: Penalty for private use.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 94.175.92.69
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] spi: omap2-mcspi: Fix FIFO support for
 transmit-and-receive mode
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eWRR3l8InVf/JbgT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Oct 09, 2013 at 03:05:08PM +0300, Illia Smyrnov wrote:
> This patch fixes MCSPI FIFO buffer support when transmit-and-receive
> (full duplex) mode is used. In this mode FIFO can be used for RX or
> for TX or for both directions. If FIFO used for both directions the buffer
> is split into two 32-byte buffers - one for each direction.
> Also for full duplex mode both AEL and AFL need to be set in CHCONF0 register.

Applied, thanks.

--eWRR3l8InVf/JbgT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSVZnqAAoJELSic+t+oim918IP/0o7mGWvYB8WJh3fqBX6he+c
xCOV1ZbgDWGSA6FqKbbu5lPDr1sesdAzJpWPjz5jd0npXZlbwL1zWXic6/SWTN+S
Su8McF+0ivTm96fUZOfqWjuHAVtDOuGS+dxhJZL/I3IdWqLO5J9YbVi4b83KW4z5
LPYW9vDmXqE7fa9DPG1lXTjkPTM1faDVGm8VqwXRJGcsx3JUfnmbyF05UC/IHZMN
COIm6A8dqBtS3KXB5lQ7yYgKyv3NR1TSTu8jbnhoM4zHePDXWR1O/X+4BgX/UmLy
fuHQncBWerXro4fyK4VQeYThqlcO7OI0pqEFBF8O1KqL8J8PsgiPc868Kw+e0cvx
l+PnrPoWMOvBy3ww+bMf62Z5xPHMoqFbWen6lCNhFs9qs4B1adr9HRwlgVpFOOkQ
KTbbv0+NbB/T7iExd11djIwhJK7dts3FyY0KM+7aGi1xpIiz4Ecx2a9GYgGDuxdb
dTbShpRPuNVdLvaBGyiYk0VoNYDE100SKO9BikxevaBr2mHqgSk1Z9U+Mz4i1Jv9
UZh4DedXqSPOo013bInhaYnJoiqtKymbXaUSJvfzikvqZd0bPoYS0riaq1TEPc6A
hZ2Q8aJiJ89IuPuyEDz7/kpiM+s6P0ISx8ZvJglYbkWPCH56IC6ZGwL4OzvWEwy/
soIQ5aeSMUTYTYFoIWIK
=H9Mq
-----END PGP SIGNATURE-----

--eWRR3l8InVf/JbgT--
