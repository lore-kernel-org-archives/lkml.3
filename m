Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaANNc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 08:32:28 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:49057 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbaANNcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 08:32:25 -0500
Date: Tue, 14 Jan 2014 14:32:22 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/7] drivers/amba: don't check resource with
 devm_ioremap_resource
Message-ID: <20140114133221.GA10936@ulmo.nvidia.com>
References: <1389700739-3696-1-git-send-email-wsa@the-dreams.de>
 <1389700739-3696-2-git-send-email-wsa@the-dreams.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <1389700739-3696-2-git-send-email-wsa@the-dreams.de>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 14, 2014 at 12:58:53PM +0100, Wolfram Sang wrote:
> devm_ioremap_resource does sanity checks on the given resource. No need to
> duplicate this in the driver.
>=20
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
> ---
>=20
> Should go via subsystem tree
>=20
>  drivers/amba/tegra-ahb.c | 2 --
>  1 file changed, 2 deletions(-)

Reviewed-by: Thierry Reding <treding@nvidia.com>

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS1TxkAAoJEN0jrNd/PrOhk5IP/09fJj/DbouEotGdo4OVW3b8
oBPuIE0p4NblJsXc3PwxY8HzNlWmx1gZdi6c7A6uaMFH073/+cd4R/lP/U8MtCk0
ErccCC3G0f4AtoiRg+Ibvdlk/p/bEdCNv1AevMF//dYS5XnQEpgEFhwm5UNr6g7t
ANsw6XjFnueyDnj8y66xs7ayAOo5uKlu6r5kBre2p8ztD3yrXa0Lv75yozvtTYTj
EAT4kJbuud4E/d4H1uaB+7i57cQz6ofyb04+jYUou0WkqdRc88cL6opmF/vQlO1x
syOvYdy7uzvpuuB9lypImK57MMyN7Xi1ZNbLN/PeabsXV2YQiT6lmzDIFcLKCxXO
JtOHIlJT+GDsTkYwLds9ASWc82LnfCes35QinAx4YCJhVGUgmTkc5KIb8wR0s6Wx
T6WoOLv66AVRslk+z0qVfYQy8rrb5iJHbfB+IktaKNPBoecFkQPWb69ZBB2zKT2R
emhBVfkWf5U25Zx+JsjD6+ZSiT6I4K2VUUTBg0CF396TFO6PMJ53ryBQlB7zUJIX
WwKFgsdRTEXtsacKRC9rT2gEGZljyjNh4+DOlEbWt1QMGDxlTpprPfuKOMo+4k5u
wY+3zhP1sO2kHezn3S8UkYcY+kI1ZWXBYmL+V2TJObkRUSgse/QfpfF+vOF1hz3p
r47Ed6q9OuIEQJD8/iZv
=uGTs
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
