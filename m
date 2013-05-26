Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab3EZKYP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 May 2013 06:24:15 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:42427 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3EZKYN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 May 2013 06:24:13 -0400
Date: Sun, 26 May 2013 12:24:09 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Arto Merilainen <amerilainen@nvidia.com>
Cc: airlied@linux.ie, linux-tegra@vger.kernel.org, tbergstrom@nvidia.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] gpu: host1x: Rework CPU syncpoint increment
Message-ID: <20130526102408.GE1652@mithrandir>
References: <1368791388-31441-1-git-send-email-amerilainen@nvidia.com>
 <1368791388-31441-6-git-send-email-amerilainen@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RpqchZ26BWispMcB"
Content-Disposition: inline
In-Reply-To: <1368791388-31441-6-git-send-email-amerilainen@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RpqchZ26BWispMcB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 17, 2013 at 02:49:47PM +0300, Arto Merilainen wrote:
> This patch merges host1x_syncpt_cpu_incr to host1x_syncpt_incr() as
> they are in practise doing the same thing. host1x_syncpt_incr() is also
> modified to return error codes.
>=20
> Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
> ---
>  drivers/gpu/host1x/dev.h          |    8 ++++----
>  drivers/gpu/host1x/hw/cdma_hw.c   |    2 +-
>  drivers/gpu/host1x/hw/syncpt_hw.c |   12 +++++-------
>  drivers/gpu/host1x/syncpt.c       |   15 ++-------------
>  drivers/gpu/host1x/syncpt.h       |    7 ++-----
>  5 files changed, 14 insertions(+), 30 deletions(-)

Looks good. Can you carry this over to v2 as well so I can apply all of
them in one go?

Thierry

--RpqchZ26BWispMcB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRoeLIAAoJEN0jrNd/PrOhFFIP/RuXV8B3Eda0cYwo+aiol93v
RlocIFyQG8n5SERrU2p6DZzGixMDca7qZT4y3KwlTPNshD+OpETAq8ppfH0RJ4zt
MA+xGSi/gCLzPYQYbxaPEYHxNCNe3pVHzXEryYEsUaGc+10ki12LfEuxILkw/lDg
Fc3BB7U8xpDhRHf/Zn+g07TKeYJYwEabjs0tLLyisLr11R0QqT36bbUJAM8FJpM2
VaActZ3K/7Eg47686n0hYMqFfin9T4YvRXMIYNOE93wV3GJjLbb33uoXJ8MJBJ/Q
DlvM9yCTes9DfC+l7fBFiJ/U8aUFIxzU/H5g2/86p2IoU86LUFqsJzZKCA723JMz
8YBNoD4UKD6wdQUZPR62dUatRW+/8W8hLc2fBNP9mRy+krXgkGL871yFmiIooviu
f4aGOaFpqHLBJgRuBuGksT2rjb6rE12kyM/k/EvQnSc8VocrAVqD3hay18mVW2ra
kjLbDVjbgpQSytUFzEhdR+qI7u4Za9USRt2Xt97rRS32dmYBMaVf4MC5+06ZYCOM
yXyfQZS2R6AIcAH8FZLjkY4bzVOVQZRmOQxzXyiSHQDJ99G4F1gQYqraSqLAhKew
trnkSw524UmaQnAicjoxYwDJ1TceYkMhJNcoKOPbmKvyCOC5qcZ4QcWaA867yQit
+gO08ubmv7sHHAdyqGZm
=JtZb
-----END PGP SIGNATURE-----

--RpqchZ26BWispMcB--
