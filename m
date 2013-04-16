Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab3DPLYH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Apr 2013 07:24:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32827 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752346Ab3DPLYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Apr 2013 07:24:05 -0400
Date: Tue, 16 Apr 2013 12:24:01 +0100
From: Mark Brown <broonie@kernel.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT 2/2] regulator: ab8500: Optimize
 ab8540_aux3_regulator_get_voltage_sel
Message-ID: <20130416112401.GF26958@opensource.wolfsonmicro.com>
References: <1365576052.4283.2.camel@phoenix>
 <1365576380.4283.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/aVve/J9H4Wl5yVO"
Content-Disposition: inline
In-Reply-To: <1365576380.4283.5.camel@phoenix>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/aVve/J9H4Wl5yVO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 10, 2013 at 02:46:20PM +0800, Axel Lin wrote:
> We can save a register read operation in some case if read
> expand_register first.
> If info->expand_register.voltage_mask bit is set, no need to read
> voltage_reg.

Applied, thanks.

--/aVve/J9H4Wl5yVO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbTTKAAoJELSic+t+oim9O80P/384Dav3RRZdon+6XIF1JCtP
lBE71mjjj+Mqo3pj4Zf7y+FoOBKJ7t9EeaDyxiBygTAZR7a0oxhElodFVJVsw1Da
7mjR8JO0U0eBanSWh3ZNDuHFWSsLMZ51fob1mfxNG6jKh80dopqmfGKlPNrTWq8A
+3nJC+GWwLnss+Phh4EKL05Yh9inevcyJ06lsHeIwP5VC8gBzgUwuPl421dRMlB6
VI4dC+UAGod7p1g+jopsiSDUDyuYvp1QJqMJhitZrjpaIf3S9oFiV3Rlt2NXNSkV
sHVL2Pp5xLHQL6QY2vweCN4JZgMrbt4Fkncvx/HYTg9XNOhYPeecyAmpbKfnI5b/
EVuABxDdFeaJcZwIc7E9UJLDY+hQGUP779K/71GG1IV5DcTn5/TvrIPYEH2PL75i
SXuVHt7yh8VIKuTd5dLxycQPPBRXqRJkF1ESlJ8EWCvxhO0GJ4WqA2YTo2A0+KGt
3FApxdMUcOj/oMFIESJe5ZP4a8K1urSoaFG87Sqe+xEHl6aLUL2NeoqSuCFzIkfl
5TPf5k7b5iMKzKfjsV05cIFPo1I797n7OUCEDeHaxmrqFI+7nQqa2WsQaRAzvLDp
XGrsMTfvoK1XIqU0la3Rvad1jHUajdpZY94vxekrppaDj9YwDcJo90mnBOq6O8f0
I6ammm8MbOUS5EpdVwlB
=cVpQ
-----END PGP SIGNATURE-----

--/aVve/J9H4Wl5yVO--
