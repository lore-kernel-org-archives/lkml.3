Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaBLKTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 05:19:00 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:36039 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaBLKS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 05:18:57 -0500
Date: Wed, 12 Feb 2014 11:18:54 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Erik Faye-Lund <kusmabite@gmail.com>
Cc: linux-tegra@vger.kernel.org, tbergstrom@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpu: host1x: do not check previously handled gathers
Message-ID: <20140212101853.GD3409@ulmo.nvidia.com>
References: <1389124986-32501-1-git-send-email-kusmabite@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RYJh/3oyKhIjGcML"
Content-Disposition: inline
In-Reply-To: <1389124986-32501-1-git-send-email-kusmabite@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RYJh/3oyKhIjGcML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 07, 2014 at 09:03:06PM +0100, Erik Faye-Lund wrote:
> When patching gathers, we don't need to check against
> gathers with lower indices than the current one, as
> they are guaranteed to already have been handled.
>=20
> Signed-off-by: Erik Faye-Lund <kusmabite@gmail.com>
> ---
>=20
> Here's a trivial optimization I have been running with for a while.
>=20
>  drivers/gpu/host1x/job.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Applied, thanks!

Thierry

--RYJh/3oyKhIjGcML
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS+0qNAAoJEN0jrNd/PrOhSQoQAL/XB2MGtD9XiiG00c+XrGFl
c2HZFPEDh7ISAmw17Y/UM/eSyeQCkMiR7pyNkYtVhe3shpvT/I56KohOxyW1V3C0
BQX53KNhvrOcsWoR8J7LXBxeYtKRNcumx18JELvyg/cxGtYTKJDT9zV/Am5tXRdP
g7pDwrz9C3X8F+tVUuuxA0Arp+v4Cfg3Jgo+V+jnTD31ulX2BIxuQWqvKvJ1kLN9
EiUC8ii3fcLz8Z6s/av1Ni3zEEL5qLyXpLgbP4hSr/Z505TnLncLqZtaPmYSzwfX
spsOUcXipVZGsJ5svFuAENjgKf3VAPy6BiCo34PWeiFjLsgloHH+E0WQ6e7q+a+u
mBWsYpqjneIkatL2+WwlozJFNXBEYzwOc4TK7Ctb+M1RIAOworbZE4Ok7bnnvHMJ
yrvUJBbWlcTgopU6kqoB18PNODTcKQZpf0zSOSitkaXh9PljVyK0ppb4xaWXEvzj
4aFYMjeKn9Tf61PYHsUOXR4X2GpStF/7JXjsU2IIYdLtfJFnKZDj3OigmuhDRPRT
0Dd9a7TS+1XbCUh/AxB69x7wQesu89loPn1sLmV2ZkA3EiVbz2k5fgy5AiYpvulZ
zIZ6EWOhZDZGz8EvZ8/akHzH+UPFr4zabyo8K6nEdD0ZcrwLhtWUzz1BIaP/h5j9
Ct5PcoH9wxQzU4GMjFsp
=DvLk
-----END PGP SIGNATURE-----

--RYJh/3oyKhIjGcML--
