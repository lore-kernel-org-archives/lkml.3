Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755357Ab3DOQZh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:25:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50048 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754692Ab3DOQZg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:25:36 -0400
Date: Mon, 15 Apr 2013 17:25:34 +0100
From: Mark Brown <broonie@kernel.org>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: johannes@sipsolutions.net, backports@vger.kernel.org,
        Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] backports: add support for voltage / current
 regulator drivers
Message-ID: <20130415162534.GJ15837@opensource.wolfsonmicro.com>
References: <1365862424-6530-1-git-send-email-mcgrof@do-not-panic.com>
 <1365862424-6530-6-git-send-email-mcgrof@do-not-panic.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvznHscUikHnwW2p"
Content-Disposition: inline
In-Reply-To: <1365862424-6530-6-git-send-email-mcgrof@do-not-panic.com>
X-Cookie: Be careful!  Is it classified?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GvznHscUikHnwW2p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Apr 13, 2013 at 07:13:42AM -0700, Luis R. Rodriguez wrote:

> This backports the latest regulator drivers for kernels >= 3.4.
> We enable the regulator only on kernels >= 3.4 given that
> it relies on the new probe deferral mechanism which would
> otherwise mean having to support drivers that do not probe

There's no great reliance on deferred probes here...

> correctly. Note that 3.2 had a base regulator implementation
> but that was just stubs.

I'm sorry, what on earth makes you say that?  The regulator API has been
usefully functional since it was merged.

> I did look into a way to upgrade the core kernel regulator
> but given that it relies on late_initcall() and core_initcall()
> we can't update this part of the kernel. I even looked at
> using ksplice for this but it seems ksplice can't be used to
> update init sections on the vmlinux ELF. I also haven't much
> updates to these routines since 3.4 except for 86f5fcfc.

Again I'm not sure what you're talking about here?

--GvznHscUikHnwW2p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRbCn3AAoJELSic+t+oim9+qkP/0W3MBZi09P5qFnlIeelwukI
QdMOG9LnefbhBY6/YJgUkuDnUp8J1MSB8K72c4FXgyNBpOsr2o7oDi9UfBf82YF/
VRpk10wRxLvlU94niqGUbTW+7ZjYuu/pHw2Nel6eQiEfLTiSXhpRSCeP+0jKrbx0
MABnjDEDmO/Mau28mS07D6dPMtI8m8fqumHy/CWxPdNp6F8H3SI+K7XejUIsQRuM
tzzttXsgy7ZT+hzkctvbVv4Ee3eIUtqbHNXaFqxxIcLUgfEvq/QUA5luBgtLuc6B
9nitTdBXGdByTYow4qiKlAS+g90baxPp+FeCRVaZtQ77DDTjlR4PfzNynEFfdlKR
B97itdWW4bZivA48N8Km+HXzgRFiH7Zn5SdtrXjPDrXLNyueqK9QOY7CpNyWYL+h
F8uZWe8wg5zWBTT4IV2fHeJFllzy8kRaTG1GBM6DDC3SJJA2Bh6UzKrNhLrnjZfQ
7VRgDuV0I8GNVtbkyZdLlgUAUmtcXYemIVCIObAe6UP8U38G1NrEjdUBpiS66FQq
4SVLG6jTNJBBnq33dMIN3Uanm/E9WG31DkETEMZfludEca8k+pU/TUGgsxh9ns6I
BR8qh5L1KAEel3CERW8iWmXOZpMKuvI0O1d2TjCfW2wydauZvPG5CHeksPSRF4Sd
AWzcvPE0JUkAWjXSFqlH
=xgsb
-----END PGP SIGNATURE-----

--GvznHscUikHnwW2p--
