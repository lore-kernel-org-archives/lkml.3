Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719AbaGOKpU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 06:45:20 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:36620 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758689AbaGOKpP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 06:45:15 -0400
Date: Tue, 15 Jul 2014 12:45:08 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Boris BREZILLON <boris.brezillon@free-electrons.com>
Cc: Rob Herring <robh+dt@kernel.org>, David Airlie <airlied@linux.ie>,
        Randy Dunlap <rdunlap@infradead.org>, dri-devel@lists.freedesktop.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] drm/panel: add support for Foxlink FL500WVR00-A0T
 panel
Message-ID: <20140715104504.GD6616@ulmo>
References: <1401976412-27436-1-git-send-email-boris.brezillon@free-electrons.com>
 <1401976412-27436-3-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+KJYzRxRHjYqLGl5"
Content-Disposition: inline
In-Reply-To: <1401976412-27436-3-git-send-email-boris.brezillon@free-electrons.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+KJYzRxRHjYqLGl5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 05, 2014 at 03:53:32PM +0200, Boris BREZILLON wrote:
> This panel is used by Atmel's SAMA5D3 Evaluation Kits (sama5d3xek) and
> supported by the simple-panel driver.
>=20
> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
> ---
>  .../bindings/panel/foxlink,fl500wvr00-a0t.txt      |  7 ++++++
>  drivers/gpu/drm/panel/panel-simple.c               | 25 ++++++++++++++++=
++++++
>  2 files changed, 32 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/panel/foxlink,fl500=
wvr00-a0t.txt

Applied, thanks.

Thierry

--+KJYzRxRHjYqLGl5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTxQYwAAoJEN0jrNd/PrOhZ7UP/0diwLK0N/BHEk9xgSCgsK6U
ic4PDhSG/b7KPTzas4ZdunRrESwWogGH+Gg6jwOPL4FeXuVY/kqI+nwQ7WU0gmNK
hM5ciEQXbNq/CmiBUPCKxHG7xiy22ATVP33/ZvdpB50tUded/tMbm3FkSmv2/evK
ItC6mvAQQznhc6U9dpp0lGN/bjVSIP3xQzt6KImeTlyaFAE1d4FheYg2pPLQJf1t
q0E6p6f1Es6brZBSKZ/kI4jEh0YnPUC6p82BOkjsZFaTmu1LTw+pbtvvsCly+qjt
rqKjXcE62UGt51UIWKcC8wzx/tyg8/N7V2zdEdCY/hJ1+F4igRtnyfWAvuDSlSpy
eGyJwuTO6TIxo3njvkL7/dH4THEJVfEQIyZ54822PSU6rAUOdKRmep+CxQdtDnEm
m6F65d//jfCcDpEl5LundpxwJMFaClIJe6m02EyZvCWyNxgrTJpwHeaNFo5a1pqf
L3ypckWtK1dl0q7fid2Hsbe+6tSTdliEMr8ZdUVW2CO6HQhVebl3t8pClFlSWm9+
6gdzq+ECQ4pkV5fdrb31YOn3iaQ+PP74TY93kXAq4CTaLweymf5j9MhkK7NksSjM
5OYOaf09ASpbDCLlDi81byq3YSeuNNe9U3Qf1r/ePTjWZ8ElhCRJBhJL9xznlE/5
wbPh3Kh8uQWSLd2Rqxhq
=p7ft
-----END PGP SIGNATURE-----

--+KJYzRxRHjYqLGl5--
