Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754759Ab3F1NxT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 09:53:19 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:60348 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab3F1NxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 09:53:17 -0400
Date: Fri, 28 Jun 2013 15:53:14 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Richard Genoud <richard.genoud@gmail.com>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: rtl8192cu: slow path warning
Message-ID: <20130628135314.GJ4319@lukather>
References: <20130611123814.GA9854@lnx-rg>
 <20130626142241.GA13107@lnx-rg>
 <51CB0E9C.50408@lwfinger.net>
 <CACQ1gAh+WjQZHo+_afZpzcwt1=KPM8VMBOe=YCHN_LEZu+jPNQ@mail.gmail.com>
 <51CC8284.9070301@lwfinger.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQAwcd5tHl0Qlnzi"
Content-Disposition: inline
In-Reply-To: <51CC8284.9070301@lwfinger.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQAwcd5tHl0Qlnzi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Larry,

On Thu, Jun 27, 2013 at 01:20:52PM -0500, Larry Finger wrote:
> A revised patch for the warning is attached. The fix relatively
> simple and the only difference between this one and the earlier
> version is that routine rtl_lps_change_work_callback() was moved
> from pci.c to ps.c. As a result, it will be available for ARM and
> other architectures without a PCI bus.

I just tested it on top of 3.10-rc7 with an imx28, and it works fine.

You can add my
Tested-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--LQAwcd5tHl0Qlnzi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJRzZVJAAoJEBx+YmzsjxAg9fQQALhkCRClt1Y54AATGzKuQd4+
9mHROC5pxaMSOvVKVBK84+tSaXw79FfDrjiFFKn/tTi3lcPTtO7d4N/l0Q/FQnso
KT0P3KAcgStPb4OxeQ7IFpRXkJf/0MjVIpkFoBUEx20GoWxuxCR6qPngwlI8YU+m
fQNW+zSNbzFPSzsxTJzVtewdNux7Gcdcy2+vCq020XqQvnOHEIuYd84ZHBs/pQoX
DaefkrO2RS+TnXuGEGm/SeLDtsHFo+WJdDEziumcATIVHGoqe4QJGg5iXdSBg6Be
Cw/NuhEtZy5pYpzGc15jIhldZAVO0UXUA7vCItI/TfugydcQHyb06kV28DeCO8bP
U4C3UeDdJvPXd9dfoJoEGrJLLuCeGrjxV9G8stncCNg8OWEl/SeG63ib4B7TvVoL
3pzQiJIydecbvxqrG03P/puleU5giy9DOnZ5w9CULdgD3XnQwrPBhBcL6h9RYLad
bpKM2hb+XeZ7FtZ1NJC8E3nBvtf72Jcp7groxHl0miLQd2Xegf8KbdTBWjX6JUVU
wMzkLTb0lDHqAk1pqakodVKwKEChBSE+eLrXvzrizjj3lz1CS88im8lzw7EmQOoB
vl69Izck0ymvOb533iYJwPSHIeitAzzLJpA2E+Rnw86/EacLisaSucD3JoucuZHm
lG0i70QgiDhQDB7dXkqq
=1gK/
-----END PGP SIGNATURE-----

--LQAwcd5tHl0Qlnzi--
