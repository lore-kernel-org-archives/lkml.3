Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab3DAMYq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:24:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52421 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753180Ab3DAMYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:24:45 -0400
Date: Mon, 1 Apr 2013 13:24:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 18/33] regulator: ab8500: Use
 regulator_list_voltage_table()
Message-ID: <20130401122440.GE18636@opensource.wolfsonmicro.com>
References: <1364487093-19551-1-git-send-email-lee.jones@linaro.org>
 <1364487093-19551-19-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Yb+qhiCg54lqZFXW"
Content-Disposition: inline
In-Reply-To: <1364487093-19551-19-git-send-email-lee.jones@linaro.org>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Yb+qhiCg54lqZFXW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 28, 2013 at 04:11:18PM +0000, Lee Jones wrote:
> Following a recent move to regulator_list_voltage_table() for
> all previous abx500 related platforms this converts all recent
> platform updates over too.

Applied everything up to here except "regulator: ab8500-ext: Add support
for AB9540 regulators", thanks.

--Yb+qhiCg54lqZFXW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRWXx3AAoJELSic+t+oim9cXwP/2T0iVNJ1IrG0Gzanfos3yDt
j5xZeakliiqiquIlaWXBNYm+Xdlq/QgFiXjH6qi91q2xECSya1edB3J5nUpTWqFj
0YNP+gDCz1DAW76CIW3sZNNhJ4ZFZ2WbjayGcoTVb7ZHqmEY/mU/lvKwPj9NJQfR
YYHvilpVlmjrNLvFi2LHbE9r4/WVoxBKtmGJ+6o9Bnd6TGSPudPHDTS05XRQzFpC
74KNwbdHo1x22HkgFdK0VbiHZ/64+JGAR1mgIO/qiv4UASq+EU6X1l9eHqiQJJvd
CdKKB48XPBjxaLWfYbbPDtWy9YKtD1VmQtk3DTLk1gWHitFmB6zgxUZH7ulu8A88
h00M5lJ8pJaOTXWypvydu9MUfxNpJdTIrDCydCevxUktpoXEohTBjZHnjEMVe3ej
91DQ8ZqRU0D4Zg5JLLFlCr+YxpuuJ5iW4bvzshqsxMFX/Ya0rbWj2XzERxXSVdRy
cmZ/GdaQhNZoAvqv6We6pZdew21T+F45tlFVDq4hnjX65LewfkzXjiSIQU5rv/B4
VoAnvdjJxyjzrUpfvqBkO2vobW7bC4gs0CjJC1iw3kE4/dWZUpXmqjYAYHr9lbWf
Ls7w5DeJx1zf6xRTQ9OSZN9FPlMMqcMldv6WAPdFCsoG5UGUWu9kdySCjA8M6DjQ
OpcRDVOf8h6+hoTjX0ls
=5CZo
-----END PGP SIGNATURE-----

--Yb+qhiCg54lqZFXW--
