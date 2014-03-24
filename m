Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864AbaCXXLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 19:11:52 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:55908 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaCXXLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 19:11:50 -0400
Date: Tue, 25 Mar 2014 00:11:46 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Alexandre Courbot <acourbot@nvidia.com>
Cc: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, gnurou@gmail.com
Subject: Re: [PATCH 12/12] drm/nouveau: support for probing GK20A
Message-ID: <20140324231144.GJ17218@mithrandir>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
 <1395650554-31925-13-git-send-email-acourbot@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ibvzjYYg+QDzMCy1"
Content-Disposition: inline
In-Reply-To: <1395650554-31925-13-git-send-email-acourbot@nvidia.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ibvzjYYg+QDzMCy1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 24, 2014 at 05:42:34PM +0900, Alexandre Courbot wrote:
[...]
> diff --git a/drivers/gpu/drm/nouveau/core/engine/device/nve0.c b/drivers/gpu/drm/nouveau/core/engine/device/nve0.c
[...]
> +		/* TODO will need an implementation for this at some point... */

Do we? If so the commit message in 11/12 is misleading.

Thierry

--ibvzjYYg+QDzMCy1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJTMLuwAAoJEN0jrNd/PrOhEUYQAIlqEosdzccDwcUzmlwIhjHQ
JZHA8dEtrvl+8s6nAuqZvaIdTroeR4dTM3a1MEY3bSajXM8/PEHmClMPHL5rF91G
GXJU21MUtyFHc1P4/e+RCpww6crY/W5BYptUJfns3QJ+aCt1MJGKqb4uVYi5VjLS
fewXFMPw4qgHb5ebc24nR/HXBHj+CA8ZcMHgqt4re/VYr4hzWfo11AsuswhrzsDb
vvIA8zFKQfjb1c73ZEWjUoV/cJE3SzCeR00Yf0F/yMUndWBhrT8hToq7w9/V6gxy
WBwYtqxKS2jM1XFxYuiwXefqvlStM/RzJn90X/xE1qHZhhBlpSq9rS3HqNSzzGA4
8gQzD6eu7O7dxbV8dKHhExCfdqAPGzQQp69gALySOqTnzkwvuu6iXs19cykAgfc/
6rqkgF7ZbxhyFIDc5JOkqMmES+QN97p6RAcKNcPwvFIIN8yd6pwChUQ1EoG6ZJEl
Wvhee/dQiGPP4tktbtG1tzh7BHUvwGTNmdUJkHrjxOUNkRKMt/2B7EnIDVqRbhc7
XHUS83Izwaj4BlG2IO8hTvNtIB5mztY0nQKSczjAKDlZCydUrp+ntjTEwR+NBIQ3
UQAdX0zpZWhvXocjn2KF6DHmKKBZ+43ey+ipFcSYhZww0hACPy0sr2MJ2TTbPWvb
1Vzj3rA7Ioe6MEZBvCA/
=KUjz
-----END PGP SIGNATURE-----

--ibvzjYYg+QDzMCy1--
