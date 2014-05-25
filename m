Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaEYTm0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 15:42:26 -0400
Received: from top.free-electrons.com ([176.31.233.9]:33470 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751027AbaEYTmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 15:42:23 -0400
Date: Sun, 25 May 2014 20:43:35 +0200
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
Subject: Re: [PATCH 07/22] clk: sunxi: Fix PLL6 calculation on sun6i
Message-ID: <20140525184335.GL10768@lukather>
References: <1400831485-28576-1-git-send-email-wens@csie.org>
 <1400831485-28576-8-git-send-email-wens@csie.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HBg0C3yr6HVa1ZCc"
Content-Disposition: inline
In-Reply-To: <1400831485-28576-8-git-send-email-wens@csie.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HBg0C3yr6HVa1ZCc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 23, 2014 at 03:51:10PM +0800, Chen-Yu Tsai wrote:
> The N factor for PLL6 counts from 1 to 32, as specified in the A23
> manual, and shown in Allwinner's original code.
>=20
> This patch fixes the N factor in the clock driver, as well as the
> comment describing it.
>=20
> Signed-off-by: Chen-Yu Tsai <wens@csie.org>

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks,
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--HBg0C3yr6HVa1ZCc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTgjnXAAoJEBx+YmzsjxAgOqYP/1V+CTV299p7d/ZBKkVhZo2z
xWiKkVBkI4C3oNr2xA2M7BLmSf5jLUyhTztz8+KcH97sI3zfy561vDDNvNfx9C8n
ign9G/u8uYRSHNX27aLAVWJ7eJUkeMecWrv5yb/XPXDAqvXY9qnI2VHj/qexrrRR
KuCXAa5fIaTmSHvq6/9fvA0DgHQoiWKxeZhyZ0q4S0Cp1vWHnHXUKcoh/5LkOhGt
UiAHzhk/dyF8IPo6edaP7SuFfIhFfozX3UM+9ozAnol6a6yFl9DWYNIsp28XChOh
NmptIUYwiypUyCyhMRQ3rVIDpsGEhadH56e/iWusUyeg2sQ+43PKr7hTBcxzUUeO
VmtMERJgnxLSFlp6hcopfVBbaiGoyX5kZhdImfUspF6YFgIaFnh7DXiIyE2ZcdPF
w4o5HcJ83t1ZG5vj3hswvc5rOrOPmmiijLNd7Gg9ZkR7RCgyC1VnfcFE974lLhOH
nnY6ZAo6lL/mLt6Acrn+DDOQyTcTBcS12jDsacrsZBCdsoI6roXY0KXI+JQ04Kdi
JgvJMeiBt8+9v3Gh3rjC68fbWMScWaSc9oYkeeU101mlJGx1IejB+YL1kCbwDywj
zlnKxrk1jeszbi5W+r0oVa3kEI0qNMhx8V8+dx5ml0Zj4A589JiF3bFydTALrOXi
sqbtBe2f2/rhDMJuCrDg
=G7xQ
-----END PGP SIGNATURE-----

--HBg0C3yr6HVa1ZCc--
