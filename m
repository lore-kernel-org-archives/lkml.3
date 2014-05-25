Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752071AbaEYTpi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 15:45:38 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33558 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751738AbaEYTmu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 15:42:50 -0400
Date: Sun, 25 May 2014 21:02:11 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Chen-Yu Tsai <wens@csie.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Emilio Lopez <emilio@elopez.com.ar>,
        Linus Walleij <linus.walleij@linaro.org>, linux-serial@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Luc Verhaegen <libv@skynet.be>
Subject: Re: [PATCH 10/22] clk: sunxi: Add support for PLL6 pre-divider on
 AHB1 clock
Message-ID: <20140525190211.GT10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-11-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v15hXiddb3kq3Bam"
Content-Disposition: inline
In-Reply-To: <1400831485-28576-11-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v15hXiddb3kq3Bam
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 03:51:13PM +0800, Chen-Yu Tsai wrote:
> On the A31 and A23, the PLL6 input to the AHB1 clock has a 2 bit wide
> pre-divider. This was verified from the A23 user manual and A31/A23 SDK
> sources.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>


No, it should be part of the AHB1 clock code itself. It's internal
clock logic, isn't a clock per se, and as such, shouldn't be
reprensented as a separate clock.

Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--v15hXiddb3kq3Bam
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTgj4zAAoJEBx+YmzsjxAgioEP/iybxpcK3inAnC6ucveb0h+/
ND25GBTBrQwCOGJSwU66vX0o6g8wQAzig8Pbq2Kids7GT1BB5xHCP9uwlOwJc2rj
h4LZWWPOG8rVi0p1/c8yMLfJF8DQbVyFJf9/jeYjpd+/rvf37A/n+RYlPT+fkJ+e
pS0T93Bj4/BBUN+uf1G0uoi7ROC45zj/wqTuYYCpczdahcT2BFzTAwpsZEhJQEPA
5r8OomsTGPz5MFAG4QpFfXb4jsyCoWd+PXM97KF5MXS5QfUYVIVUWmaXQKrjZ1mi
r6DPRGVE8EHA/pJzbKaWr7s+sRBuZKcJ0xYTwK6dvIsYYAbQRnLiPK5DWEX9JRBX
C2l7wLvZpCzuNm7IuEbKALmTcQsec8mH6Hj5Za9cW8mcFL6FiwB8nEXtGyempBly
6LiJUbcO4SmXgDYrc2a7k4A+dtgVrkH91Qg4ln7xWJedKYhd3+OelvSP6HrpWx7g
HTtrkgz5+tY2Vm+9m/ABlOtyQq5Zl6LMnsM+OuZinhqfeqfT6ONqa+jdhN475qmi
DGRmBmsmjBGuEp79wx8rUrV6N+yqL94Aak5UAI76kcVcAnK5Q2seU/NaBrXMiJLm
4tgWNt1pmHb4A3K1NstpkQ1wFOqNUYZeYSaAAuuv1BpeanswfI1SbvUgJct7fMg2
lrbMeo4HRlmMepWXIqBm
=VxaK
-----END PGP SIGNATURE-----

--v15hXiddb3kq3Bam--
