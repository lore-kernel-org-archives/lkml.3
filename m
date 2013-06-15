Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3FOLQ1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jun 2013 07:16:27 -0400
Received: from sauhun.de ([89.238.76.85]:38241 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753661Ab3FOLQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jun 2013 07:16:25 -0400
Date: Sat, 15 Jun 2013 13:18:17 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Tony Prisk <linux@prisktech.co.nz>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] i2c: vt8500: Add support for I2C bus on Wondermedia
 SoCs
Message-ID: <20130615111817.GA2938@katana>
References: <1371246736-5460-1-git-send-email-linux@prisktech.co.nz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WIyZ46R2i8wDzkSu"
Content-Disposition: inline
In-Reply-To: <1371246736-5460-1-git-send-email-linux@prisktech.co.nz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--WIyZ46R2i8wDzkSu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 15, 2013 at 09:52:16AM +1200, Tony Prisk wrote:
> This patch adds support for the I2C bus controllers found on Wondermedia
> 8xxx-series SoCs. Only master-mode is supported.
>=20
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---

=2E..

> +/* REG_TR */
> +#define SCL_TIMEOUT(x)		(((x) & 0xFF) << 16)

I assume this should be << 8 since all regs are 16 bit wide.

Fixed it locally and ready to apply. Please confirm or send a proper
fix. Rest looks fine.

Thanks for the submission!


--WIyZ46R2i8wDzkSu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRvE15AAoJEBQN5MwUoCm2vskP/0atjG5GaYROyNQTQCETUIEt
W1k6UaadDxequLaNPABfQHo542/fU/x43t/gt9WTm13oujyMs1S10FwE8mev0zQ9
ZxbKfhjOerk9Ku2OE5+5LPdIHNYQajnKGOT4QmooGn59LMDVNcXM+9lBVRTilE9K
FxzEuPUirEwSrxv+E34JujEWWm3x7iXnUcrgDgfFAZiqlzqQc7Vrx1mYtMj1TWYE
9z+eW7j6pV9YkVnaL+wSsVq9zbKcs0zOsJHCwI7QYwPZYxfHJkSFQeDcJrJu5bdE
7IrHLMUZAYySyeOTn3wb9n42ShE4LWYi/DXhZh6Y6KfSFSNgdVtAFsQZSdWKcpZS
g7T0ZwAm9YO4LRBWnaCapd6crsLYAqClGSIWifjl7jTTQM60PK44CSGuIXq92aQ7
zuyFhZCNXPsmOr/sv56Wsek6gcmbpze5oveo2WEygHwcXAE6rPESgeb0DTXPHv9r
2aEoUGILnTxlHDtlm++ryVBBIkLdA2YWK09+Ek6q2DuqYe4eeZNmJcl8OeuScjm9
4VfPBP9RtWr+MYIrrjzMTk3o6hcpJEFiQ98Env89V9tw1RSxTHC73qUPMaJ6poRp
4pJ5pbmfzQ7LXqsb6Ba7BfJBUip7pMdigoiCP7erpvCuJuWMgHoECdRjW7+W5NE6
1gMGPvvAjtw/xDAmZOfX
=0+j6
-----END PGP SIGNATURE-----

--WIyZ46R2i8wDzkSu--
