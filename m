Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab3C2Ruw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 13:50:52 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45428 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756670Ab3C2Ruv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 13:50:51 -0400
Date: Fri, 29 Mar 2013 17:50:49 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/33] regulator: ab8500: Init debug from regulator driver
Message-ID: <20130329175049.GI18316@opensource.wolfsonmicro.com>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
 <1364487093-19551-10-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+p4NvxO1ICbi3VNc"
Content-Disposition: inline
In-Reply-To: <1364487093-19551-10-git-send-email-lee.jones@linaro.org>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+p4NvxO1ICbi3VNc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 28, 2013 at 04:11:09PM +0000, Lee Jones wrote:
> The purpose of this patch is to guarantee that ab8500-debug will
> record the regulator registers before they are modified by the
> ab8500 regulator driver.

Applied, thanks.

--+p4NvxO1ICbi3VNc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRVdRxAAoJELSic+t+oim98lsQAJIl4sVaYJQP6A61qs/y9oZ/
C2XHAS44xnrf/07Y7sysbaB00aCqNIweBPdnJFb9zkeWIO4BuoMGdEMcqkOrBXlG
jTMFaZvr7W2T9M0QprzLbzYcB3J7E4wyupJ2grDDpMyp9yhMN94rVsPEM8qSbdw9
fVJmQVI++nzM6PJny42l+ZOjQrSMGY96T2kiYOr2pnEy1P7ekxpOyKJbop9QQbLV
4sCSFqX/loTgk0C2z0bDCK150/PAS6fHFLNSSak3TOlwxz4xGYpNWsM1M82Y97rJ
MOx9wV2icHuap7i2/DG1H68x4Do2SVr/Z4YmSXnKqAkWoH1WFTyay248TcBMsica
KOHbuPXWhFA4JJDCAWFhXkABRI/5IsQxMFrBw8M7iCISDrHaXA01zvO3gwLBnNT3
FA3wFGexE6hTW0gJFDxIn6AMX/GXw9EWA8oQiC9Do8TWgdcntRDBHDHcyzwK5bXG
fMb6zlCalxlT5glH/KKYRDcpYFQ+/058elJfSY4VzeP1kFLzX+8DXkfQ5e9g0yA5
y0FtoqbjUg4zFPOs7rwhtkXUXN7KSy/Dvgwmf6L0tLrYXoWQEBlb3xyf9trKa74d
bgzyM6Rsr0zNXxKNvm8fpil8muHcERroDegMZhHNt9KySwRnChn5m6w//vBzJViR
m8HnySL5KiXpnbWBbt2A
=07v9
-----END PGP SIGNATURE-----

--+p4NvxO1ICbi3VNc--
