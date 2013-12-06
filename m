Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab3LFUUL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 15:20:11 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:45017 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753560Ab3LFUUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 15:20:10 -0500
Date: Fri, 6 Dec 2013 14:19:28 -0600
From: Felipe Balbi <balbi@ti.com>
To: David Cohen <david.a.cohen@linux.intel.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>,
        <mina86@mina86.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 5/5] usb: dwc3: set gadget's quirk ep_out_align_size
Message-ID: <20131206201928.GD21086@saruman.home>
Reply-To: <balbi@ti.com>
References: <1384201011-11114-1-git-send-email-david.a.cohen@linux.intel.com>
 <1384201011-11114-6-git-send-email-david.a.cohen@linux.intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bjuZg6miEcdLYP6q"
Content-Disposition: inline
In-Reply-To: <1384201011-11114-6-git-send-email-david.a.cohen@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--bjuZg6miEcdLYP6q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 11, 2013 at 12:16:51PM -0800, David Cohen wrote:
> DWC3 requires epout to have buffer size aligned to MaxPacketSize value.
> This patch sets necessary quirk for it.
>=20
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>

looks good

--=20
balbi

--bjuZg6miEcdLYP6q
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.15 (GNU/Linux)

iQIcBAEBAgAGBQJSojFQAAoJEIaOsuA1yqRE5VMP/jb1TSvpQHTwk0Cx+e0EQZ19
jK/1lZrNZQcUJGEUfEqZV5eijfk/3UJ4Ff3HrAG3Pdgu4WgU9SWScgmgjXcwrn77
5yJxNJ/zjrzuVUJf2UK6hPQ0y38W9z7vdPnlgB+6+7OD8l769iJoQLnk470eKBW8
+67PqbU9Zbj2ly27IITI/8YxbzfR5pX/U2/kzPEZ3f9Qrhad5doNi95zneyh/foW
zZXc+kjUx3ibuiYhEhu+TkbmkUVgucMJtAbYp6+/nt78hrqIvjKNxYnz4PjlOJDN
/SovmmTewiCgO3DYPBn5T+mCibU/GPLQCAkvZtAvyZyMjzqzNVs3KyBAfY0TwpCJ
o6BEqeUZtLN46oq3Xpj63w3kx8UMKCGYblSob2MhlyhiJzJJUQIEYW8P1ccAIf7L
UY0VfuW6VCxlq3c0j7qjvnVAKmsHkOH7be9QxStc4ZZPdsd6KdjeeDAbiJK2Q7Iv
rx09IWaEDyetBw8Bu+mjkRkOAGi07SJELbZZWaAZ86ao0sk9lAOTyJ4jWQT8Fvlh
fgg7Iu2TGP5MSjbnBC1tClr/8+JWOIKWGQ5RF8UQQBOGZxriEsp1RdmcsX4Vmpvw
MEnGgXQXYl2loSOI7Yn7S4IuNH85XVAdLVaOvrpwG3MJAN0aEEHIkK2eSzwhqI/E
3gsO28JG/E48IJh2zzwz
=2uV1
-----END PGP SIGNATURE-----

--bjuZg6miEcdLYP6q--
