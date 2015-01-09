Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310AbbAILjk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:39:40 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:54328 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755101AbbAILjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:39:37 -0500
Date: Fri, 9 Jan 2015 12:39:34 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Prashant Gaikwad <pgaikwad@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] clk: tegra: Fix order of arguments in WARN
Message-ID: <20150109113933.GG16465@ulmo>
References: <1412061720-10402-1-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DNUSDXU7R7AVVM8C"
Content-Disposition: inline
In-Reply-To: <1412061720-10402-1-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DNUSDXU7R7AVVM8C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 30, 2014 at 09:22:00AM +0200, Tomeu Vizoso wrote:
> As previously the names of the present clock and its parent were swapped.
>=20
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

Acked-by: Thierry Reding <treding@nvidia.com>

--DNUSDXU7R7AVVM8C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUr731AAoJEN0jrNd/PrOh6ggP/0t9tGBdQV9faj1NFaVhslJw
v8OFPF7J4eGfhuNJOgPC1nkBSuBrage5CG7rKV2sBp4pY1qUF7CbId8wSPpcnOCE
TJlxc7H0YLRMTGLtwovDdS3Xc/v/78SqSKjgSyMqBrAwGNK6eN7y0cEgjPSZYHqa
Vu0TkO1mxRbPB96FJQ1Xq05GbTK1hjaIgm6+VJWU+GzMZBn/9P2JwYdWk5vdC9DK
cil2bcWvXq8jXt9uITtphS/lB4xGFLwM9sujX1TrG/on3XgHoioXZttZbsN3hZWt
EPO/Av8ZmINDFKG+d1yJ/h/1tAkz/VErXq58kqhyXtFGTqoUMsX0Rz826laAonKg
KXeZBr/MS9naRYNW/Z8NnuQ+Oz82k168UXWkPQqfOK9ZR+noemrBiG38EGadX/3t
0TgqzXC1p9djyxW+ThB6xWBTiJqBc+2VPV6fGGDhBbVIuXiGrgP4lkttSjdDmijR
gcgZfkg9omcaWv5RFBRNga30XY8d3PhHXdSl1W+YPtf6KLFLUcYTHgbm709r3vGf
xsDveonfCd4QTWYJ8OiswjOCpGW05tCQRi1r2Hw1FmqV0NX6wc3gtuu6sJATknh/
x/wmPM60d7UMGj+kpTf2mVe6SkImIDmMQLQoyHY6qWAT20nq+Wvwp4eg7Ifo7cfG
9uMciCg4YCKNjo7tT8jJ
=hDQ9
-----END PGP SIGNATURE-----

--DNUSDXU7R7AVVM8C--
