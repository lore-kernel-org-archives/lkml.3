Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759333AbaCSKjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 06:39:37 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:47015 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759315AbaCSKje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 06:39:34 -0400
Date: Wed, 19 Mar 2014 10:39:29 +0000
From: Mark Brown <broonie@kernel.org>
To: Dylan Reid <dgreid@chromium.org>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20140319103929.GZ11706@sirena.org.uk>
References: <1395175509-19113-1-git-send-email-dgreid@chromium.org>
 <1395175509-19113-2-git-send-email-dgreid@chromium.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7dXNql6RdgxpnBKg"
Content-Disposition: inline
In-Reply-To: <1395175509-19113-2-git-send-email-dgreid@chromium.org>
X-Cookie: Turn the other cheek.
User-Agent: Mutt/1.5.22 (2013-10-16)
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH 2/2] regmap: cache: Don't attempt to sync non-writeable
 registers.
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7dXNql6RdgxpnBKg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 18, 2014 at 01:45:09PM -0700, Dylan Reid wrote:
> In the regcache_default_sync, if a register isn't writeable, then
> _regmap_write will return an error and the rest of the sync will be
> aborted.  Avoid this by checking if a register is writeable before
> trying to sync it.

Applied, thanks.

--7dXNql6RdgxpnBKg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTKXPeAAoJELSic+t+oim9IPAP/2Y3/dwjKVj38RV7d9/pfJc8
rsJkdlDnnGQ7KdaECcPc7v9C4gX5TIyn0AVYykHj7IQis9PQFxU+rjSsHtptVif0
u1UPrCD2K3U/+uK441Qu3Em8lwmJJ0RD11EhTpkp53f16h+6KXBrgjIxJ73B92P9
OY0+NPe70XpelHqWny1U9vPGgxQ9gyLjpGkjiKl8hOLq1m6IzrAS5iQSark3+G4w
eoBnwNVackLhxIhHVNqKyKT9vAAVyqwxkVgs+/f4pfu0+h3W0MC1aoSmRA+R4PpN
ZxQlbKOpuc2b26fd9wUG9ySGcYxyEIWKd01yN4DD7GltwmxVkL/gfg8fB9sd+K6J
x9TXMYPg4TomiAKl9qQs/x0GIhydFs26HMLRb5/79xT66a/70jiYcmaQDdL3fbWT
WvkejmFK/PB+TXbH4Q5uA0Wk33RSlQ0pdRy7XwnTVmS/kdpyAvyo64QsVahDINo1
T8LBzHHHYhMcoXo2F/uXhgxNdkxKtW1H5tHHi1RImEb9J2/ArH8tRPb7CwqOy53B
ESbso5sn8GgbdpgyS09+jvoe020STBVONOsQzx8nV8KhI51HtPrxTHTtOAOdB/3E
tj3TT5pS3I6Ybogera19vCeBkITip0CviONV9PksqItaN2GLkCanW0iCg69BTEVI
UMZ0YwMPDwO58zx72uT5
=nOqv
-----END PGP SIGNATURE-----

--7dXNql6RdgxpnBKg--
