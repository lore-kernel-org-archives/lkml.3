Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab3JXM4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 08:56:13 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37121 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab3JXM4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 08:56:12 -0400
Date: Thu, 24 Oct 2013 13:55:40 +0100
From: Mark Brown <broonie@kernel.org>
To: Tero Kristo <t-kristo@ti.com>
Cc: linux-kernel@vger.kernel.org
Message-ID: <20131024125540.GF18506@sirena.org.uk>
References: <1382616221-8633-1-git-send-email-t-kristo@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rWhLK7VZz0iBluhq"
Content-Disposition: inline
In-Reply-To: <1382616221-8633-1-git-send-email-t-kristo@ti.com>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 178.105.202.101
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCHv2] regmap: debugfs: Fix a boot time crash with early
 regmap init
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:57:07 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rWhLK7VZz0iBluhq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Oct 24, 2013 at 03:03:41PM +0300, Tero Kristo wrote:

> If called early enough, regmap_debugfs_init causes a crash, if the
> fs subsystem does not have its mount cache created yet. Even if this
> would work, the root node for the regmap debugfs is still missing,
> thus postpone the regmap_debugfs_init in this case until the root
> node is created. A special regmap_debugfs_early list is created for
> this purpose which is parsed later in the boot.

Applied, thanks.

--rWhLK7VZz0iBluhq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJSaRjIAAoJELSic+t+oim9ht8P/3yeSspUqNXhf82/Jqz1UgLq
d2GnjiO9ySWbzWhZsMkiIHX9Nrkdm4AxJAtAlLpng5KOdQnkVNbtarPJXweH75u1
LN31JM9bIUfx3GtyROIgC8mj50RkTNViAFCaN2A+XDTOoKimu/m6LhD4VV32t9Nn
v8x0J4ny96j1ikhXeNPmEYYJSPNzuXNuOe1a0YxNtN7rXyIyoXzRn17XoH+/HQYY
+snlb/7z+bR4tbwCaxhNDsfXSG+FCJ6utpXKWwLFwoSZUvgpWo/1uLUp1NRsY1X0
dHlsgEwvS+Prx/RjiK8xNXHOpIKxKNN695SytyDGI+ivJxWp5+Xr7XohEJfaxYMz
n0QbMJ0/btdEwCBw5IOiLaadA2GhsZVroDOb1eNy4EpOClfcrH0f+X5IvPjhtSio
iLidwNNKgOrL+WNqJV93eeFs30k9RrtYDUsJxHiRfa8VIMFmLwHmZOhDbyVBQA/u
q/FvTZMf32piS/iGKwogz6j5OT2vJHBcWal6W50QD9QPsD+Fg9jrl9cAvWg1yw60
NXlAY4P9smaue4JcfCBizmsEFug//PRfT8qZ4TnKAzU4AUFnZ9Qa2MSC0JFd58v8
DAiFXRkCz0zxftOhiXPDMiFMwMDM6BaIeqQjodeyWzRhQIY3neuk6ASFPiUHuAPr
APzdj6MGub5faQMJrOoL
=yjD1
-----END PGP SIGNATURE-----

--rWhLK7VZz0iBluhq--
