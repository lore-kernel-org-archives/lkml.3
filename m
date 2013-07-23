Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757931Ab3GWRUi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 13:20:38 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:57465 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756755Ab3GWRUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 13:20:37 -0400
Date: Tue, 23 Jul 2013 20:20:35 +0300
From: Felipe Balbi <balbi@ti.com>
To: Illia Smyrnov <illia.smyrnov@ti.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, <balbi@ti.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] Input: omap-keypad: Cleanup - use bitfiled
 instead of hardcoded values
Message-ID: <20130723172035.GB9166@radagast>
Reply-To: <balbi@ti.com>
References: <1374595798-15492-1-git-send-email-illia.smyrnov@ti.com>
 <1374595798-15492-2-git-send-email-illia.smyrnov@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <1374595798-15492-2-git-send-email-illia.smyrnov@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Jul 23, 2013 at 07:09:56PM +0300, Illia Smyrnov wrote:
> Use bitfiled instead of hardcoded values to set KBD_CTRL, use BIT macro,
> remove unused defines.
>=20
> Signed-off-by: Illia Smyrnov <illia.smyrnov@ti.com>

Reviewed-by: Felipe Balbi <balbi@ti.com>

--=20
balbi

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJR7rtjAAoJEIaOsuA1yqREnbIP/1edMBYasMw7k2Sc31/gVU3k
i3xxQjrd+H2ytVFEH9Te/bC2sgva7H9q759LYZrF1bpNcN9MNwR1/vTjU3iew0qJ
qZWCp/Mf8AHiWIJ0xPBHvWvNH5n9WhxznrHCQ/gmMyoiiD3EuT6m99+ZiTMn6vPX
Ala8dKAPmhUaX9yzUwCL4fnD0gcimlsTvmspARgnKjhYucSzEcdl8X6B/JY8xABG
khPW+jd0DzLWo0QFA4FAbyiHe6pFPCLn6L4RR6k/ufyGRNKZyL+gvhh2bLE+5yBj
9FUEZFPwwsAgEX5pXelC/3CTtqSUseXxTXEBoHboMmdrKh0vsz2wHGMuphMGxc3Q
Z6lG5PA8qeijhXJe7r+N9HkMh0CQ8BxNyWRBDThYlhrN+ZcvWgOJSP2NwjGEdi6P
FAOlC7Glm77KsQZ4jKwXDOgbGym6MPEsblnVfUHgiZNgR1JGaYc4072Ivlxi46L7
udAUdGui8ROnl26jUzfZoesym5UazNSyas1HdlrL6XJoRMkYg5niOXytgW5E5Bw2
jh6+qibgPQhaE4jSHr+s4umLq7PHgsxjIvQNThmImJVzvl+7gq4ydQGeJnGBJxTM
qmyOSp2nuI1akCQWqR6N3U8/o2q+Paeo+4KmgBfBEDD0U7yJ/D1ez2cD4lMb1sq4
Qp1SX9sX1cial3jtlIvC
=Ec8R
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
