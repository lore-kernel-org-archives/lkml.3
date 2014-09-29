Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921AbaI2Oka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:40:30 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:62404 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754306AbaI2Ok1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:40:27 -0400
Date: Mon, 29 Sep 2014 16:40:24 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Boris Brezillon <boris.brezillon@free-electrons.com>,
        dri-devel@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        linux-media@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] video: move mediabus format definition to a more
 standard place
Message-ID: <20140929144023.GB2273@ulmo>
References: <1411999363-28770-1-git-send-email-boris.brezillon@free-electrons.com>
 <1411999363-28770-2-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Content-Disposition: inline
In-Reply-To: <1411999363-28770-2-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 29, 2014 at 04:02:39PM +0200, Boris Brezillon wrote:
> Rename mediabus formats and move the enum into a separate header file so
> that it can be used by DRM/KMS subsystem without any reference to the V4L2
> subsystem.
>=20
> Old V4L2_MBUS_FMT_ definitions are now macros that points to VIDEO_BUS_FM=
T_
> definitions.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> Acked-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
> ---
>  include/uapi/linux/Kbuild             |   1 +
>  include/uapi/linux/v4l2-mediabus.h    | 183 +++++++++++++++-------------=
------
>  include/uapi/linux/video-bus-format.h | 127 +++++++++++++++++++++++
>  3 files changed, 207 insertions(+), 104 deletions(-)
>  create mode 100644 include/uapi/linux/video-bus-format.h

Hi Mauro,

Do you have any objections to me merging patches 1 and 2 through the
drm/panel tree given the dependency of the later patches in the series
on these new constants? If you want I can provide a stable branch once
v3.18-rc1 is out for you to pull into you tree to resolve possible
conflicts.

Thierry

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUKW9XAAoJEN0jrNd/PrOhdGEQAIGS5+E6bA05hTMqi1sV0j+5
XlSqV2sdTiVg2p+MzLHI0sYI62QJGOZ0UZR7yCKNrBuN9Awmr9sWlMplqQWVkxdo
0X4xoS+Sx5yQNQKDMLnYvGlzTU8b1BEfEffTHeauNhN3fC9KxqKdUwH+hG+QARbW
Lk4jMPg7tMF+hkEnUxowA5Oh6o+qGTdH3EVIiGqXGSbdutBU0WL930nKk3DOi/Ql
9pWOhQp1a0kJddvLz1/JWaeKhcPM3RurdFsyeOOMZ91l+jVg/v3I9vl+mUPox0NA
lNnTIUqE/sfO90SqfBOfdRbZSbfuJuOSqNRmf0hy6k70heJiYV9zWkdEvO2NDNaf
aE146rEc4OsNvxEDjF3XxlMg5WT8FbuqkmWzzKRm8l7C3L71CwxxWbDew8uwWhIf
Oboab86AGCdaralrnbBdQ6nWWK31dptqd07BTzl5s/6c0oHqjOu6X5NKFW/wet3d
7P1AhkSm7XvGnnzL7zIQcHHLupehyYJ5rlw0YvMoeO+cuh8Fq+MRFxiqqW5pUZLG
kpqcDXG1XQSzkuypQhlAR6r2SzjI2o4ianCSy+Pm8YqmIzvEmcBl27NjmpIhR17q
0v0RFIp7REQzsIQc/7JlVJwHf9CfTaG1x1ZlgtJ/Z967It8zM+n57ou2rEuKq89z
aVGPS6o/GInxWCkQEm1F
=r626
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--
