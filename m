Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629AbaHKNvP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:51:15 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53692 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbaHKNvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:51:14 -0400
Date: Mon, 11 Aug 2014 08:50:34 -0500
From: Felipe Balbi <balbi@ti.com>
To: Richard Leitner <richard.leitner@skidata.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] usb: gadget: serial: remove PREFIX macro
Message-ID: <20140811135033.GD20177@saruman.home>
Reply-To: <balbi@ti.com>
References: <20140718113946.0e70c0cb@lxbuild.skidata.net>
 <20140811150435.6235fbf6@lxbuild.skidata.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IMjqdzrDRly81ofr"
Content-Disposition: inline
In-Reply-To: <20140811150435.6235fbf6@lxbuild.skidata.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--IMjqdzrDRly81ofr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 11, 2014 at 03:04:35PM +0200, Richard Leitner wrote:
> Hi,
> this patch was lying around for some time...
> are there any comments or objections on this?

you realise we're still in the middle of the merge window, right ?

--=20
balbi

--IMjqdzrDRly81ofr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJT6MopAAoJEIaOsuA1yqREdnAP/0QHddTAEKhBp2G34mnXc8nz
YI5aoIpbxyJha8+B+cKxJQAPxCYEN8cEmAMUU6aTK/T0asMl9coseDc9F1nc6VSP
2wMauX1lB0+dbGsBV0TWo9Dyh1iYyDw+bJUV2OlrOo0lKJVPotnLB0wXM9VJUjmx
DwjGL1iIUMr0p5fJ1C0itI68sZP3CNZItANELx/zMxprkACArhFDfDDU+k8pJPxG
V2iYmVFh00tWEkTI0IW1lFkmmZoIECXILjw3K1jr89e3YQZJ+L9ubfkybbI4DCSs
ewv0jDN0SBkmZvSLaItLsFLKUkUCYDtBPPsctf4EfbWqiurbXV22hWKEGn81O/Hq
nPJvDN9GlJDrUuQNFTewduaPw3C6YcK8tN7VLm+2NwdE+NUe9wAGwJ/8K9KFAFZG
Bb8RQVHoNYX/t8ysJy9frp8mbfxZBvke0mlVtRq4OAcMhrZQWErh6EM78ROJkaHV
P5H6esfzOXQjgyKlW4RzDQWKKMPh+9i+0TzsCgG5UmDKcld/SHJ0sjJteT3HmL83
owFQSb/T20oKgii9q7KSLLQkOxHL/7rmV+WPXU00jXkNn8+vFB5DgCYbj0NDG1Xb
El1AN4CJMO1wZ02iK5tvk+FTdO2JmQRDIAEaRNQ/smiglznsgcGbxlFjJN8nzlC1
BoB5cDRX1P92RMdOh6J1
=5rlg
-----END PGP SIGNATURE-----

--IMjqdzrDRly81ofr--
