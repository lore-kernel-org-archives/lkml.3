Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933321Ab3CLTIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 15:08:01 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35147 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932439Ab3CLTH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 15:07:59 -0400
Date: Tue, 12 Mar 2013 19:07:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, swarren@wwwdotorg.org,
        spi-devel-general@lists.sourceforge.net, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: slink-tegra20: move runtime pm calls to
 transfer_one_message
Message-ID: <20130312190756.GB19942@opensource.wolfsonmicro.com>
References: <1362723679-1155-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sZvnRN25x3w09J/6"
Content-Disposition: inline
In-Reply-To: <1362723679-1155-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sZvnRN25x3w09J/6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Mar 08, 2013 at 11:51:19AM +0530, Laxman Dewangan wrote:
> The prepare_transfer_hardware() is called in atomic context and
> calling synchronous runtime pm calls can create scheduling deadlock.

Applied, thanks.

--sZvnRN25x3w09J/6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRP30FAAoJELSic+t+oim9TWEP/3VVKHnywO7dQ2QXGd/lmQw2
czvndLWLIeiEHzd8uDZLAcUeVln9xBCYYTHpHo84U8K8PeVROixo7LgYtt6qPNfx
hKtXqlDg/DPipkrWFlqOAIY2KWSdqDeGNsrcTpM11ei5vTzb+sZ268bWV9xBNaOj
WONQMCL6qWYQY2keMNBa1v54CLgEwEmA/XwW4Mwov5f+8rMEglftSEqogczR1ak6
0a5g+eYGzcsm4zCqbbTIw7jk5hEpN7RkYgpT+9t5cAd3UVpLaIp7biyHjRWaqBZx
CHiF8IYGTM1lR91t1tSQorxvF/aZyz8SwTzrI4GPD1ki66MTUPrVscDkHTQ1j6Zy
d+CcYHC2kfjRmbAQ+MZ0ZBTZrSfOEK1xovgPwpd7NfL/ptHWjaBW3CNOetNLCdlu
SrsenMeeHAmFjbWu+EMyGDgxCN8kPUDiGHblnLL95g6L53CmAbOYlhECYmR6tVYA
FEePkNIhpAbgPnrs/guPckzkYnTTQUM0kEo5FkpPXnxK6qokcF6v/UY3qrNw3sGQ
mP3DsVec/ukRV9FU5yuzA4YG/sEq5ifAl6DLk8DVqbRzHZu1PB7orJpxXmg+jsEw
f9j1aMJmD+H2Tbb60xfkPFoamZvQBAoWdaghXJCZ83rjhiwmbTElr3KmJ3QOyt83
BPHH6oQoEYuw6mLQdhW4
=eNTy
-----END PGP SIGNATURE-----

--sZvnRN25x3w09J/6--
