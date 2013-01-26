Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000Ab3AZI6V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 03:58:21 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58420 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752933Ab3AZI6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 03:58:19 -0500
Date: Sat, 26 Jan 2013 16:58:12 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Axel Lin <axel.lin@ingics.com>, stable@vger.kernel.org
Subject: Re: [PATCH] regulators: max8998: fix incorrect min_uV value for ldo10
Message-ID: <20130126085810.GD30594@opensource.wolfsonmicro.com>
References: <1359102341-22321-1-git-send-email-m.szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PHCdUe6m4AxPMzOu"
Content-Disposition: inline
In-Reply-To: <1359102341-22321-1-git-send-email-m.szyprowski@samsung.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PHCdUe6m4AxPMzOu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jan 25, 2013 at 09:25:40AM +0100, Marek Szyprowski wrote:
> Correct value for minimal voltage for ldo10 output is 950000 uV. This
> patch fixes the typo introduced by patch adf6178ad5552a7f2f742a8c85343c50
> ("regulator: max8998: Use uV in voltage_map_desc"), what solves broken
> probe of max8998 in v3.8-rc4.

Applied, thanks.

--PHCdUe6m4AxPMzOu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRA5qaAAoJELSic+t+oim95LgP/jG3gC2A8AATDmCD8couXQZN
CdSk/YAHYHWD7yVcQ4oZzYbAcIsxPM9Eh68pqs73XwufVkWbIJdhZl1XENwZs8jk
Cc7YpPHCwjBDkqT3igYW1VQxUFN9kP1wuO4Gef/zTG7UfzPDlB57qThz4w/9VA6P
JJTt4wjYBvP8lNDcLv+ey1xyz7DAPtkckyCltMI8gDFYYIrIH89ntvlJzVI6LYBl
t7vdDg1BNnceYYjgXSSW6Dd9NlrVJBerQHtQoGC028yUNlN3cxhyNhqG1lzPFDv0
1buwnRoO43DKx1hTsTbuzJyFoPzClI/XvMo3t1zvLvcM9wVflonTGZ7bABFyMwyg
QMRdeYGOx+AYzk8EA65nfPlZs+YaHpyGz0yOCCMXS9XkRx9TXZWmwzI3G8IN4Zui
fNDGy/DcAiVCvlYOFrHW0oT57uWUg9ci0jydNbEdIQCUP2sVuZurZKnmUg3AFtkb
vIliNr4NvcSPo0iVkuP+ShF58jqcZymCVfSTtFockM2DRC1UwUH8mxo/rMl60IhC
A3AzlUkAV2PKtJdXJVUmQWNvluLthQpKifubl6fGRHsYyVAmn/uhszXuvV9OJYRT
6vM8dqAD57cz6ZHqJvmH3Gg65Y4fJwR9TB+b97dUiMmapn4hMR4Rl49MydiK6Li3
lsJ3MlMoqqMoNYnTn7Wt
=dhI5
-----END PGP SIGNATURE-----

--PHCdUe6m4AxPMzOu--
