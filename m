Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab3FLKW3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 06:22:29 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:58395 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab3FLKW2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 06:22:28 -0400
Date: Wed, 12 Jun 2013 12:22:24 +0200
From: Thierry Reding <thierry.reding@gmail.com>
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: [PATCH v3 1/5] pwm: Add Renesas TPU PWM driver
Message-ID: <20130612102223.GC30841@mithrandir>
References: <1370958344-19470-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
 <1370958344-19470-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sHrvAb52M6C8blB9"
Content-Disposition: inline
In-Reply-To: <1370958344-19470-2-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sHrvAb52M6C8blB9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 11, 2013 at 03:45:40PM +0200, Laurent Pinchart wrote:
[...]
> +static struct platform_driver tpu_driver = {
> +	.probe		= tpu_probe,
> +	.remove		= tpu_remove,
> +	.driver		= {
> +		.name	= "renesas_tpu_pwm",

You agreed to rename this to "renesas-tpu-pwm" after my review of v2.
Can you please fix that in the next version. It's the only remaining
issue: as I said, the other minor quibbles can be fixed up in a
subsequent patch.

Thierry

--sHrvAb52M6C8blB9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.20 (GNU/Linux)

iQIcBAEBAgAGBQJRuEvfAAoJEN0jrNd/PrOhW7wP/24moo3K7aqpOmXtEFmheHMw
3sF8RW0wnZqoqr3sxrYYfazVN5152yiecFwR32IGkaJaEklfNqMlsumtEdxZX/Ee
0kQE5EtdIGUOsk5piaRXN8UpDNmrcxDCUcavSAfETp17X1T74ZGa2XwaY1GFpXTd
iexnOAbyqoE+G8yeTo0z2VUUYrSVeOAujs2SMyV2739Ua6lBtcbozpYuFje6cfIU
Vi2uk15YphvJ8Tjg3THKREB1w5Bj8zwLb80ODNvDfcOVp0+QAuBkjUDVXmrqkXl9
okTH9M1cJ71E+mJ5hKwDdhCIGoYQ0bQ2vq01wG0DbLX0K3gqxZQ2gVDSIe30ojqg
tN+eYhrDqkl77TNM9gtnQL9vvP5NF9GqnAkrtZI9G2ZnldVfqHGwxNYVh8NuBZ6l
PwlDLQWkNCpVkIBReXQkkDUhOKKRALxdSI4F/Ja7kXFdaR+dIYWBPikja0y52ni7
Be7ja487HbuWApFFusqT2LWtQpCewtAJP6FdtfhERx4PArwuFTvdBn5HbIXG07kI
96gYtoQRkTEw+YuIDUHnBvssf6nJ0Kd5l573MZIU/badZGSVfJXTsZAJKv+9M2t2
IDZtySrY61ZwjEnbI5ezpfILzXU7vMnCS+qGazK159vijjfm6BA9f2a2VFGp2ZBb
MDz7azahSduOdI9XHpMu
=agby
-----END PGP SIGNATURE-----

--sHrvAb52M6C8blB9--
