Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380Ab3CJWwb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 18:52:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:52506 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab3CJWw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 18:52:29 -0400
Date: Sun, 10 Mar 2013 23:51:50 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: akpm@linux-foundation.org, a.zummo@towertech.it, swarren@wwwdotorg.org,
        rtc-linux@googlegroups.com, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] rtc: tegra: use managed rtc_device_register
Message-ID: <20130310225150.GJ4743@avionic-0098.mockup.avionic-design.de>
References: <1362852816-13460-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pMCBjikF2xGw87uL"
Content-Disposition: inline
In-Reply-To: <1362852816-13460-1-git-send-email-ldewangan@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:8ZmLNVl7IC4keygNXPGq8GNKLasLtcPkmICfe8n21g/
 eF/4xxqxajCSoRe7XwNQcUw9ej//DvShDkzA5UpFgJHKSLA05o
 3uHC8nZGHj8KsPF6991UFf5ZC0V7y/eZ3V9h8M4qiQq1cXXJ14
 uRXD6bLfffr2Eah9c/pHpYNlGEtPq0y7UemNq8/WnqH+DoA1xO
 GgPkCK+RJkLwV9GmbrKcEwiZEm8QbPPToh0SpkGUWtIP9QYVpc
 ITX2j1Et9JnN9NaL3bUqVbDPNTI0tdUKfwF9W9VrdXYPFyWvXy
 o7mKzHwchbIOnDrB4OYcgD5ZnnI/lW2iSuV33znZ2YLgbvjEwr
 hEog66KpcAjgJD3CqNRJEVQr7IkctfW88PeTROXMYmZaqREJJ3
 6JcqUzFgONTOYDLriIl9htpA7slJ+ZEMk2zrlgTrKG0fp7FHuV
 6eLIY
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pMCBjikF2xGw87uL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Mar 09, 2013 at 11:43:36PM +0530, Laxman Dewangan wrote:
> Use devm_rtc_device_register for registering rtc device.
> This will reduce the code for unregistering rtc device in
> cleanup path and remove the implementation of remove
> callback of platform driver.

And RTC is also an abbreviation. =)

Thierry

--pMCBjikF2xGw87uL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJRPQ6GAAoJEN0jrNd/PrOhcjkQAJmyMum2G2cts+CbdQ+srVsP
wvbvRaBtnmDMXOJlrqpSIq+gPVf00rjaxzgArN60XWx8AKuFme5e7/UybSRH2/qE
EfEER8RDyy01rBhOKcGoOpSyu162/Ed4cGPgbFqPauiKcqEd3hte8SNUsEInRZP4
atmdwTqLab0DQjkBWFSkHcKY5HDmGz+8dIRzBhulwX+wU+/egEfPBhJ6L/GlObFt
uiYwot0VvkXEAq/9gBrFzmU+YEAhalfoImASebSYzJ80/wwWtwyhiPo5l87bhYHN
I7diOIi5re5O57u3Nny11/sNwLIS6/FSSgusB/pLIU5kMwjAvmlnJ//OQOhcqKO/
zHW2XiiXTP8WoMBmmgu3oljVowYG34l7neoLbwOmYOBWwiTeFVSryZIFhoRDHI63
KfpWNv6KTYyhkNbzxLoff/jOHQlOOK1t3bo29Voe3gbVtN+edM7YvYPuhctgqPp9
L76+Y1FIKJKszi3GnEB5MLLeKoZ/A6BZOwyxLADg2FDrNfaktMUYv4uBLh06YCfl
OgpXbwvjiz1qKPqx+3bZ/UuMaCzphZvr+SdnXSIRvbiT78BTWwhGOINrYt/s4NE/
f7jHT1xqMAYkzueF01/VKn8nOBTmC8yy/N+5UcyFvDtiIo+ZfLPuVyAYu0uTiUqo
ukME93ULj+GkxVAqL9Hd
=M2s7
-----END PGP SIGNATURE-----

--pMCBjikF2xGw87uL--
