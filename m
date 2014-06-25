Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757055AbaFYNfH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:35:07 -0400
Received: from top.free-electrons.com ([176.31.233.9]:35942 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756811AbaFYNfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:35:04 -0400
Date: Wed, 25 Jun 2014 15:31:34 +0200
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        =?iso-8859-1?Q?Beno=EEt?= Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] arm/arm64: DT: Fix GICv2 CPU interface size
Message-ID: <20140625133134.GQ19730@lukather>
References: <1403692675-26503-1-git-send-email-marc.zyngier@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Z8BXP3CGI0FdUons"
Content-Disposition: inline
In-Reply-To: <1403692675-26503-1-git-send-email-marc.zyngier@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Z8BXP3CGI0FdUons
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 25, 2014 at 11:37:54AM +0100, Marc Zyngier wrote:
> All the Cortex-{A7,A15} implementations are using a GICv2. Same for
> the current arm64 platforms.
>=20
> Turns out that most of these platforms have described their GIC CPU
> interface size as being 4kB. while it is actually 8kB (the GICC_DIR
> register lives at offset 0x1000).
>=20
> This was found when converting the GIC driver to use EOImode=3D=3D1 on
> GICv2-based systems. It uses the GICC_DIR register, and the result
> is a very early firework...
>=20
> Signed-off-by: Marc Zyngier <marc.zyngier@arm.com>

Just tested this on an Allwinner A31.

Acked-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Tested-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Thanks!
Maxime

--=20
Maxime Ripard, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com

--Z8BXP3CGI0FdUons
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTqs82AAoJEBx+YmzsjxAgJtUP/j0Vbx/KdLy5szq5yRrNYza8
n7XWqbf5uDMr/AUlmZh7E0ITdjlgGkjnT7K4zJUKndH+vem9NqMSS7aDzRG70TgH
NVFrx3YagfixvZtpdxXH1z1RsbXj4v6/yOQPf8EO1GQR2dw8p3jPyL+Qsi9mXYFw
EmZMwpWPIs0FSvQfq1pX+uvnM1Brw9gVzcounHHk81t3d1rgio3JFCo84zcqM8YD
wIs1JQB/2k+PN7g30hM1yFjtkKSDzBgiQDo9I9hZnwjZXZ884+qXhT1DbWf8fXH4
yRYgE0ZVtTjlIZn43UCM3IVwOv1Mkeztl2WYdBbr5ugU7nNY28SO7n1MzSoOjMyq
9Y2nnYYc+JVtB9KCJWj0lcsI4yopMLPjNyHWkHgTeMRwOla1DoCmA91COF5C/Pl0
y+hhdcdDotsvId1BImRb8FwMfmBAPyWUlReGiT7CsUxkiDgNmZgodBwo3FVSz0NM
wqvb23FVwRK81z1mR2ubXdAMBOrz6g6dJqvdlAq5rbdS4RZyUacnY1JMjA3GIyp2
+LJSJXCNEtdcqMNp+zZy5z05ceJ0VSVJB9JpfgxdAZQBF8shAU6JCQ0EoojTNW8r
caG3XHGLJuf2ryfvWj7Bqz9fTUShm5Fk3dpMsQ6+ze/CW+1R3HGWnBK1rvyWRUse
wPqsESa8j5xxgj4IJbcH
=kC28
-----END PGP SIGNATURE-----

--Z8BXP3CGI0FdUons--
