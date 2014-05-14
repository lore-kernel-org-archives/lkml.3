Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbaENQHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 12:07:21 -0400
Received: from sauhun.de ([89.238.76.85]:40957 "EHLO pokefinder.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608AbaENQHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 12:07:18 -0400
Date: Wed, 14 May 2014 18:07:14 +0200
From: Wolfram Sang <wsa@the-dreams.de>
To: Andy Gross <agross@codeaurora.org>
Cc: linux-i2c@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] i2c: qup: Fix pm_runtime_get_sync usage
Message-ID: <20140514160714.GE12911@katana>
References: <1399082069-6666-1-git-send-email-agross@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ryJZkp9/svQ58syV"
Content-Disposition: inline
In-Reply-To: <1399082069-6666-1-git-send-email-agross@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ryJZkp9/svQ58syV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 02, 2014 at 08:54:29PM -0500, Andy Gross wrote:
> This patch corrects the error check on the call to pm_runtime_get_sync.
>=20
> Signed-off-by: Andy Gross <agross@codeaurora.org>

Applied to for-current, thanks!


--ryJZkp9/svQ58syV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJTc5SyAAoJEBQN5MwUoCm20O8QAIpN37oNf7hhucLYgB6WHoaG
4rqezYMo884A3Atx7RUF9yZLUJF1ayKxEjVdnDzcHQ113KJa9TEurhmShKVu9QlG
2GoPJPf3RYQuhIPwKc4VHlHaBogS+IrBQP2klJnvnaICDSFAz6VkZFGCKBSefR1z
p/Jj9+SOiQNNG1t7cCw/zfFqMdWuyrfShB8aB8RfUrplX/y8fIhDAKaiVkbPS1c5
DgQqtOWYOXwlZfQIk/zHiFxGDaBQagJOBXYUnHZ9eUQek9UrSiMPcdIlvFj6Byjx
ZtVxElJz8uSOGTX5tTVsXcyaAkIzJHcEVxcKmWMcAX0I2lvu2L4kW4kzYaEWQwRf
0zAFUBdpDo89L1l7ADSltmIT6/0xsuVbhQgp49LySiWNnRcIQ86GxvoWNh/EaKT8
5r6vh4MlOSGZm15oV5+nqpdzo1EjYUh0KGRa92bylfWAfwOk1qUKCbQTJjf9db3v
1PRMqQ3xEGDmAd/huh4ibZoOR5G1RNqlSyDxmQAkfGIfBHgRP1+6xdMU2sRmpCxQ
c5TlBvEwgFsTip8hEZYzaIQ62+OsX4tRUruhJq29N0GXiwDdlM9z5xqzYrLuTlBq
p+dpzV6SZ7+Rj2hTtyJDdzQQLVxZGD2JBpJbSEL8KLPU7gCK9jwB0biZUAErO2L5
VE2mQ2jgddzw8NwXOlvp
=xU3O
-----END PGP SIGNATURE-----

--ryJZkp9/svQ58syV--
