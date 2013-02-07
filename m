Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161141Ab3BGSvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:51:52 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40342 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161087Ab3BGSvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:51:51 -0500
Date: Thu, 7 Feb 2013 18:51:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org, linus.walleij@linaro.org
Subject: Re: [PATCH 05/49] ARM: ux500: regulators: Add mask for configuration
Message-ID: <20130207185125.GD8879@opensource.wolfsonmicro.com>
References: <1360148051-7560-1-git-send-email-lee.jones@linaro.org>
 <1360148051-7560-6-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ieNMXl1Fr3cevapt"
Content-Disposition: inline
In-Reply-To: <1360148051-7560-6-git-send-email-lee.jones@linaro.org>
X-Cookie: Stay away from flying saucers today.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ieNMXl1Fr3cevapt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 06, 2013 at 10:53:27AM +0000, Lee Jones wrote:
> There is already before a register mask in the regulator driver
> to allow some bits of a register to be initialized. The register
> value is defined in the board configuration. This patch puts a
> mask in the board configuration to specify which bits should
> actually be altered. The purpose with this patch is to avoid
> future mistakes when updating the allowed bits in the regulator
> driver.

This looks fine but I'll wait for Linus (plus I suspect it depends on
patch 1).  Stopped now due to this.

--ieNMXl1Fr3cevapt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRE/elAAoJELSic+t+oim9qoQP/2mjwb4D+A5kVJHUlWJ0PDne
iYgMISQzKtve7MG7c2qqweTu7iYKy7c0XoNPmnJykeKAxbzJHYp8hikxpaxjV6yX
GwpkS9i9AoJQGS279vaVuhaKtbkPSgFsyvwbeq/n0IfDB8j3j44eYvfTTOmA8gZt
CFe3eaxOcYFNUg6J4PR95QTLS3oZxaut3fFZQ5L6JIo5ZmG4pAJrSuxIYrt9xnb5
xhIQzIidPbQbX0ysCW2aF/XAI4cD1hPok/Oj6Yjee63DriUf2yZR/4CIuz0DMVWX
lEBjrAUIyTAsmh5Kr9aQULVBkk0AIp3lhTHcscJqXN3IGvfb9gMgfHBHcgz3jke/
Q9GBBkD0PTWNXiTVJ0xo4VFG2eFVNkEvBd371f77qzWAlq1FxKxeYORMp4Uemwes
m0t0KX6lyfrt0tn5qpoTd6yavJIhjG/ScIPcGFajXlDHRYaOiuyzN7Am56mJmlMM
cd3MdeQkD319S0f7baUOw37j+7bLYaft8T/UGOD8Di/BL82j2u/myq3PFkEDOWe7
/GSw8THirI2AUtV3sI0yuqGRFrB5qQEJpr7yVBpGZTELW7DZPTtAnjwyPjmge/xv
OBug+qj34c5ojGOr7Qqnc7WzLQB8sa/hSyp+R05jvlthLCsky5F0dUcCwnkLFD4X
7mHkVWEtH3Z6ltlnLhM0
=/M/M
-----END PGP SIGNATURE-----

--ieNMXl1Fr3cevapt--
