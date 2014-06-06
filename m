Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752455AbaFFHOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 03:14:41 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:52106 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752416AbaFFHOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 03:14:39 -0400
Date: Fri, 6 Jun 2014 09:11:49 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mikko Perttunen <mperttunen@nvidia.com>
Cc: Stephen Warren <swarren@wwwdotorg.org>, "tj@kernel.org" <tj@kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: [PATCH 0/9] Serial ATA support for NVIDIA Tegra124
Message-ID: <20140606071148.GC31915@ulmo>
References: <1401881559-18469-1-git-send-email-mperttunen@nvidia.com>
 <5390A8F9.2090408@wwwdotorg.org>
 <53915F3B.6050806@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JWEK1jqKZ6MHAcjA"
Content-Disposition: inline
In-Reply-To: <53915F3B.6050806@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JWEK1jqKZ6MHAcjA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 06, 2014 at 09:27:07AM +0300, Mikko Perttunen wrote:
> The only compile-time dependencies here should be that:
> - patch 8 of 9 which contains the actual driver depends on patch 6 of 9
> (though only when building as a module) and the efuse series
> - patch 2 of 9 refers to the DT node called "padctl", so it requires the
> xusb series. (in the submitted xusb series, the node isn't actually named,
> though. I will fix this in v2)

My intention was to add the label in the patch which first adds a
reference to the device. In my tree that was the PCIe driver. Given that
it's not clear yet in what order these will be merged, I'm thinking I
should simply add that fragment in the patch that adds the node since we
know that it will eventually be used.

Thierry

--JWEK1jqKZ6MHAcjA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTkWm0AAoJEN0jrNd/PrOhEq4QAKIkKsgZ33DM0zh4OOKmZee0
KJtAmvoZTXIsGUVjHY6aG3yREEr5kqYEtoAOpTA86hkIo9BBQLSoKvm4ODTyC72Y
gSc3X9GJZwBpKn3qq3a2xkLiR0e3+IrACYuYzH+4byFN+3NEQKgIbRLGNGsZ728E
D9CXjr/502W/AhNHqm72NtBpLUPalhA+zjBxDV6zktn9S1Tf3lj8aq279SasosWU
qZ443D6m+qhvwEDLuo9mmtegafkWZOpJFG7HBRUMW1/CJK4NmtJj9dnLCyzc+ETv
xhBQy2HZpXGqI4ALzpGRZUi+L3z9FbmEny4YTOCruhr/d3lk2q59esgy8B83n90B
DwqHXdJrWM3R8wXJKbasVfBjNoEVJnzj32Upwtv8n0qvssKO8wtq+9l9VQG5stlB
A4L/kJYpcXqBeGDINGRFOTFs+06QdsLcBSEeRikR3YFSSStUjRJtvVypypoIxECE
TbSI8QW6bbUPYeNtriQaQI8HqbsgqTYkCRSufyMzTJEUGsqrI0hd249lYbNj+3+E
+N4EclCiNlmnOdg/vhXCg1QGoxAek5vacOH6mw82gX1Mujux9/xwvLpmZs4+t0Qu
B8yJnfG4H2/YK6Fi/sAFflvnuj9WyIXkLtBKcXVJ+XGE2cFWqKfifFGqtuZkY+4a
tLQIFgbV1HuTmnHjn8Db
=DhbR
-----END PGP SIGNATURE-----

--JWEK1jqKZ6MHAcjA--
