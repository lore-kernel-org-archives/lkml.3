Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127AbbAPMXg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 07:23:36 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:62649 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751390AbbAPMXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 07:23:34 -0500
Date: Fri, 16 Jan 2015 13:23:30 +0100
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: linux-tegra@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Dylan Reid <dgreid@chromium.org>, Simon Glass <sjg@chromium.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        =?utf-8?B?U3TDqXBoYW5l?= Marchesin <marcheu@chromium.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 05/11] drm/panel: add support for Samsung LTN140AT29
 panel
Message-ID: <20150116122328.GF4885@ulmo.nvidia.com>
References: <1421338359-27467-1-git-send-email-tomeu.vizoso@collabora.com>
 <1421338359-27467-6-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JSkcQAAxhB1h8DcT"
Content-Disposition: inline
In-Reply-To: <1421338359-27467-6-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JSkcQAAxhB1h8DcT
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 15, 2015 at 05:12:17PM +0100, Tomeu Vizoso wrote:
> From: St=C3=A9phane Marchesin <marcheu@chromium.org>
>=20
> This panel is used by the Nyan Blaze board and supported by the simple-pa=
nel
> driver.
>=20
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>  drivers/gpu/drm/panel/panel-simple.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)

This is missing device tree binding documentation. Also since the patch
is from St=C3=A9phane you should probably add a Signed-off-by line from him.

Thierry

--JSkcQAAxhB1h8DcT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJUuQLAAAoJEN0jrNd/PrOhkKcP/0jBgzKukKSCYc7TZ5YzrBtR
9MFosWBdzVY27Ng02LojgIChzQRld24/ZUe/eRRQm0V5fSxV/gogrpK84X9cBLaj
4JdSQHJ6b1lrucHaaaDq3vR/WPDdbBm6Aupjs8XEWHa0rEyGUrZictiKG36v9jaS
Kc/V8Rn1aylfUHrh42Y1qgpJTbuPYCZOIgQjFSxUolpM9sOx+5W4scRHYMUrlTBI
Xngy5/uOMHIGoiTiA2BAHSzRaQnkaUyqhPTJRNVoo+JGPo/K4aNjMY4r87HsDR/o
oXlVVdOKM1uO57u/7H3/q3xfe88lpLNJcksGaWqiJzymXiR6Ru7LLuoL+SDELz8X
jw8m3ZawtPh75fJFDoCWc8LBBTa480GWZopx0zLBjdLba71BBN2BhDHyUdpEZRHM
OtsDaOlQXRT7UuGRoMQxoALI7OWcg/vPN2wrhhiRwrGN0v3hMerRhly1gzQIjhJK
G0XMPQKynSONCOCOmrquYByQRi92LeympmAx4yTEyUq0s3f9ZsBaJMtP+fJFgOW/
BUUtnS/2PNmBijZ2xatz0/vtVNisWHQKMu8WWtbq3haAbudEjJOe5q0pBOQZNRpv
857EbU1ThcaFQ8ttjBf5hu+aSc+1UxmUGLVxHGZjUm/BHmi1YNRnEC1o8MTGfsAE
ndPlAIjePnEHN+pNPARi
=ZbRH
-----END PGP SIGNATURE-----

--JSkcQAAxhB1h8DcT--
